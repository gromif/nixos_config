# Boot - Modules - v4l2loopback


{ config, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="VirtualCam" exclusive_caps=1
  '';
}
