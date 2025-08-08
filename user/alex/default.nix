# User - Alex


{ config, pkgs, lib, ... }:

{
  imports = [
    ./config
    ./gaming.nix
    ./mimetypes.nix
  ];
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    home = "/home/alex";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    extraGroups = [ "networkmanager" "wheel" "kvm" "docker" ];
    shell = pkgs.zsh;
  };
  
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Install GNOME Essentials
  environment.systemPackages = with pkgs; [
    #Theming
    rtorrent
    kdePackages.ocean-sound-theme
    adw-gtk3
  ];
  
  # Exclude
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
  
  # Fix for Nautilus media details page
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);
  
  programs.firefox.enable = true; # Install firefox.
  
  # Set up UDEV rules
  services.udev.packages = with pkgs; [ 
    android-udev-rules # Android
  ];
	
	# Flatpak
	#services.flatpak.update.auto.enable = true;
  #services.flatpak.uninstallUnmanaged = true;
  #services.flatpak.packages = [];
  
  # Enable numlock in gdm.
  programs.dconf.profiles.gdm.databases = [{
    settings."org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
  }];
}
