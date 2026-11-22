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
