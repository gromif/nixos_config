{ config, lib, ... }:

with lib;

{
  options.nixfiles.security.enableCommon = mkOption {
    type = types.bool;
    default = true;
    description = "common securiry settings";
  };

  config = mkIf (config.nixfiles.security.enableCommon) {
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [];
    # networking.firewall.allowedUDPPorts = [];

    # Lock Kernel Modules
    # security.lockKernelModules = true;

    # Restrict Nix pm for users outside of the @nix group
    nix.settings.allowed-users = [ "@nix" ];
    users.groups.nix = { };

    security = {
      # Prevent replacing the running kernel
      protectKernelImage = true;

      # Include memory-safe sudo implementation
      sudo.enable = false;
      sudo-rs = {
        enable = true;
        execWheelOnly = true;
      };
    };
  };
}
