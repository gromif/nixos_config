{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.security.elevation == "sudo") {
    security.sudo = {
      enable = mkForce true;
    };
  };
}
