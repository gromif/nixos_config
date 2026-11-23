{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  _cfg = config.nixfiles.support.config-update;
  _serviceName = "nixos-config-update";
  _script = pkgs.writeShellApplication {
    name = _serviceName;
    runtimeInputs = with pkgs; [
      git
      nixos-rebuild-ng
      hostname
    ];
    text = ''
      cd /etc/nixos

      git fetch origin main
      OLD_HEAD=$(git rev-parse HEAD)
      git reset --hard origin/main
      NEW_HEAD=$(git rev-parse HEAD)

      if [[ "$OLD_HEAD" == "$NEW_HEAD" ]]; then
        echo "No changes. Skipping rebuild."
        exit 0
      fi

      echo "Configuration changed. Rebuilding NixOS..."
      nixos-rebuild boot --flake "/etc/nixos#$(hostname)"
    '';
  };
in
{
  options.nixfiles.support.config-update = {
    enable = mkEnableOption "Automatic Flake fetch & apply";
  };

  config = mkIf _cfg.enable {
    systemd.services.${_serviceName} = {
      description = "Update and rebuild NixOS configuration";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${getExe _script}";

        Restart = "on-failure";
        RestartSec = "15min";
        TimeoutStartSec = "5min";

        StartLimitIntervalSec = "1h";
        StartLimitBurst = 12;
      };
    };

    systemd.timers.${_serviceName} = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "30min";
        Persistent = true;
      };
    };
  };
}
