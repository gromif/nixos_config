{ config, ... }:

let
  keyPath = config.sops.secrets."ssh/initrd".path;
in
{
  # Run SSHD even in emergency mode.
  systemd.services = {
    sshd.wantedBy = [
      "emergency.target"
      "rescue.target"
    ];
    dhcpcd.wantedBy = [
      "emergency.target"
      "rescue.target"
    ];
  };

  # Allow login during initrd, in case it hangs.
  boot.initrd = {
    systemd = {
      enable = true;
      network.enable = true;
      emergencyAccess = true;
    };
    availableKernelModules = [ "e1000e" ];
    network = {
      # enable = true;
      ssh = {
        enable = true;
        port = 12844;
        authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        # Use a fixed host key. The same one as for the main host, thanks.
        hostKeys = [ keyPath ];
      };
    };
  };
}
