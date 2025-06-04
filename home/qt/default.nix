# QT

{ config, pkgs, ... }:

{
  # Install Kvantum
  home.packages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
  ];
  
  # Set-up QT theming
  qt = {
  		enable = true;
  		platformTheme.name = "qtct";
  		style = { 
  		  name = "kvantum";
  		};
  	};
}
