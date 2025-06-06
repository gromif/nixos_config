# Home


{ config, pkgs, ... }:

{
  imports = [
		./gnome
		./qt
		./systemd-tmpfiles
		./cleanup.nix
		./screenshot-optimiser.nix
		./theme-changer.nix
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

    # Development
    android-studio
    
    # Media
    gimp3
    inkscape
    nicotine-plus
    smplayer
    qbittorrent
    mpv
    
    # Games
    lact

    # Desktop
    gnome-tweaks
    openrgb-with-all-plugins
    dconf-editor
    
    # Tools
    mission-center
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
