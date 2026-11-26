{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  _cfg = config.nixfiles.support.hagezi-update;
  _serviceName = "nixos-hagezi-update";
  _script = pkgs.writeShellApplication {
    name = _serviceName;
    runtimeInputs = with pkgs; [
      openssh
      git
      curl
    ];
    text = ''
      cd /etc/nixos

      curl -L "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro-onlydomains.txt" -o misc/hagezi_pro
      git add misc/hagezi_pro
      git commit -m "support[hagezi-update]: update blocklist" --only misc/hagezi_pro
      git push
    '';
  };
in
{
  options.nixfiles.support.hagezi-update = {
    enable = mkEnableOption "Auto-fetch Hagezi blocklist";
  };

  config = mkIf _cfg.enable {
    systemd.services.${_serviceName} = {
      description = "Update and Push Hagezi blocklist";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${getExe _script}";

        # Explicitly allow writes to the NixOS configuration directory
        ReadWritePaths = [
          "/etc/nixos"
          "/nix/store" # May be needed for build outputs (see note below)
        ];
        ProtectProc = "invisible";
        PrivateUsers = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectHostname = "private";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictSUIDSGID = true;
        PrivateTmp = true;
        PrivateDevices = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        NoNewPrivileges = true;
        CapabilityBoundingSet = [ "" ];
      };
    };

    systemd.timers.${_serviceName} = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "weekly";
        RandomizedDelaySec = "1h";
        Persistent = true;
      };
    };
  };
}
