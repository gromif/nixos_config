# sops.nix

{ inputs, config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    # the age.keyFile option is declared in the impermanence config
  };

  sops.secrets = {
    "ssh/root/known_hosts".sopsFile = ./secrets/ssh.yaml;
    "ssh/root/id_ed25519".sopsFile = ./secrets/ssh.yaml;
    "ssh/root/id_ed25519_pub".sopsFile = ./secrets/ssh.yaml;
    
    "luks/drive_a" = {};
    "luks/drive_m" = {};
    "luks/usb1" = {};
    "luks/sd1" = {};
    "luks/sd2" = {};
    
    user_root_passwordHash = {
      neededForUsers = true;
      sopsFile = ./secrets/users.yaml;
    };
    
    usbguard-rules.sopsFile = ./secrets/usbguard.yaml;
  };
}
