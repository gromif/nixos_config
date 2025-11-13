# primary - SOPS configuration

{ ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/root/known_hosts".sopsFile = ./ssh.yaml;
    "ssh/root/id_ed25519".sopsFile = ./ssh.yaml;
    "ssh/root/id_ed25519_pub".sopsFile = ./ssh.yaml;
    
    "luks/usb1" = {};
    "luks/sd1" = {};
    "luks/sd2" = {};
    
    user_root_passwordHash = {
      neededForUsers = true;
      sopsFile = ./users.yaml;
    };
    
    usbguard-rules.sopsFile = ./usbguard.yaml;
  };
}
