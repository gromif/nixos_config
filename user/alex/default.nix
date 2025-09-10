# User - Alex


{ config, pkgs, lib, ... }:

let
  programsList = builtins.attrNames (builtins.readDir ./programs);
  programs = map (c: ./programs + "/${c}") programsList;
  servicesList = builtins.attrNames (builtins.readDir ./services);
  services = map (c: ./services + "/${c}") servicesList;
in
{
  imports = [
    ./gaming.nix
    ./mimetypes.nix
    ./virtualisation.nix
  ] ++ programs ++ services;
  
  # ============================================================================================================
  # User
  # ============================================================================================================
  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    home = "/home/alex";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    shell = pkgs.zsh;
  };
  
  # ============================================================================================================
  # Desktop Environment
  # ============================================================================================================
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.systemPackages = with pkgs; [
    megasync
    
    #Theming
    kdePackages.ocean-sound-theme
    adw-gtk3
  ];
  
  # ============================================================================================================
  # Desktop Environment [Exclude]
  # ============================================================================================================
  environment.gnome.excludePackages = with pkgs; [
    orca
    decibels
    evince
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
  
  programs.firefox.enable = true; # Install firefox.
  
  # Set up UDEV rules
  services.udev.packages = with pkgs; [ 
    android-udev-rules # Android
  ];
}
