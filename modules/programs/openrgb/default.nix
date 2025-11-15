# User - Alex - Config - OpenRGB


{ config, pkgs, lib, ... }:

let
  pkg = pkgs.openrgb-with-all-plugins; # The main OpenRGB package
  profilesDir = "OpenRGB/profiles"; # /etc...
  activeProfile = "/etc/OpenRGB/active"; # Preserve an active profile
  
  # Set up profiles
  conf_profilesDir = ./profiles;
  profileNames = builtins.attrNames (builtins.readDir conf_profilesDir);
  profileFileAttrs = builtins.listToAttrs (
    map (p: {
      name = "${p}";
      value = {
        source = "${conf_profilesDir}/${p}";
        target = "${profilesDir}/${p}";
      };
    }) profileNames
  );
  
  # Set up common commands
  rgb-load = pkgs.writeShellApplication {
    name = "rgb-load";
    runtimeInputs = [ pkg ];
    text = ''
      echo "The target profile is $1"
      openrgb --very-verbose --nodetect --loglevel 0 -p "$1" &> /dev/null
    '';
  };
  openrgb-service-wrapper = pkgs.writeShellApplication {
    name = "openrgb-service-wrapper";
    runtimeInputs = [ pkg ];
    text = ''
      targetProfile=$(find "/etc/${profilesDir}/" -type l -name "*.orp" | shuf -n 1)
      ln -sf "$targetProfile" "${activeProfile}"
      openrgb --server --server-port ${toString config.services.hardware.openrgb.server.port} -p "$targetProfile"
    '';
  };
in
{
  services.hardware.openrgb = {
    enable = true;
    package = pkg;
  };
  environment = {
    systemPackages = [ rgb-load openrgb-service-wrapper ]; # Install additional scripts
    etc = profileFileAttrs; # Symlink profiles
  };
  
  systemd.services = {
    # Restore the last active profile on resume
    "openrgb-onResume" = {
      after = [ "sleep.target" ];
      path = [ rgb-load ];
      script = ''
        rgb-load "${activeProfile}"
      '';
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = config.systemd.services.openrgb.serviceConfig.WorkingDirectory;
      };
      bindsTo = [ "openrgb.service" ];
      wantedBy = [ "sleep.target" ];
    };
    # Modify the default openrgb service
    openrgb.serviceConfig.ExecStart = lib.mkForce "${lib.getExe openrgb-service-wrapper}";
  };

  # Persist data
  environment.impermanence.files = [
    "/var/lib/OpenRGB/OpenRGB.json"
  ];
}
