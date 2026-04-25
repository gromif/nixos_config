{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable && config.nixfiles.network.hostName == "mercury") {
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
      "ssh/initrd_prv" = {
        sopsFile = ./ssh.yaml;
        path = "/etc/initrd/ssh_private_key";
      };
      "ssh/initrd_pub" = {
        sopsFile = ./ssh.yaml;
        path = "/etc/initrd/ssh_public_key";
      };
      "users/root/hashedPassword" = {
        sopsFile = ./users.yaml;
        neededForUsers = true;
      };
      "users/warden/hashedPassword" = {
        sopsFile = ./users.yaml;
        neededForUsers = true;
      };
    };
  };
}
