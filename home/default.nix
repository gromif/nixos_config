# Home


{ config, pkgs, ... }:

let
  programsList = builtins.attrNames (builtins.readDir ./programs);
  programs = map (c: ./programs + "/${c}") programsList;
  gamesList = builtins.attrNames (builtins.readDir ./games);
  games = map (c: ./games + "/${c}") gamesList;
in
{
  imports = [
    ./config
		./gnome
		./services
  ] ++ games ++ programs;
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  dconf.enable = true;

  home.packages = with pkgs; [
    # Terminal
    fastfetch
    ffmpeg
    tldr

    # Misc
    freetube
    blanket

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

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
