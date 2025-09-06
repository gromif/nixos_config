# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings."org/gnome/Console" = {
    custom-font = "FiraCode Nerd Font 14";
    use-system-font = false;
  };
}
