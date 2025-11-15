# Boot - grub2


{ config, lib, ... }:

with lib;

let
  cfg_imperm = config.environment.impermanence;
  isImpermanent = cfg_imperm.enable;
in
{
  # Use the GRUB 2 boot loader.
  boot.loader = {
    timeout = 10;
    grub = {
      enable = true;
      device = mkIf (!isImpermanent) "/dev/sda";
      mirroredBoots = mkif (isImpermanent) [
        {
          path = "${cfg_imperm.persistentStoragePath}/boot";
          devices = [ "/dev/sda" ];
        }
      ];
    };
  };
}
