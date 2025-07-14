# User - Root


{ config, pkgs, ... }:

{
  users.users.root = {
    hashedPasswordFile = "/persist/user/alex/passwd_hash";
  };
}
