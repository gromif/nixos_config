# DE - Gnome


{ config, pkgs, lib, ... }:

{
  imports = [
		./extensions.nix
  ];
  
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Install GNOME Essentials
  environment.systemPackages = with pkgs; [
    # Apps
    gnome-tweaks
    
    #Theming
    kdePackages.ocean-sound-theme
    adw-gtk3
    tela-icon-theme
  ];
  
  programs.dconf = {
		enable = true;
		profiles.user.databases = [
			{
			   #lockAll = true;
			   settings = {
			     # Shell
			     "org/gnome/shell" = {
			       enabled-extensions = with pkgs.gnomeExtensions; [
							 blur-my-shell.extensionUuid
							 appindicator.extensionUuid
							 legacy-gtk3-theme-scheme-auto-switcher.extensionUuid
							 caffeine.extensionUuid
							 light-style.extensionUuid
							 gsconnect.extensionUuid
							 control-monitor-brightness-and-volume-with-ddcutil.extensionUuid
			       ];
			     };
			     "org/gnome/settings-daemon/plugins/media-keys" = {
			       volume-step = lib.gvariant.mkInt32 2;
			     };
			     # Mutter
			     "org/gnome/mutter" = {
				 		 center-new-windows = true;
				 		 experimental-features = [
				 		   "autoclose-xwayland"
				 		   "variable-refresh-rate" # VRR Support
				 		   "xwayland-native-scaling" # Xwayland Native Scaling Support
				 		 ];
					 };
			     
			     # Interface
			     "org/gnome/desktop/interface" = {
			       gtk-theme = "adw-gtk3";
			       icon-theme = "Tela-blue";
			       clock-format = "12h";
			       font-antialiasing = "rgba";
			     };
			     # Peripherals
			     "org/gnome/desktop/peripherals/keyboard" = {
		 		 		 numlock-state = true;
					 };
					 # Sound
					 "org/gnome/desktop/sound".theme-name = "ocean";
			     
			     # Nautilus
			     "org/gnome/nautilus/preferences" = {
			       show-delete-permanently = true;
			       show-create-link = true;
			       click-policy = "single";
			       show-image-thumbnails = "always";
			       recursive-search = "always";
			       show-directory-item-counts = "always";
			       sort-directories-first = true;
			     };
			     
			     # Extensions
			     "org/gnome/shell/extensions/blur-my-shell/panel".force-light-text = true;
			   };
			}
		];
  };
  
  # Exclude
  environment.gnome.excludePackages = with pkgs; [
    orca
    evince
    file-roller
    geary
    epiphany
    #gnome-music
    gnome-system-monitor
    gnome-connections
    yelp
  ];
  
  # Fix for Nautilus media details page
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);
}
