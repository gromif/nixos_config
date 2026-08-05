{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.security.elevation == "run0") {
    security = {
      run0 = {
        enable = true;
        persistentAuth = {
          enable = true;
        };
      };
      sudo.enable = mkForce false;
      sudo-rs.enable = mkForce false;
    };
  };
}
