{ config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./crypttab.nix
    ./vfio.nix
    ./srv.nix
  ];

  time.timeZone = "Europe/Berlin";

  nixfiles = {
    system = {
      home-manager = true;
      shell.console.optimalSettings = true;
      stateVersion = "25.11";
    };
    boot.kernelModules.v4l2loopback.enable = true;
    network = {
      hostName = baseNameOf ./.;
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
      graphics = {
        vendor = "amd";
        lact.profile = "MANAGED";
      };
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
      podman.enable = true;
      distrobox.enable = true;
    };
    gaming = {
      enable = true;
      enableLSFG = true;
    };
    users = lib.mkAfter (
      with config.nixfiles.user;
      [
        root.id
        alex.id
        nicklor.id
      ]
    );
    programs = {
      appimage.enable = true;
      direnv.enable = true;
      fastfetch = {
        enable = true;
        preset = "nixos_1";
      };
      sets = {
        common.group.desktop = true;
        media.enable = true;
      };
    };
    games = {
      prism-launcher = {
        enable = true;
        users = [ "alex" ];
      };
    };
  };

  programs.firefox = {
    enable = true; # Install firefox.
    policies = {
      # Disable WebRTC globally
      MediaPeerConnection = {
        enabled = false;
      };
    };
  };

  xdg.mime.predefined.enable = true;

  boot.kernelParams = [
    "clearcpuid=umip" # Trade-off: Hypervisor via Proton
  ];

  services.snapper = {
    persistentTimer = true;
    configs = {
      steam_skyrim = {
        SUBVOLUME = "/home/alex/.steam/steam/steamapps/compatdata/3855877462";
        ALLOW_USERS = [ "alex" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_WEEKLY = 1;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
      drive_a_music = {
        SUBVOLUME = "/mnt/drive_a/Music";
        ALLOW_USERS = [ "alex" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_WEEKLY = 1;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
