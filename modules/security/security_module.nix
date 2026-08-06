{ config, lib, ... }:

with lib;

{
  options.nixfiles.security = {
    enableCommon = mkOption {
      type = types.bool;
      default = true;
      description = "common security settings";
    };
  };

  config = mkIf (config.nixfiles.security.enableCommon) {
    # Restrict Nix pm for users outside of the @nix group
    nix.settings.allowed-users = [ "@nix" ];
    users.groups.nix = { };

    security = {
      protectKernelImage = true; # Prevent replacing the running kernel
    };
  };
}
