# Home


{ config, pkgs, ... }:

{
  imports = [];
  
  # MangoHud
  home.file = {
    ".config/MangoHud/MangoHud.conf" = {
      force = true;
      source = ../config/MangoHud/MangoHud.conf;
    };
    ".config/MangoHud/custom.conf" = {
      force = true;
      source = ../config/MangoHud/MangoHud.conf;
    };
  };
  
}
