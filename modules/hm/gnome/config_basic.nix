# DE - Gnome


{ config, pkgs, ... }:

let
	dconfConfigsList = builtins.attrNames (builtins.readDir ./dconf);
	dconfConfigs = map (c: ./dconf + "/${c}") dconfConfigsList;
in
{
  imports = dconfConfigs ++ [
    ./qt
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

  dconf.enable = true;
  services.gnome-keyring.enable = true;
}
