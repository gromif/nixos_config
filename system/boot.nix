# Boot


{ config, pkgs, ... }:

{
  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_15;
  boot.kernelParams = [
    # Main display overdrive
    "video=HDMI-A-2:1920x1080@83"
    # AMDGPU Overclock Support
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="VirtualCam" exclusive_caps=1
  '';
  
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
