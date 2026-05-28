{
  pkgs,
  ...
}:

{
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

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
    SYSTEMCTL=${pkgs.systemd}/bin/systemctl
    MODPROBE=${pkgs.kmod}/bin/modprobe
    LOG=/nix/state/vm.log

    export PATH=$PATH:${pkgs.libvirt}/bin

    if [ "$VM_NAME" != "win10" ]; then
      exit 0
    fi

    if [ "$OPERATION" == "prepare" ] && [ "$SUB_OPERATION" == "begin" ]; then
      echo "Stopping systemd services..." > $LOG
      $SYSTEMCTL stop lactd.service display-manager.service user@1000.service >> $LOG
      sleep 3s
      
      # Unload GPU modules
      while ! $MODPROBE -r amdgpu; do sleep 1; done

      echo "virsh unloading..." >> $LOG
      
      # Unbind the GPU from display driver
      virsh nodedev-detach pci_0000_03_00_0 >> $LOG
      virsh nodedev-detach pci_0000_03_00_1 >> $LOG

      sleep 2s

      # Load VFIO Kernel Module
      echo "loading vfio..."
      $MODPROBE vfio-pci >> $LOG
    elif [ "$OPERATION" == "release" ] && [ "$SUB_OPERATION" == "end" ]; then
      echo "trying to restore the GPU state" >> $LOG
      
      # Unload VFIO Kernel Module
      while ! $MODPROBE -r vfio-pci >> $LOG; do sleep 1; done

      sleep 2s

      echo "virsh rebind" >> $LOG
      # Bind the GPU to display driver
      virsh nodedev-reattach pci_0000_03_00_0 >> $LOG 
      virsh nodedev-reattach pci_0000_03_00_1 >> $LOG

      echo "modprobe amdgpu"
      # Load GPU Modules
      $MODPROBE amdgpu >> $LOG

      sleep 2s

      echo "reviving systemd services" >> $LOG
      # Start Services
      $SYSTEMCTL start lactd.service display-manager.service >> $LOG
    fi
  '';
}
