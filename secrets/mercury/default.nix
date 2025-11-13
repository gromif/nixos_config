# mercury - SOPS configuration

{ ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/apollo/public_key".sopsFile = ./ssh.yaml;
    "ssh/galileo/public_key".sopsFile = ./ssh.yaml;
    "ssh/polaris/public_key".sopsFile = ./ssh.yaml;
  };
}
