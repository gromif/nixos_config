# User - Alex - QT - Kvantum


{ config, pkgs, ... }:

let
  theme = "KvLibadwaitaDark";
in
{
  # Set up basic packages
  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
  ];
  
  # Declare the config file
  environment.etc."xdg/Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=${theme}
  '';
  
  # Set up QT theming
  qt.style = "kvantum";
}
