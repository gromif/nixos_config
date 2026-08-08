{
  config,
  pkgs,
  ...
}:

let
  initrdHostKey = config.sops.secrets."ssh/initrd".path;
  recoveryServiceName = "mercury-recovery";
in
{
  # Allow login during initrd, in case it hangs.
  boot.initrd = {
    systemd = {
      enable = true;
      network.enable = true;
    };
    availableKernelModules = [ "e1000e" ];
    network = {
      # enable = true;
      ssh = {
        enable = true;
        port = 4447;
        authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        # Use a fixed host key. The same one as for the main host, thanks.
        hostKeys = [ initrdHostKey ];
      };
    };
  };

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
