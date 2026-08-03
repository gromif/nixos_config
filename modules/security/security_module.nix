{ config, lib, ... }:

with lib;

{
  options.nixfiles.security = {
    enableCommon = mkOption {
      type = types.bool;
      default = true;
      description = "common security settings";
    };
    superuser = mkOption {
      type = types.enum [
        "default"
        "sudo-rs"
        "run0"
      ];
      default = "run0";
      description = "Which SU auth-agent to use";
    };
  };

  config =
    let
      elevationMethod = config.nixfiles.security.superuser;
    in
    mkMerge [
      (mkIf (config.nixfiles.security.enableCommon) {
        # Restrict Nix pm for users outside of the @nix group
        nix.settings.allowed-users = [ "@nix" ];
        users.groups.nix = { };

        security = {
          protectKernelImage = true; # Prevent replacing the running kernel
        };
      })
      (mkIf (elevationMethod == "sudo") {
        security = {
          sudo.enable = mkForce true;
        };
      })
      (mkIf (elevationMethod == "sudo-rs") {
        security.sudo-rs = {
          enable = mkForce true;
          execWheelOnly = true;
        };
      })
      (optional (elevationMethod == "run0") {
        security.run0 = {
          enable = true;
          persistentAuth = {
            enable = true;
          };
        };
      })
    ];
}
