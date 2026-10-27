{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  _pkgs = pkgs.gnomeExtensions;
  _exts = {
    appindicator = { };
    blur-my-shell."org/gnome/shell/extensions/blur-my-shell/panel".force-light-text = true;
    brightness-control-using-ddcutil."org/gnome/shell/extensions/display-brightness-ddcutil" = {
      ddcutil-binary-path = "${getExe pkgs.ddcutil}";
      button-location = 1;
      position-system-menu = 1.0;
      hide-system-indicator = true;
      allow-zero-brightness = true;
      show-display-name = false;
    };
    caffeine = { };
    gsconnect = { };
    legacy-gtk3-theme-scheme-auto-switcher = { };
    light-style = { };
  };
  _enabledExts = filterAttrs (name: _: config.hmfiles.gnome.extensions.${name}.enable) _exts;
  _enabledExtsUuids = mapAttrsToList (name: _: _pkgs.${name}.extensionUuid) _enabledExts;
  _enabledExtsSettings = builtins.attrValues _enabledExts;
in
{
  options.hmfiles.gnome.extensions = builtins.mapAttrs (name: _: {
    enable = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable \''${name}\'' extension";
    };
  }) _exts;

  config = mkIf config.hmfiles.gnome.enable {
    home.packages = mapAttrsToList (name: _: _pkgs.${name}) _enabledExts;
    dconf.settings = {
      "org/gnome/shell".enabled-extensions = _enabledExtsUuids;
    }
    // (mergeAttrsList _enabledExtsSettings);
  };
}
