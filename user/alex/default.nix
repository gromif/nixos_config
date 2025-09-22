# User - Alex


{ config, pkgs, lib, ... }:

let
  gamesList = builtins.attrNames (builtins.readDir ./games);
  games = map (c: ./games + "/${c}") gamesList;
  
  programsList = builtins.attrNames (builtins.readDir ./programs);
  programs = map (c: ./programs + "/${c}") programsList;
  
  servicesList = builtins.attrNames (builtins.readDir ./services);
  services = map (c: ./services + "/${c}") servicesList;
in
{
  imports = [
    ./desktop_environment.nix
    ./gaming.nix
    ./mimetypes.nix
    ./virtualisation.nix
  ] ++ games ++ programs ++ services;
  
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
  # Packages
  # ============================================================================================================
  environment.systemPackages = with pkgs; [
    # Terminal
    fastfetch
    ffmpeg
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
  
  # Set up UDEV rules
  services.udev.packages = with pkgs; [ 
    android-udev-rules # Android
  ];
}
