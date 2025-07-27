# User - Alex - Gaming


{ config, pkgs, lib, ... }:

{
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
    extraPackages = with pkgs; [ mangohud ];
  };
  
  # Custom lsfg-vk flake setup
  services.lsfg-vk = {
    enable = true;
    ui.enable = true; # installs gui for configuring lsfg-vk
  };
}
