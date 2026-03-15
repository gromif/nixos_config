# shared - SOPS configuration

{ ... }:

{
  sops.secrets = {
    "ssh/endpoint" = {
      sopsFile = ./ssh.yaml;
    };
    "ssh/extraConfig" = {
      sopsFile = ./ssh.yaml;
    };
  };
}
