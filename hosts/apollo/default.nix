{ config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./crypttab.nix
    ./vfio.nix
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
    };
    gaming.enable = true;
    users = lib.mkAfter (
      with config.nixfiles.user;
      [
        root.id
        alex.id
        nicklor.id
      ]
    );
    programs = {
      # appimage.enable = true;
      sets = {
        media.enable = true;
      };
    };
    games = {
      prism-launcher = {
        # enable = true;
        users = [ "alex" ];
      };
    };
  };

  programs.firefox.enable = true; # Install firefox.

  xdg.mime.predefined.enable = true;

  boot.kernelParams = [
    "video=HDMI-A-1:1920x1080@83"
  ];
}
