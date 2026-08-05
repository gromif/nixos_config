{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable && config.nixfiles.network.hostName == "apollo") {
    sops.defaultSopsFile = ./secrets.yaml;
    sops.secrets = {
      "ssh/root/known_hosts" = {
        sopsFile = ./ssh/root/.known_hosts;
        format = "binary";
        path = "/root/.ssh/known_hosts";
      };
      "ssh/root/private" = {
        sopsFile = ./ssh/root/.private;
        format = "binary";
        path = "/root/.ssh/id_ed25519";
      };
      "ssh/root/public" = {
        sopsFile = ./ssh/root/.public;
        format = "binary";
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
        sopsFile = ./.users.yaml;
      };

      user_nicklor_passwordHash = {
        neededForUsers = true;
        sopsFile = ./.users.yaml;
      };

      #
      # User-specific secrets
      #

      # Alex
      "ssh/alex/key" = {
        sopsFile = ./ssh/alex/.private;
        format = "binary";
        path = "${config.users.users.alex.home}/.ssh/id_ed25519";
        owner = "alex";
        mode = "0700";
      };
      "ssh/alex/key.pub" = {
        sopsFile = ./ssh/alex/.public;
        format = "binary";
        path = "${config.users.users.alex.home}/.ssh/id_ed25519.pub";
        owner = "alex";
        mode = "0700";
      };
      "ssh/alex/mercury/key" = {
        sopsFile = ./ssh/alex/mercury/.private;
        format = "binary";
        owner = "alex";
        mode = "0400";
      };
      "ssh/alex/mercury/key.pub" = {
        sopsFile = ./ssh/alex/mercury/.public;
        format = "binary";
        owner = "alex";
        mode = "0400";
      };

      # Nicklor
      "ssh/nicklor/mercury/private" = {
        sopsFile = ./ssh/nicklor/mercury/.private;
        format = "binary";
        path = "${config.users.users.nicklor.home}/.ssh/mercury";
        owner = "nicklor";
        mode = "0700";
      };
      "ssh/nicklor/mercury/public" = {
        sopsFile = ./ssh/nicklor/mercury/.public;
        format = "binary";
        path = "${config.users.users.nicklor.home}/.ssh/mercury.pub";
        owner = "nicklor";
        mode = "0700";
      };
    };
  };
}
