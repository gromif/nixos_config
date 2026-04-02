# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings."org/gnome/TextEditor" = {
    custom-font = "FiraCode Nerd Font weight=450 12";
    indent-style = "space";
    restore-session = false;
    show-line-numbers = true;
    style-scheme = "builder-dark";
    tab-width = mkUint32 2;
    use-system-font = false;
  };
}
