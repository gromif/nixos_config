# mercury - SOPS configuration

{ ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
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
