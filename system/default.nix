# Default System Config


{ config, pkgs, ... }:

{
	imports = [
		./boot.nix
		./impermanence.nix
		./zram.nix
  		./sound.nix
  		./fonts.nix
  		./zsh.nix
  ];
  
  programs.git.enable = true; # Install git.
  
  environment.systemPackages = with pkgs; [
    alsa-utils
    ddcutil
    libjxl
    util-linux # Set of system utilities for Linux
    parallel
    podman
    psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    
    # Compression
    p7zip
    unrar
    zpaq
    
    # Look & Feel
    tela-icon-theme
    
		# Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
		gst_all_1.gstreamer
		# Common plugins like "filesrc" to combine within e.g. gst-launch
		gst_all_1.gst-plugins-base
		# Specialized plugins separated by quality
		gst_all_1.gst-plugins-good
		gst_all_1.gst-plugins-bad
		gst_all_1.gst-plugins-ugly
		# Plugins to reuse ffmpeg to play almost every video format
		gst_all_1.gst-libav
		# Support the Video Audio (Hardware) Acceleration API
		gst_all_1.gst-vaapi
  ];
  
  # Enable Flatpak Support
  services.flatpak.enable = true;
  
  # Enable AppImage Support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  
  services.fstrim.enable = true; # Enable FSTrim (weekly)
  
  # Garbage Collector
  nix.gc.automatic = true;
  nix.gc.dates = "09:00";
  
  # Optimiser
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "11:00" ];
  
  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  
}
