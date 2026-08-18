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
      wireguard-tools
    ];
    script = ''
      before=$(wg show wg0 transfer | awk '{rx += $2; tx += $3} END {print rx + tx}')
      sleep 10
      after=$(wg show wg0 transfer | awk '{rx += $2; tx += $3} END {print rx + tx}')

      if [ "$after" -gt "$before" ]; then
        echo "WireGuard traffic detected"
      else
        echo "No WireGuard traffic. Shutting down..."
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
