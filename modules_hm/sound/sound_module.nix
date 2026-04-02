{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixfiles.hm.sound;
  path = ../sound/pipewire;
in
{
  options.nixfiles.hm.sound = {
    pipewireConfig = mkOption {
      type = types.enum [ "none" "apollo" ];
      default = "apollo";
      description = "Whether to apply preconfigured pipewire configurations";
    };
  };

  config = mkMerge [
    (mkIf (cfg.pipewireConfig == "apollo") {
      xdg.configFile = {
        "pipewire/pipewire.conf" = {
          force = true;
          source = path + "/pipewire.conf";
        };
        "pipewire/hrtf.wav" = {
          force = true;
          source = path + "/hrtf.wav";
        };
        "pipewire/minimal.conf" = {
          force = true;
          source = path + "/minimal.conf";
        };
      };      
    }) 
  ];
}
