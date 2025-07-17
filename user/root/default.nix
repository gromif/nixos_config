# User - Root


{ config, pkgs, ... }:

{
  imports = [
    ./config
  ];
  
  users.users.root = {
    hashedPasswordFile = "/persist/user/alex/passwd_hash";
  };
}
