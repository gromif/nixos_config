# User - Alex - Config - OpenRGB


{ config, pkgs, ... }:

let
  pkg-openrgb = pkgs.openrgb-with-all-plugins;
  profilesDir = "${config.users.users.alex.home}/.config/OpenRGB";
  
  rgb-next = pkgs.writeShellApplication {
    name = "rgb-next";
    runtimeInputs = with pkgs; [ pkg-openrgb findutils coreutils ];
    text = ''
      targetProfile=$(find "${profilesDir}/" -type l -name "*.orp" | shuf -n 1)
      echo "The target profile is $targetProfile"
      openrgb -p "$targetProfile"
    '';
  };
  rgb-next-systemd = "rgb-next";
in
{
  environment.systemPackages = [ pkg-openrgb rgb-next ];
  # Set up UDEV rules
  services.udev.packages = [ pkg-openrgb ];
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  
  # Set a random profile on boot
  systemd.user = {
    services."${rgb-next-systemd}" = {
      path = [ rgb-next ];
      script = "rgb-next";
    };
    timers."${rgb-next-systemd}" = {
      timerConfig = {
        OnBootSec = "1s";
        Unit = "${rgb-next-systemd}.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
  
  # Temp files cleanup
  systemd.user.tmpfiles.rules = [
    "R %h/.config/OpenRGB/logs/* - - - - -"
  ];
}
