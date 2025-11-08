# Default System Config


{ config, pkgs, ... }:

{
	imports = [
	  ./boot
	  ./mainteinance
	  ./desktop_environment.nix
		./fonts.nix
		./impermanence.nix
  	./network.nix
  	./sound.nix
  	./scripts
  	./zram.nix
  	./zsh.nix
  ];
  
  programs.git.enable = true; # Install git.
  
  environment.systemPackages = with pkgs; [
    alsa-utils
    android-tools
    base91 # Implementation of the base91 utility, providing efficient binary-to-text encoding with better space utilization than Base64
    bubblewrap
    ddcutil
    helix # Post-modern modal text editor
    ncdu
    usbutils # Tools for working with USB devices, such as lsusb
    util-linux # Set of system utilities for Linux
    parallel
    psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    pwgen # Password generator which creates passwords which can be easily memorized by a human
    scrcpy
    sops
    virtiofsd # VMs
    
    # Compression
    dwarfs
    p7zip
    unrar
    unzip
    
    # Look & Feel
    tela-icon-theme
    
    # Media
    yt-dlp
    exiftool # ExifTool is a platform-independent Perl library plus a command-line application for reading, writing and editing meta information in a wide variety of files
    flac # Library and tools for encoding and decoding the FLAC lossless audio file format
    sox # Sample Rate Converter for audio
    imagemagick # Software suite to create, edit, compose, or convert bitmap images
    libjxl
    
    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-rs # Rust implementation
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
  #services.flatpak.enable = true;
  
  # Enable AppImage Support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  
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
