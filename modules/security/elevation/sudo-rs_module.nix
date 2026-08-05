{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.security.elevation == "sudo-rs") {
    security.sudo-rs = {
      enable = mkForce true;
      execWheelOnly = true;
    };
  };
}
