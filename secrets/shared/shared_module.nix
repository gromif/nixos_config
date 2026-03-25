{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable) {
    sops.secrets = {
      "ssh/endpoint" = {
        format = "binary";
        sopsFile = ./ssh/endpoint_uk.bin;
      };
      "ssh/extraConfig" = {
        format = "binary";
        sopsFile = ./ssh/ssh_config.bin;
        mode = "0755";
      };
      "services/slskd_env" = lib.mkIf config.services.slskd.enable {
        sopsFile = ./slskd.yaml;
        owner = config.services.slskd.user;
        group = config.services.slskd.group;
      };
    };
  };
}
