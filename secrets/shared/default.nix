# shared - SOPS configuration

{ config, lib, ... }:

{
  sops.secrets = {
    "ssh/endpoint" = {
      format = "binary";
      sopsFile = ./ssh/endpoint_uk.bin;
    };
    "ssh/extraConfig" = {
      format = "binary";
      sopsFile = ./ssh/ssh_config.bin;
    };
    "services/slskd_env" = lib.mkIf config.services.slskd.enable {
      sopsFile = ./slskd.yaml;
      owner = config.services.slskd.user;
      group = config.services.slskd.group;
    };
  };
}
