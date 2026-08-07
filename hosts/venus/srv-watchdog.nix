{
  pkgs,
  lib,
  ...
}:

let
  name = "srv-watchdog";
in
{
  systemd.services."${name}" = {
    description = "Power off if no SSH users are logged in";

    serviceConfig = {
      Type = "oneshot";
    };

    path = with pkgs; [
      systemd
      gnugrep
      iproute2
    ];
    script = ''
      if ! ss -lunp | grep ":17238"; then
        echo "No SSH sessions found, powering off."
        sleep 30s
        systemctl poweroff
      fi
    '';
  };

  systemd.timers."${name}" = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "30min";
      OnUnitActiveSec = "30min";
      Unit = "${name}.service";
    };
  };
}
