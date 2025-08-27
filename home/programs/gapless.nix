# Home - Euphonica


# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, pkgs, ... }:

with lib.hm.gvariant;

let
  root = "com/github/neithern/g4music";
in
{
  home.packages = [ pkgs.gapless ];
  dconf.settings."${root}" = {
    rotate-cover = false;
    show-peak = false;
    volume = 1.0;
    width = 1269;
  };
}
