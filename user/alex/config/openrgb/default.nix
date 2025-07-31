# User - Alex - Config - OpenRGB


{ config, pkgs, lib, ... }:

let
  openrgbRoot = "/var/lib/OpenRGB";
  profilesDir = "OpenRGB/profiles"; # /etc...
  activeProfile = "/etc/OpenRGB/active";
  systemdServiceName = "rgb-next";
  
  # Set up profiles
  configProfilesDir = builtins.toPath ./profiles;
  profileNames = builtins.attrNames (builtins.readDir configProfilesDir);
  profileFileAttrs = builtins.listToAttrs (
    map (p: {
      name = "${p}";
      value = {
        source = "${configProfilesDir}/${p}";
        target = "${profilesDir}/${p}";
      };
    }) profileNames
  );
  
  # Set up common commands
  rgb-load = pkgs.writeShellApplication {
    name = "rgb-load";
    runtimeInputs = [ config.services.hardware.openrgb.package ];
    text = ''
      echo "The target profile is $1"
      openrgb --very-verbose --nodetect --loglevel 0 -p "$1" &> /dev/null
    '';
  };
  rgb-next = pkgs.writeShellApplication {
    name = "rgb-next";
    runtimeInputs = [ 
      rgb-load
      pkgs.findutils
      pkgs.coreutils
    ];
    text = ''
      targetProfile=$(find "/etc/${profilesDir}/" -type l -name "*.orp" | shuf -n 1)
      ln -sf "$targetProfile" "${activeProfile}"
      rgb-load "$targetProfile"
    '';
  };
  rgb-restore = pkgs.writeShellApplication {
    name = "rgb-restore";
    runtimeInputs = [ rgb-load ];
    text = ''
      rgb-load "${activeProfile}"
    '';
  };
in
{
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
  environment = {
    systemPackages = [ rgb-load rgb-next rgb-restore ];
    etc = profileFileAttrs;
  };
  
  systemd.services = {
    # Restore the last active profile on resume
    "${systemdServiceName}-onResume" = {
      after = [ "sleep.target" ];
      path = [ rgb-restore ];
      script = "rgb-restore";
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = config.systemd.services.openrgb.serviceConfig.WorkingDirectory;
      };
      bindsTo = [ "openrgb.service" ];
      wantedBy = [ "sleep.target" ];
    };
    # Modify the default openrgb service
    "${systemdServiceName}" = {
      path = [ rgb-next ];
      preStart = "sleep 2s";
      script = "rgb-next";
      postStart = "rm -R /tmp/logs; rm -R ${openrgbRoot}/logs/*";
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = "/tmp";
      };
      requires = [ "openrgb.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
