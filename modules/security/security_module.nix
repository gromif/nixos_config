{ config, lib, ... }:

with lib;

{
  options.nixfiles.security = {
    enableCommon = mkOption {
      type = types.bool;
      default = true;
      description = "common security settings";
    };
    elevation = mkOption {
      type = types.enum [
        "default"
        "sudo-rs"
        "run0"
      ];
      default = "run0";
      description = "Which SU auth-agent to use";
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
