{ config, lib, ... }:

with lib;

let
  cfg = config.nixfiles.security.elevation;
in
{
  options.nixfiles.security = {
    elevation = mkOption {
      type = types.enum [
        "default"
        "sudo"
        "sudo-rs"
        "run0"
      ];
      default = "run0";
      description = "Which SU auth-agent to use";
    };
  };

  config = mkMerge [
    (mkIf (cfg == "sudo") {
      security = {
        sudo = {
          enable = mkForce true;
        };
        sudo-rs.enable = mkForce false;
      };
    })
    (mkIf (cfg == "sudo-rs") {
      security = {
        sudo.enable = mkForce false;
        sudo-rs = {
          enable = mkForce true;
          execWheelOnly = true;
        };
      };
    })
    (mkIf (cfg == "run0") {
      # Remove nasty background
      environment.sessionVariables.SYSTEMD_TINT_BACKGROUND = 0;

      security = {
        run0 = optionalAttrs (options ? security.run0.enable) {
          enable = true;
          persistentAuth = {
            enable = true;
          };
        };
        sudo.enable = mkForce false;
        sudo-rs.enable = mkForce false;
      };
    })
  ];
}
