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
      docker = {
        enable = true;
        users = [ "alex" ];
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
      appimage.enable = true;
      android-studio = {
        enable = true;
        users = [ "alex" ];
      };
      megasync = {
        enable = true;
        users = [ "alex" ];
      };
      sets = {
        media.enable = true;
      };
    };
    games = {
      prism-launcher = {
        enable = true;
        users = [ "alex" ];
      };
    };
    security = {
      sandbox.enable = true;
    };
  };

  programs.firefox.enable = true; # Install firefox.

  xdg.mime.predefined.enable = true;

  boot.kernelParams = [
    "video=HDMI-A-1:1920x1080@83"
  ];
}
