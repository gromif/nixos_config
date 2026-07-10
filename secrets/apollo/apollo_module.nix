{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable && config.nixfiles.network.hostName == "apollo") {
    sops.defaultSopsFile = ./secrets.yaml;
    sops.secrets = {
      "ssh/root/known_hosts" = {
        sopsFile = ./ssh.yaml;
        path = "/root/.ssh/known_hosts";
      };
      "ssh/root/private" = {
        sopsFile = ./ssh.yaml;
        path = "/root/.ssh/id_ed25519";
      };
      "ssh/root/public" = {
        sopsFile = ./ssh.yaml;
        path = "/root/.ssh/id_ed25519.pub";
      };

      "luks/drive_a" = { };
      "luks/drive_m" = { };
      "luks/drive_f" = { };
      "luks/usb_a" = { };
      "luks/sd_a" = { };
      "luks/sd_b" = { };

      user_root_passwordHash = {
        neededForUsers = true;
        sopsFile = ./users.yaml;
      };

      user_nicklor_passwordHash = {
        neededForUsers = true;
        sopsFile = ./users.yaml;
      };

      usbguard-rules.sopsFile = ./usbguard.yaml;

      #
      # User-specific secrets
      #

      # Alex
      "ssh/alex/private" = {
        sopsFile = ./ssh.yaml;
        path = "${config.users.users.alex.home}/.ssh/id_ed25519";
        owner = "alex";
        group = "users";
        mode = "0700";
      };
      "ssh/alex/public" = {
        sopsFile = ./ssh.yaml;
        path = "${config.users.users.alex.home}/.ssh/id_ed25519.pub";
        owner = "alex";
        group = "users";
        mode = "0700";
      };
      "ssh/alex/mercury/private" = {
        sopsFile = ./ssh.yaml;
        path = "${config.users.users.alex.home}/.ssh/mercury";
        owner = "alex";
        group = "users";
        mode = "0700";
      };
      "ssh/alex/mercury/public" = {
        sopsFile = ./ssh.yaml;
        path = "${config.users.users.alex.home}/.ssh/mercury.pub";
        owner = "alex";
        group = "users";
        mode = "0700";
      };

      # Nicklor
      "ssh/nicklor/mercury/private" = {
        sopsFile = ./ssh_nicklor.yaml;
        path = "${config.users.users.nicklor.home}/.ssh/mercury";
        owner = "nicklor";
        group = "users";
        mode = "0700";
      };
      "ssh/nicklor/mercury/public" = {
        sopsFile = ./ssh_nicklor.yaml;
        path = "${config.users.users.nicklor.home}/.ssh/mercury.pub";
        owner = "nicklor";
        group = "users";
        mode = "0700";
      };
    };
  };
}
