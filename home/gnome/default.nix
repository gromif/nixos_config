# DE - Gnome


{ config, pkgs, ... }:

{
  imports = [
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
