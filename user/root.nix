# User - Root


{ config, pkgs, ... }:

{
  users.users.root = {
    hashedPasswordFile = "/nix/persist/user/alex/passwd_hash";
  };
}
