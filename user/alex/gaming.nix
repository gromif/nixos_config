# User - Alex - Gaming


{ config, pkgs, lib, ... }:

{
  # Automatically load the NTSYNC module
  boot.kernelModules = [ "ntsync" ];
  
  # Set up Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    package = pkgs.steam.override {
      extraEnv = {
        ENABLE_LSFG = true;
        MANGOHUD = true;
      };
    };
    extraPackages = with pkgs; [ 
      mangohud
      config.services.lsfg-vk.package
    ];
  };
  
  # Custom lsfg-vk flake setup
  services.lsfg-vk = {
    enable = true;
    ui.enable = true; # installs gui for configuring lsfg-vk
  };
}
