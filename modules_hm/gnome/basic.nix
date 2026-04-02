{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hmfiles.gnome;
in
{
  options.hmfiles.gnome = {
    enable = mkEnableOption "common Gnome settings";
    enableQtTheme = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable a gnome-like qt theme";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ({
      home.packages = with pkgs; [
        dconf2nix
      ];

      dconf.enable = true;
      services.gnome-keyring.enable = true;      
    })
  ]);
}
