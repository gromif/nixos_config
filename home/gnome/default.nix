# DE - Gnome


{ config, pkgs, ... }:

let
	programsList = builtins.attrNames (builtins.readDir ./programs);
	programs = map (c: ./programs + "/${c}") programsList;
in
{
  imports = programs ++ [
    ./app-folders.nix
    ./dconf.nix
  ];
  
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.legacy-gtk3-theme-scheme-auto-switcher # adw-gtk3 auto-switcher
    gnomeExtensions.caffeine
    gnomeExtensions.light-style # Official Light mode support
    gnomeExtensions.gsconnect
    gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
    dconf2nix
  ];

  services.gnome-keyring.enable = true;
}
