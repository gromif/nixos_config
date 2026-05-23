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
    "video=efifb:off" # Often needed to prevent the boot framebuffer from claiming the GPU
  ];

  virtualisation.libvirtd.hooks.qemu."win10" = pkgs.writeShellScript "win10-gpu-hook" ''
    VM_NAME="$1"
    OPERATION="$2"
    SUB_OPERATION="$3"
    if [ "$VM_NAME" != "win10" ]; then
      exit 0
    fi
    if [ "$OPERATION" == "prepare" ] && [ "$SUB_OPERATION" == "begin" ]; then
      ${pkgs.systemd}/bin/systemctl stop display-manager
      sleep 3
    elif [ "$OPERATION" == "stopped" ] && [ "$SUB_OPERATION" == "end" ]; then
      touch /home/stop_test
      sleep 10
      # echo 0000:03:00.0 > /sys/bus/pci/drivers/vfio-pci/unbind
      # echo 1 > /sys/bus/pci/devices/0000:03:00.0/reset
      # echo 0000:03:00.0 > /sys/bus/pci/drivers/amdgpu/bind
      # ${pkgs.systemd}/bin/systemctl start display-manager 2> /home/dm.txt
      # sleep 10
      # ${pkgs.systemd}/bin/systemctl reboot -i
    fi
  '';
}
