{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.gnome.extensions.gsconnect;
  extension = pkgs.gnomeExtensions.gsconnect;
in

{
  options.hmfiles.gnome.extensions.gsconnect = {
    enable = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable the Gsconnect extension";
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
