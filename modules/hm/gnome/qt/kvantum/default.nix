# Kvantum


{ config, pkgs, ... }:

let
  defaultTheme = "KvLibadwaita";
in
{
  imports = [ ./styles.nix ];
  
  # Set up basic packages
  home.packages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
  ];
  
  # Set up QT theming
  qt.style.name = "kvantum";
}
