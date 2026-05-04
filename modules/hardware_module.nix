# Hardware - Common

{ config, lib, ... }:

with lib;

let
  gpuVendors = [
    "amd"
    "intel"
    "none"
  ];
  cfg = config.nixfiles.hardware;
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
        type = types.enum [
          "none"
          "amd"
          "intel"
        ];
        description = "Automaticaly installs drivers for the selected GPU vendor";
        default = "none";
      };
    };
    rootfs = mkOption {
      type = types.str;
      default = "undefined";
      description = "Automatically identified root file system";
    };
  };

  config = mkMerge [
    ({
      nixfiles.hardware.rootfs = mkForce (
        (if config.nixfiles.impermanence.enable then config.fileSystems."/nix" else config.fileSystems."/")
        .fsType
      );
    })
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
    (mkIf (cfg.graphics.vendor == "amd") {
      hardware.amdgpu.overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
      services.lact.enable = true;
    })
  ];
}
