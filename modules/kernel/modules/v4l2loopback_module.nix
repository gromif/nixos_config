{ config, lib, ... }:

with lib;

{
  options.nixfiles.boot.kernelModules.v4l2loopback = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the v4l2loopback module.";
    };
  };

  config = mkIf config.nixfiles.boot.kernelModules.v4l2loopback.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="VirtualCam" exclusive_caps=1
    '';
  };
}
