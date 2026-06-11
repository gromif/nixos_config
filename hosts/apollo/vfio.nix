{
  pkgs,
  lib,
  ...
}:

{
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  boot.extraModprobeConfig = "options vfio-pci disable_idle_d3=1";

  # Enable IOMMU for AMD. Crucially, do NOT add 'vfio-pci.ids=...' here for single GPU passthrough.
  boot.kernelParams = [
    # "vfio-pci.ids=1002:7550,1002:ab40"
    "amd_iommu=on"
    "iommu=pt" # Optional: Can improve performance for non-passed devices
    # "video=efifb:off" # Often needed to prevent the boot framebuffer from claiming the GPU
  ];

  virtualisation.libvirtd.hooks.qemu."win10" = pkgs.writeShellScript "win10-gpu-hook" ''
    VM_NAME="$1"
    OPERATION="$2"
    SUB_OPERATION="$3"
    TAG="win10"
    LOG="logger -t $TAG"

    export PATH=$PATH:${
      lib.makeBinPath (
        with pkgs;
        [
          util-linux
          coreutils-full
          systemd
          kmod
          libvirt
        ]
      )
    }

    $LOG "VM=$VM_NAME OP=$OPERATION STATE=$STATE"

    if [ "$VM_NAME" != "win10" ]; then
      exit 0
    fi

    if [ "$OPERATION" == "prepare" ] && [ "$SUB_OPERATION" == "begin" ]; then
      $LOG "Shutting down systemd services.."
      result=$(systemctl stop lactd.service display-manager.service user@1000.service)
      $LOG "$result"
      sleep 3s

      # Unload GPU modules
      while ! modprobe -r amdgpu; do sleep 1; done

      $LOG "Virsh unloading..."

      # Unbind the GPU from display driver
      $LOG "Detaching video.."
      virsh_video=$(virsh nodedev-detach pci_0000_03_00_0)
      $LOG "Detaching video result: $virsh_video"

      $LOG "Detaching audio.."
      virsh_audio=$(virsh nodedev-detach pci_0000_03_00_1)
      $LOG "Detaching audio result: $virsh_audio"

      $LOG "Setting up hugepages"
      hugepages=$(echo 12288 | tee /proc/sys/vm/nr_hugepages) # 24GiB
      $LOG "Setting up hugepages result: $hugepages"
      
      sleep 2s

      # Load VFIO Kernel Module
      $LOG "Loading VFIO.."
      vfio_load=$(modprobe vfio-pci)
      $LOG "Loading result: $vfio_load"
      $LOG "Finished!"
    elif [ "$OPERATION" == "release" ] && [ "$SUB_OPERATION" == "end" ]; then
      $LOG "Unloading VFIO.."
      while ! modprobe -r vfio-pci; do sleep 1; done

      $LOG "Removing hugepages.."
      hugepages=$(echo 0 | tee /proc/sys/vm/nr_hugepages)
      $LOG "Removing hugepages result: $hugepages"

      sleep 2s

      $LOG "Trying to rebind the GPU via Virsh.."
      $LOG "Reattaching video.."
      virsh_video=$(virsh nodedev-reattach pci_0000_03_00_0)
      $LOG "Reattaching video result: $virsh_video"

      $LOG "Reattaching audio.."
      virsh_audio=$(virsh nodedev-reattach pci_0000_03_00_1)
      $LOG "Reattaching audio result: $virsh_audio"

      $LOG "Loading amdgpu.."
      load_amdgpu=$(modprobe amdgpu)
      $LOG "Loading amdgpu result: $load_amdgpu"

      sleep 2s

      $LOG "Reviving systemd services.."
      reviving=$(systemctl start lactd.service display-manager.service)
      $LOG "Finished with: $reviving"
    fi
  '';
}
