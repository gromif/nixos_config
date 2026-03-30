# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings."org/gnome/Console" = {
    custom-font = "Monocraft 15";
    use-system-font = false;
  };
}
