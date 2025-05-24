# QT

{ config, pkgs, ... }:

{
  # Install Kvantum
  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
  ];
  
  # Set-up QT theming
  qt = {
  		enable = true;
  		platformTheme = "qt5ct";
  		style = "kvantum";
  	};
}
