{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.gaming;

  pkgs_lsfg = pkgs.lsfg-vk;
in
{
  options.nixfiles.gaming = {
    enable = mkEnableOption "gaming-optimised environment";
    enableLSFG = mkEnableOption "LSFG support";
    supportHypervisor = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to support Hypervisor bypass";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      boot.kernelModules = [ "ntsync" ]; # Automatically load the NTSYNC module

      environment.variables = {
        WINENTSYNC = 1;
        PROTON_USE_NTSYNC = 1;
        PROTON_ENABLE_WAYLAND = 1;
      };

      # Set up Steam
      programs.steam = {
        enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
        package = pkgs.steam.override {
          extraEnv = {
            ENABLE_LSFG = cfg.enableLSFG;
            MANGOHUD = true;
            PROTON_ENABLE_WAYLAND = 1;
          };
        };
        extraPackages =
          with pkgs;
          [
            adwaita-icon-theme
            mangohud
          ]
          ++ optionals cfg.enableLSFG [ pkgs_lsfg ];
      };

      environment.systemPackages = mkIf (cfg.enableLSFG) [ pkgs_lsfg ];
    }
    (mkIf cfg.supportHypervisor {
      boot.kernelParams = [
        "clearcpuid=umip" # Trade-off: Hypervisor via Proton
      ];
    })
  ]);
}
