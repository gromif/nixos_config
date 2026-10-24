{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  _pkg = pkgs.openrgb; # The main OpenRGB package
  _defaultProfile = "white";
  _profilesInRepo = builtins.attrNames (builtins.readDir ./profiles);

  # Set up common commands
  rgb-load = pkgs.writeShellApplication {
    name = "rgb-load";
    runtimeInputs = [ _pkg ];
    text = ''
      echo "The target profile is $1"
      openrgb --very-verbose --nodetect --loglevel 0 -p "$1" &> /dev/null
    '';
  };
in
{
  hardware.i2c.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = _pkg;
    motherboard = "amd";
    startupProfile = _defaultProfile;
  };
  environment = {
    systemPackages = [
      rgb-load
    ]; # Install additional scripts
  };

  systemd.tmpfiles.settings = {
    "openrgb-configuration"."/var/lib/OpenRGB/Configuration.json"."L+".argument = "${
      ./Configuration.json
    }";
    "openrgb-profiles" = builtins.listToAttrs (
      map (p: {
        name = "/var/lib/OpenRGB/profiles/${p}";
        value."L+" = {
          mode = "0755";
          argument = "${./profiles/${p}}";
        };
      }) _profilesInRepo
    );
  };

  powerManagement.powerDownCommands = ''
    ${getExe rgb-load} off
  '';

  systemd.services."openrgb-onResume" = {
    after = [ "sleep.target" ];
    path = [ rgb-load ];
    script = "rgb-load ${_defaultProfile}";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = config.systemd.services.openrgb.serviceConfig.WorkingDirectory;
    };
    bindsTo = [ "openrgb.service" ];
    wantedBy = [ "sleep.target" ];
  };
}
