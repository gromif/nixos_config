# Boot


{ config, pkgs, ... }:

{
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
