# User - Alex - QT


{ config, pkgs, ... }:

{
  imports = [ ./kvantum ];
  # Set up basic packages
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
  ];
  
  # Declare config files
  environment.etc = {
    "qt5ct/qt5ct.conf".source = ./qt5ct.conf;
    "qt6ct/qt6ct.conf".source = ./qt6ct.conf;
  };
  
  # Set up QT theming
  qt = {
  		enable = true;
  		platformTheme = "qt5ct";
  	};
}
