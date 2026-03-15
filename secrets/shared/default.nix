# shared - SOPS configuration

{ config, ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/endpoint" = {
      sopsFile = ./ssh.yaml;
    };
    "ssh/extraConfig" = {
      sopsFile = ./ssh.yaml;
    };
    "services/slskd_env" = {
      sopsFile = ./slskd.yaml;
      owner = config.services.slskd.user;
      group = config.services.slskd.group;
    };
  };
}
