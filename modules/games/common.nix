# Gaming - Common

{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Automatically load the NTSYNC module
  boot.kernelModules = [ "ntsync" ];
  environment.variables = {
    WINENTSYNC = 1;
    PROTON_USE_NTSYNC = 1;
  };

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
