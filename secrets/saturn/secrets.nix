{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable && config.nixfiles.network.hostName == baseNameOf ./.) {
    nixfiles.services.sshAgent = {
      enable = true;
      userKeys = {
        nicklor = with config; [
          sops.secrets."ssh/nicklor/mercury/.key".path
        ];
      };
    };
    sops.defaultSopsFile = ./.secrets.yaml;
    sops.secrets = {
      "luks/drive_f" = { };

      user_root_passwordHash = {
        neededForUsers = true;
        sopsFile = ./.users.yaml;
      };

      #
      # User-specific secrets
      #

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
