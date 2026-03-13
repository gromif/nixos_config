# shared - SOPS configuration

{ ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/endpoint" = {
      sopsFile = ./ssh.yaml;
    };
    "ssh/extraConfig" = {
      sopsFile = ./ssh.yaml;
    };
  };
}
