{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.gnome.extensions.light-style;
  extension = pkgs.gnomeExtensions.light-style;
in

{
  options.hmfiles.gnome.extensions.light-style = {
    enable = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable the Light Style extension";
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
