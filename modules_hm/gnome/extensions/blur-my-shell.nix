{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.gnome.extensions.blur-my-shell;
  extension = pkgs.gnomeExtensions.blur-my-shell;
in

{
  options.hmfiles.gnome.extensions.blur-my-shell = {
    enable = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable the Blur My Shell extension";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ extension ];

    dconf.settings = {
      # Enable extension
      "org/gnome/shell".enabled-extensions = [ extension.extensionUuid ];

      # Add extension settings
      "org/gnome/shell/extensions/blur-my-shell/panel".force-light-text = true;
    };
  };
}
