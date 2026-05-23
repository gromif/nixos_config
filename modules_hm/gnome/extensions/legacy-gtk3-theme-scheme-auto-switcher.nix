{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.gnome.extensions.legacy-gtk3-theme-scheme-auto-switcher;
  extension = pkgs.gnomeExtensions.legacy-gtk3-theme-scheme-auto-switcher;
in

{
  options.hmfiles.gnome.extensions.legacy-gtk3-theme-scheme-auto-switcher = {
    enable = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable the Legacy GTK 3 theme scheme auto switcher extension";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ extension ];

    dconf.settings = {
      # Enable extension
      "org/gnome/shell".enabled-extensions = [ extension.extensionUuid ];
    };
  };
}
