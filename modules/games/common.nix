# Gaming - Common


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
      lsfg-vk
    ];
  };
  
  environment.systemPackages = with pkgs; [
    lsfg-vk
  ];
}
