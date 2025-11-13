# Programs - Gapless


{ lib, pkgs, pkgs-master, ... }:

with lib.gvariant;

let
  root = "com/github/neithern/g4music";
  dconfSettings = {
    "${root}" = {
      rotate-cover = false;
      show-peak = false;
      volume = 1.0;
      width = mkInt32 1269;
    };
  };
in
{
  environment.systemPackages = [ pkgs.gapless ];
  programs.dconf.profiles.user.databases = [ { settings = dconfSettings; } ];
}
