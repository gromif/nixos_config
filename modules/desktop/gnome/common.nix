# User - Alex - Desktop Environment


{ config, pkgs, lib, ... }:

{
  # ============================================================================================================
  # Desktop Environment
  # ============================================================================================================
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.systemPackages = with pkgs; [
    # Theming
    kdePackages.ocean-sound-theme
    adw-gtk3
  ];
  
  # ============================================================================================================
  # Desktop Environment [Exclude]
  # ============================================================================================================
  environment.gnome.excludePackages = with pkgs; [
    orca
    decibels
    file-roller
    geary
    epiphany
    gnome-contacts
    gnome-music
    gnome-software
    gnome-system-monitor
    gnome-connections
    gnome-tour
    simple-scan
    yelp
  ];
  
  # ============================================================================================================
  # Desktop Environment [Fixes]
  # ============================================================================================================
  # Fix for Nautilus media details page
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);
  # Enable numlock in gdm.
  programs.dconf.profiles.gdm.databases = [{
    settings."org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
  }];
}
