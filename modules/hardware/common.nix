# Hardware - Common


{ config, lib, ... }:

with lib;

let
  gpuVendors = [ "amd" "intel" "none" ];
  cfg = config.prefs.hardware.graphics;
  
  inherit (types)
    str;
in
{
  options.prefs.hardware.graphics = {
    gpuVendor = mkOption {
      type = str;
      description = ''
        Automaticaly installs drivers for the selected GPU vendor.
        Supported vendors: ${toString gpuVendors}
      '';
      example = ''
        intel
      '';
      default = "none";
    };
  };

  config = let
    isValid = if (builtins.elem(cfg.gpuVendor) gpuVendors) then true else throw "prefs: unsupported GPU vendor!";
  in mkIf (isValid) {
    hardware = {
      bluetooth.powerOnBoot = false;
      enableRedistributableFirmware = true;
      graphics = mkIf (cfg.gpuVendor == "amd" || cfg.gpuVendor == "intel") {
        enable = true;
        enable32Bit = true;
      };
    };

    services.fstrim.enable = true; # Enable FSTrim (weekly)
  };
}
