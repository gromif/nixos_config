# mercury - SOPS configuration

{ ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/apollo/public_key".sopsFile = ./ssh.yaml;
    "ssh/galileo/public_key".sopsFile = ./ssh.yaml;
    "ssh/polaris/public_key".sopsFile = ./ssh.yaml;

    "users/root/hashedPassword" = {
      sopsFile = ./users.yaml;
      neededForUsers = true;
    };
    "users/warden/hashedPassword" = {
      sopsFile = ./users.yaml;
      neededForUsers = true;
    };
  };
}
