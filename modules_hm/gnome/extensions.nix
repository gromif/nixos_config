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
    blur-my-shell =
      let
        root = "org/gnome/shell/extensions/blur-my-shell";
      in
      {
        "${root}/appfolder" = {
          blur-behind-folders = true;
          pipeline = "pipeline_default";
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default_light";
        };

        "${root}/applications" = {
          pipeline = "pipeline_default";
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default_light";
        };

        "${root}/dash-to-dock" = {
          override-background = true;
          pipeline = "pipeline_default_light";
          pipeline-auto-mode = true;
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default_light";
          style-dash-to-dock = 0;
          unblur-in-overview = true;
        };

        "${root}/dash-to-panel" = {
          blur-original-panel = false;
        };

        "${root}/lockscreen" = {
          pipeline = "pipeline_default";
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default_light";
        };

        "${root}/overview" = {
          pipeline = "pipeline_default";
          pipeline-auto-mode = false;
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default";
          style-components = 2;
        };

        "${root}/panel" = {
          force-light-text = true;
          match-theme-in-overview = false;
          override-background = true;
          override-background-dynamically = false;
          pipeline = "pipeline_default";
          pipeline-auto-mode = false;
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default";
          style-panel = 0;
          unblur-in-overview = false;
        };

        "${root}/popup" = {
          pipeline = "pipeline_default";
          pipeline-auto-mode = false;
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default_light";
          preserve-shell-theme = false;
          static-blur = false;
          style-popup = 3;
        };

        "${root}/screenshot" = {
          pipeline = "pipeline_default";
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default_light";
        };

        "${root}/window-list" = {
          blur = false;
          pipeline = "pipeline_default";
          pipeline-dark = "pipeline_default";
          pipeline-light = "pipeline_default_light";
        };
      };
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
