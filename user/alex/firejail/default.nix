# User - Alex - Firejail


{ config, lib, ... }:

let
  profilesList = builtins.attrNames (builtins.readDir ./profiles);
  profiles = builtins.map (p: ./profiles + "/${p}") profilesList;
in
{
  imports = profiles;
}
