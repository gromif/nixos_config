# User - Alex


{ preferences, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    home = "/home/alex";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    shell = pkgs.zsh;
  };
  
  users.users.root.hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;

  users.users.alex.packages = with pkgs; [
    # Terminal
    fastfetch
    yt-dlp
    tldr

    # Misc
    freetube
    blanket
    megasync

    # Communication
    materialgram
    vesktop
    localsend
    
    # Media
    gimp3
    inkscape
    libreoffice-fresh
    folio
    nicotine-plus
    smplayer
    qbittorrent
    mpv

    # Desktop
    gnome-extension-manager
    refine
    gnome-tweaks
    openrgb-with-all-plugins
    dconf-editor
    papers
    
    # Tools
    upscaler
    identity
    eartag
    mission-center
    eyedropper
  ];
  
  programs.firefox.enable = true; # Install firefox.

  xdg.mime.predefined.enable = true;

  # Security
  networking.firewall.enable = false;

  # Hardware
  prefs.hardware.graphics.gpuVendor = "amd";
  
  # Common preferences
  system.stateVersion = preferences.system.stateVersion;
  time.timeZone = preferences.time.timeZone;
  networking.hostName = preferences.hostName;
}
