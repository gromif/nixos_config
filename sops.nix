# sops.nix

{ inputs, config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    age.keyFile = "/persist/sys/root/.config/sops/age/keys.txt";
  };

  sops.secrets = {
    "luks/drive_a" = {};
    "luks/drive_m" = {};
    "luks/usb1" = {};
    "luks/sd1" = {};
    "luks/sd2" = {};
  };
}
