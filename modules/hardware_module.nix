# Hardware - Common


{ config, lib, ... }:

with lib;

let
  gpuVendors = [ "amd" "intel" "none" ];
  cfg = config.nixfiles.hardware.graphics; 
in
{
  options.nixfiles.hardware = {
    enableCommon = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable common hardware settings";
    };
    graphics = {
      vendor = mkOption {
        type = types.enum [ "none" "amd" "intel" ];
        description = "Automaticaly installs drivers for the selected GPU vendor";
        default = "none";
      };      
    };
  };

  config = mkMerge [
    (mkIf cfg.enableCommon {
      hardware = {
        enableRedistributableFirmware = true;
        bluetooth.powerOnBoot = false;
      };
    })
    (mkIf (cfg.graphics.vendor == "amd" || cfg.graphics.vendor == "intel") {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })
  ];
}
