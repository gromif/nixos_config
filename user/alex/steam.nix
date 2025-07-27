# User - Alex - Steam


{ config, pkgs, lib, ... }:

{
  # Set up Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
      };
    };
    extraPackages = with pkgs; [ mangohud ];
  };
}
