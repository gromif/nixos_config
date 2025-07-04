# User - Alex


{ config, pkgs, lib, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    home = "/home/alex";
    createHome = true;
    hashedPasswordFile = "/persist/user/alex/passwd_hash";
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    shell = pkgs.zsh;
  };
  
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Install GNOME Essentials
  environment.systemPackages = with pkgs; [
    #Theming
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
  programs.steam.enable = true; # Install steam.
  programs.htop = { # Setup htop.
		enable = true;
		settings = {
			hide_kernel_threads = true;
			hide_userland_threads = true;
		};
  };
  
  # Set up UDEV rules
  services.udev.packages = with pkgs; [ 
    openrgb-with-all-plugins # Openrgb
    android-udev-rules # Android
  ];
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  systemd.user.services.openrgb-boot = {
    path = [ pkgs.openrgb-with-all-plugins ];
    script = "openrgb --profile Uranium";
    wantedBy = [ "default.target" "reboot.target" ];
  };
  
  # Waydroid
  virtualisation.waydroid.enable = true;
  
  systemd.packages = with pkgs; [ lact ];
	systemd.services.lactd.wantedBy = ["multi-user.target"];
	
	# Flatpak
	services.flatpak.update.auto.enable = true;
  services.flatpak.uninstallUnmanaged = true;
  
  services.flatpak.packages = [
    "io.github.kukuruzka165.materialgram"
    "io.freetubeapp.FreeTube"
    "com.github.tchx84.Flatseal"
  ];
  
  services.flatpak.overrides = {
    global = {
      Context.filesystems = [ 
        "xdg-config/MangoHud:ro" # Allow reading the MangoHUD config
      ];
    };
    "com.usebottles.bottles".Context.filesystems = [ 
      "xdg-data/applications" # Allow creating desktop shortcuts
    ];
  };
  
  # Enable numlock in gdm.
  programs.dconf.profiles.gdm.databases = [{
    settings."org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
  }];
  
}
