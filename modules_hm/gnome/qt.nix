{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hmfiles.gnome.qt;
  stylesPath = ./qt/kvantum_styles;
  kvantumStylesList = builtins.attrNames (builtins.readDir stylesPath);
  kvantumStyles = builtins.listToAttrs (
    builtins.concatLists ( # concat lists: [ [ name = X; value = Y]... ]
      map (d: # map every style folder
        map (f: { # map every X style file as an environment.etc attribute
          name = "Kvantum/${d}/${f}";
          value = {
            source = "${stylesPath}/${d}/${f}";
            force = true;
          };
        }) (builtins.attrNames (builtins.readDir "${stylesPath}/${d}"))
      ) kvantumStylesList
    )
  );
in
{
  options.hmfiles.gnome.qt = {
    enableQtTheme = mkOption {
      type = types.bool;
      default = config.hmfiles.gnome.enable;
      description = "Whether to enable a gnome-like QT theme";
    };
    enableKvantumEngine = mkOption {
      type = types.bool;
      default = cfg.enableQtTheme;
      description = "Whether to enable the Kvantum QT engine";
    };
  };

  config = mkIf (cfg.enableQtTheme) (mkMerge [
    ({
      home.packages = with pkgs; [
        libsForQt5.qt5ct
        kdePackages.qt6ct
      ];

      xdg.configFile = {
        "qt5ct/qt5ct.conf".source = ./qt/qt5ct.conf;
        "qt6ct/qt6ct.conf".source = ./qt/qt6ct.conf;
      };

      qt = {
      	enable = true;
      	platformTheme.name = "qtct";
      };      
    })
    (mkIf cfg.enableKvantumEngine {
      home.packages = with pkgs; [
        kdePackages.qtstyleplugin-kvantum
      ];

      qt.style.name = "kvantum";    
      xdg.configFile = kvantumStyles;
    })
  ]);
}
