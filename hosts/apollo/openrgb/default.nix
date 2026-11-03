{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  _pkg = pkgs.openrgb; # The main OpenRGB package
  _pkgData = "/root/.config/OpenRGB";
  _defaultProfile = "white";
  _profilesInRepo = builtins.attrNames (builtins.readDir ./profiles);

  # Set up common commands
  _rgb-load = pkgs.writeShellApplication {
    name = "rgb-load";
    runtimeInputs = [ _pkg ];
    text = ''
      echo "The target profile is $1"
      openrgb --very-verbose --nodetect --noautoconnect --loglevel 0 -p "$1" &> /dev/null
    '';
  };
in
{
  hardware.i2c.enable = true;
  services.udev.packages = [ _pkg ];
  boot.kernelModules = [
    "i2c-dev"
    "i2c-piix4"
  ];
  environment.systemPackages = with pkgs; [
    _rgb-load
    _pkg
  ]; # Install additional scripts

  systemd.tmpfiles.settings = {
    "openrgb-configuration"."${_pkgData}/Configuration.json"."L+".argument = "${./Configuration.json}";
    "openrgb-profiles" = builtins.listToAttrs (
      map (p: {
        name = "${_pkgData}/profiles/${p}";
        value."L+" = {
          mode = "0755";
          argument = "${./profiles/${p}}";
        };
      }) _profilesInRepo
    );
  };

  powerManagement.powerDownCommands = ''
    ${getExe _rgb-load} off
  '';

  systemd.services."openrgb-onResume" = {
    after = [ "sleep.target" ];
    path = [ _rgb-load ];
    script = "rgb-load ${_defaultProfile}";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = _pkgData;
    };
    wantedBy = [ "sleep.target" ];
  };
}
