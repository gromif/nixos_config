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
    de = {
      enable = true;
      gnome = {
        enable = true;
        service = {
          random-background.enable = true;
          theme-changer.enable = true;
        };
      };
    };
    virtualisation = {
      libvirtd = {
        enable = true;
        members = [
          config.users.users.alex.name
        ];
      };
      docker = {
        enable = true;
        users = [ config.users.users.alex.name ];
      };
    }
    programs = {
      sets = {
        media = true;
      };
    };
    services.openssh = {
      enable = true;
      ports = [ 24942 ];
    };
  };
  
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItp6Vb/vq72smtPuMdL9Iwvp5wIDxJujYagHjeCoBAI u0_a284@localhost"
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
  services.displayManager.autoLogin.user = config.users.users.alex.name;

  # Hardware
  prefs.hardware.graphics.gpuVendor = "amd";
  
  # services
  services.getty.autologinUser = config.users.users.alex.name; 
}
