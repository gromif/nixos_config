{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable && config.nixfiles.network.hostName == "moon") {
    sops.defaultSopsFile = ./secrets.yaml;
    sops.secrets = {
      "ssh/root/private" = {
        sopsFile = ./ssh.yaml;
        path = "/root/.ssh/id_ed25519";
      };
      "ssh/root/public" = {
        sopsFile = ./ssh.yaml;
        path = "/root/.ssh/id_ed25519.pub";
      };
      "ssh/root/mercury/private" = {
        sopsFile = ./ssh.yaml;
        path = "/root/.ssh/mercury";
      };
      "ssh/root/mercury/public" = {
        sopsFile = ./ssh.yaml;
        path = "/root/.ssh/mercury.pub";
      };
    };
  };
}
