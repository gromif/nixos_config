# moon - SOPS configuration

{ ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/root/id_ed25519" = {
      sopsFile = ./ssh.yaml;
      path = "/root/.ssh/id_ed25519";
    };
    "ssh/root/id_ed25519_pub" = {
      sopsFile = ./ssh.yaml;
      path = "/root/.ssh/id_ed25519.pub";
    };
  };
}
