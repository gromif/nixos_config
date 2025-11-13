# Security - Sandbox


{ config, lib, pkgs, ... }:

let
  profilesList = builtins.attrNames (builtins.readDir ./profiles);
  profiles = builtins.map (p: ./profiles + "/${p}") profilesList;
in
{
  imports = profiles;

  environment.systemPackages = with pkgs; [ bubblewrap ];
}
