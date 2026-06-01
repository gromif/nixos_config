{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.gaming;
in
{
  options.nixfiles.gaming = {
    enable = mkEnableOption "gaming-optimised environment";
    enableLSFG = mkEnableOption "LSFG support";
  };

  config = mkIf (cfg.enable) {
    # Automatically load the NTSYNC module
    boot.kernelModules = [ "ntsync" ];
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
          ENABLE_LSFG = mkIf (cfg.enableLSFG) true;
          MANGOHUD = true;
        };
      };
      extraPackages =
        with pkgs;
        [
          mangohud
        ]
        ++ (if cfg.enableLSFG then (with pkgs; [ lsfg-vk ]) else [ ]);
    };

    environment.systemPackages = mkIf (cfg.enableLSFG) (
      with pkgs;
      [
        lsfg-vk
      ]
    );
  };
}
