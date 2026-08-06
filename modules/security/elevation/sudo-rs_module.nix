{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.security.elevation == "sudo-rs") {
    security = {
      sudo.enable = mkForce false;
      sudo-rs = {
        enable = mkForce true;
        execWheelOnly = true;
      };
    };
  };
}
