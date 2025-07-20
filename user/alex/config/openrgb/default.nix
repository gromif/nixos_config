# User - Alex - Config - OpenRGB - Profiles


{ pkgs, lib, ... }:

let
  profile = "Latte";
  disabledProfile = "Disabled";
in
{
  # Set up UDEV rules
  services.udev.packages = with pkgs; [ openrgb-with-all-plugins ];
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  
  systemd.user.services = {
    openrgb-boot = {
      path = [ pkgs.openrgb-with-all-plugins ];
      script = "openrgb --profile ${profile}";
      wantedBy = [ "default.target" "reboot.target" ];
    };
  };
  
  # Temp files cleanup
  systemd.user.tmpfiles.rules = [
    "R %h/.config/OpenRGB/logs/* - - - - -"
  ];
}
