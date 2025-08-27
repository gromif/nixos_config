# User - Alex - QT - Kvantum


{ config, pkgs, ... }:

{
  # Set up basic packages
  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
  ];
  
  # Declare config files
  environment.etc = {
    
  };
  
  # Set up QT theming
  qt.style = "kvantum";
}
