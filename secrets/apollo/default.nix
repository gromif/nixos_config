# primary - SOPS configuration

{ ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/ed25519" = {
      sopsFile = ./ssh.yaml;
      path = "/etc/ssh/ssh_host_ed25519_key";
    };
    "ssh/ed25519_pub" = {
      sopsFile = ./ssh.yaml;
      path = "/etc/ssh/ssh_host_ed25519_key.pub";
    };
    "ssh/rsa" = {
      sopsFile = ./ssh.yaml;
      path = "/etc/ssh/ssh_host_rsa_key";
    };
    "ssh/rsa_pub" = {
      sopsFile = ./ssh.yaml;
      path = "/etc/ssh/ssh_host_rsa_key.pub";
    };
    "ssh/root/known_hosts" = {
      sopsFile = ./ssh.yaml;
      path = "/root/.ssh/known_hosts";
    };
    "ssh/root/id_ed25519" = {
      sopsFile = ./ssh.yaml;
      path = "/root/.ssh/id_ed25519";
    };
    "ssh/root/id_ed25519_pub" = {
      sopsFile = ./ssh.yaml;
      path = "/root/.ssh/id_ed25519.pub";
    };
    
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
