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
    
    user_root_passwordHash = {
      neededForUsers = true;
      sopsFile = ./secrets/users.yaml;
    };
    
    usbguard-rules = {
      sopsFile = ./secrets/usbguard.yaml;
    };
  };
}
