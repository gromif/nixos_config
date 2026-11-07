{
  pkgs,
  lib,
  ...
}:

with lib;

{
  users.users.root.packages = with pkgs; [ sbctl ];
  boot = {
    loader.systemd-boot.enable = mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      settings.timeout = 10;
    };
  };
}
