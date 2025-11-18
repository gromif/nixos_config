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
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };
  
  users.users.root = {
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfs0HEb2cuq00UCYgXGJ3U9jaQ4gmNa7vpTw8DgCXV4 u0_a229@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKKLMwjIS7/ZR83zk5q3taxnnGdRbc8dUBIR5N3gWBe u0_a135@localhost"
    ];
  };

  users.users.alex.packages = with pkgs; [
    # Terminal
    fastfetch
    yt-dlp
    tldr

    # Misc
    freetube
    blanket
    # megasync

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
    identity
    eartag
    mission-center
    eyedropper
  ];
  
  programs.firefox.enable = true; # Install firefox.

  xdg.mime.predefined.enable = true;

  # DE
  services.displayManager.autoLogin.user = "alex";

  # Security
  networking.firewall.enable = false;

  # Hardware
  prefs.hardware.graphics.gpuVendor = "amd";
  
  # Common preferences
  system.stateVersion = preferences.system.stateVersion;
  time.timeZone = preferences.time.timeZone;
  networking.hostName = preferences.hostName;
}
