# Home


{ config, pkgs, ... }:

{
  imports = [
    ./config
		./gnome
		./qt
		./redroid
		./services
		./systemd-tmpfiles
		
		./euphonica.nix
		./gapless.nix
		./mangohud.nix
  ];
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  dconf.enable = true;

  home.packages = with pkgs; [
    # Terminal
    distrobox
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

    # Development
    android-studio
    
    # Media
    gimp3
    inkscape
    libreoffice-fresh
    folio
    nicotine-plus
    smplayer
    qbittorrent
    mpv
    
    # Games
    lact

    # Desktop
    gnome-extension-manager
    refine
    gnome-tweaks
    openrgb-with-all-plugins
    dconf-editor
    papers
    
    # Tools
    (bottles.override {
      removeWarningPopup = true;
    })
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
