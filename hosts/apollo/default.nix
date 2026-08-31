{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./crypttab.nix
    ./vfio.nix
    ./srv.nix
  ];

  time.timeZone = "Europe/Berlin";

  nixfiles = {
    preset = "desktop";
    system = {
      home-manager = true;
      stateVersion = "25.11";
    };
    network.hostName = baseNameOf ./.;
    hardware = {
      graphics = {
        vendor = "amd";
        lact.profile = "MANAGED";
      };
    };
    users = with config.nixfiles.user; [
      root.id
      alex.id
      nicklor.id
    ];
    games = {
      prism-launcher = {
        enable = true;
        users = [ "alex" ];
      };
    };
  };

  xdg.mime.predefined.enable = true;

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
