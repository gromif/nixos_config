# Home - Config - QT


{ config, pkgs, ... }:

{
  xdg.configFile = {
    "qt5ct/qt5ct.conf" = {
      force = true;
      source = ../qt/qt5ct.conf;
    };
    "qt6ct/qt6ct.conf" = {
      force = true;
      source = ../qt/qt6ct.conf;
    };
  };
}
