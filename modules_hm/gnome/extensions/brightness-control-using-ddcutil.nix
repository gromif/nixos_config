{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.gnome.extensions.brightness-control-using-ddcutil;
in

{
  options.hmfiles.gnome.extensions.brightness-control-using-ddcutil = {
    enable = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable the Display Brightness Slider for Gnome Shell extension";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.gnomeExtensions; [
      brightness-control-using-ddcutil
    ];

    dconf.settings = {
      # Enable extension
      "org/gnome/shell".enabled-extensions = with pkgs.gnomeExtensions; [
        brightness-control-using-ddcutil.extensionUuid
      ];

      # Add extension settings
      "org/gnome/shell/extensions/display-brightness-ddcutil" = {
        ddcutil-binary-path = "${getExe pkgs.ddcutil}";
        button-location = 1;
        position-system-menu = 1.0;
        hide-system-indicator = true;
        allow-zero-brightness = true;
        show-display-name = false;
      };
    };
  };
}
