{
  pkgs,
  lib,
  ...
}:

let
  recoveryServiceName = "mercury-recovery";
in
{
  systemd.services = {
    wireguard-wg0.onFailure = [ "${recoveryServiceName}.service" ];
    sshd.onFailure = [ "${recoveryServiceName}.service" ];
    "${recoveryServiceName}" = {
      description = "Recovery service for Mercury";

      serviceConfig = {
        Type = "oneshot";
      };

      path = with pkgs; [
        systemd
      ];
      script = ''
        sleep 300
        systemctl reboot    
      '';
    };
  };
}
