{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hmfiles.gnome;
  src = ./templates;
  templatesCategories = builtins.attrNames (builtins.readDir src);
  templates = builtins.listToAttrs (
    builtins.concatLists (
      map (
        d:
        map (f: {
          name = "Templates/${d}/${f}";
          value = {
            source = "${src}/${d}/${f}";
          };
        }) (builtins.attrNames (builtins.readDir "${src}/${d}"))
      ) templatesCategories
    )
  );
in
{
  options.hmfiles.gnome = {
    enable = mkEnableOption "common Gnome settings";
    enableQtTheme = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable a gnome-like qt theme";
    };
    enableTemplates = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include common templates";
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
    (mkIf cfg.enableTemplates {
      home.file = templates;
    })
  ]);
}
