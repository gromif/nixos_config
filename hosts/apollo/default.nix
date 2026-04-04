{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./crypttab.nix
  ];

  time.timeZone = "Europe/Berlin";

  nixfiles = {
    system = {
      shell.console.optimalSettings = true;
      stateVersion = "25.11";
    };
    boot.kernelModules.v4l2loopback.enable = true;
    network = {
      hostName = builtins.baseNameOf ./.;
    };
    sound.backend = "pipewire";
    hardware = {
      ddc = {
        enable = true;
        allowedUsers = [
          "alex"
          "nicklor"
        ];
      };
      graphics.vendor = "amd";
    };
    de = {
      enable = true;
      gnome = {
        enable = true;
        services = {
          theme-changer.enable = true;
        };
      };
    };
    virtualisation = {
      libvirtd = {
        enable = true;
        members = [
          "alex"
        ];
      };
      docker = {
        enable = true;
        users = [ "alex" ];
      };
    };
    programs = {
      sets = {
        media.enable = true;
      };
    };
  };

  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    home = "/home/alex";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
    ];
  };

  users.users.nicklor = {
    isNormalUser = true;
    description = "nicklor";
    home = "/home/nicklor";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_nicklor_passwordHash.path;
    extraGroups = [
      "networkmanager"
      "kvm"
      "wheel"
    ];
  };

  users.users.nicklor.packages = with pkgs; [
    # Terminal
    yt-dlp

    # Misc
    blanket
    # megasync

    # Communication
    telegram-desktop
    vesktop

    # Media
    spotify
    gimp3
    inkscape
    libreoffice-fresh
    folio
    smplayer
    mpv

    # Desktop
    gnome-extension-manager
    refine
    gnome-tweaks
    dconf-editor
    papers

    # Tools
    identity
    eartag
    mission-center
    eyedropper
  ];

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
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
    smplayer
    # qbittorrent
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
}
