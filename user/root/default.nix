# User - Root


{ config, ... }:

{
  imports = [
    ./config
  ];
  
  users.users.root = {
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
  };
}
