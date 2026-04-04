{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.gnome.extensions.caffeine;
  extension = pkgs.gnomeExtensions.caffeine;
in

{
  options.hmfiles.gnome.extensions.caffeine = {
    enable = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable the Caffeine extension";
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
