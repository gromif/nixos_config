# Home - Config - QT


{ config, pkgs, ... }:

{
  home.file = {
    ".config/qt5ct/qt5ct.conf" = {
      force = true;
      source = ../qt/qt5ct.conf;
    };
    ".config/qt6ct/qt6ct.conf" = {
      force = true;
      source = ../qt/qt6ct.conf;
    };
  };
}
