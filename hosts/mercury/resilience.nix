{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

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
      users.root.shell = "/bin/zsh";
      extraBin = {
        zsh = "${getExe pkgs.zsh}";
      };
      network = {
        enable = true;
        networks."10-wired" = {
          matchConfig.Type = "ether";
          networkConfig.DHCP = "yes";
        };
      };
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
        hostKeys = [ config.sops.secrets."ssh/initrd".path ];
      };
    };
  };
}
