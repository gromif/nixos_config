{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./lanzaboote.nix
    ./crypttab.nix
    ./vfio.nix

    ./openrgb
  ];

  boot = {
    kernelModules = [ "it87" ];
    extraModulePackages = with config.boot.kernelPackages; [
      it87
    ];
  };

  time.timeZone = "Europe/Berlin";
  nixfiles = {
    preset = {
      shared.enable = true;
      desktop.enable = true;
    };
    system = {
      home-manager = true;
      stateVersion = "25.11";
    };
    support = {
      hagezi-update.enable = true;
    };
    network.hostName = baseNameOf ./.;
    hardware = {
      graphics = {
        vendor = "amd";
        lact.profile = "MANAGED";
      };
    };
    users = [
      "root"
      "trusted"
      "alex"
    ];
    games = {
      prism-launcher = {
        enable = true;
        users = [ "alex" ];
      };
    };
    virtualisation.libvirtd.members = [ "alex" ];
  };

  xdg.mime.predefined.enable = true;

  services.snapper = {
    persistentTimer = true;
    configs = {
      drive_a_music = {
        SUBVOLUME = "/mnt/drive_a/Music";
        ALLOW_USERS = [ "alex" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_DAILY = 3;
        TIMELINE_LIMIT_WEEKLY = 1;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
