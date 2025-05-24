# Boot


{ config, pkgs, ... }:

{
  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_14;
  boot.kernelParams = [
    # Main display overdrive
    "video=HDMI-A-2:1920x1080@83"
    # AMDGPU Overclock Support
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
  
  # Bootloader
  boot.loader = {
    timeout = 0;
    systemd-boot = {
      enable = true;
      editor = false;
      memtest86.enable = true;
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
}
