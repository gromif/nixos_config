{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable && config.nixfiles.network.hostName == "apollo") {
    nixfiles.services.sshAgent = {
      enable = true;
      userKeys = {
        alex = with config; [
          sops.secrets."ssh/alex/general/.key".path
          sops.secrets."ssh/alex/mercury/.key".path
        ];
        nicklor = with config; [
          sops.secrets."ssh/nicklor/mercury/.key".path
        ];
      };
    };
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
      "ssh/alex/general/.key" = {
        sopsFile = ./ssh/alex/.private;
        format = "binary";
        owner = "alex";
        mode = "0400";
      };
      "ssh/alex/general/.key.pub" = {
        sopsFile = ./ssh/alex/.public;
        format = "binary";
        owner = "alex";
        mode = "0400";
      };
      # Agent
      "ssh/alex/mercury/.key" = {
        sopsFile = ./ssh/alex/mercury/.private;
        format = "binary";
        owner = "alex";
        mode = "0400";
      };
      "ssh/alex/mercury/.key.pub" = {
        sopsFile = ./ssh/alex/mercury/.public;
        format = "binary";
        owner = "alex";
        mode = "0400";
      };

      # Nicklor
      # Agent
      "ssh/nicklor/mercury/.key" = {
        sopsFile = ./ssh/nicklor/mercury/.private;
        format = "binary";
        owner = "nicklor";
        mode = "0400";
      };
      "ssh/nicklor/mercury/.key.pub" = {
        sopsFile = ./ssh/nicklor/mercury/.public;
        format = "binary";
        owner = "nicklor";
        mode = "0400";
      };
    };
  };
}
