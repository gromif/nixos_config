# Home


{ config, pkgs, ... }:

{
  imports = [
    ./config
		./gnome
		./qt
		./services
		./systemd-tmpfiles
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

    # Web

    # Communication
    localsend

    # Development
    android-studio
    
    # Media
    gimp3
    inkscape
    libreoffice-fresh
    eartag
    nicotine-plus
    smplayer
    qbittorrent
    mpv
    
    # Games
    lact

    # Desktop
    refine
    gnome-tweaks
    openrgb-with-all-plugins
    dconf-editor
    papers
    
    # Tools
    mission-center
    eyedropper
  ];
  
  # MangoHud [Session-Wide]
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

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
