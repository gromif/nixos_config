{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./hardware-configuration.nix
    ./srv-watchdog.nix
    ./wireguard.nix
    ./resilience.nix
  ];

  time.timeZone = "Europe/Kyiv";

  nixfiles = {
    system = {
      stateVersion = "25.05";
      nix = {
        enableGC = mkForce false;
        enableOptimise = mkForce false;
      };
      shell.zsh.autoFastfetch = false;
    };
    network = {
      hostName = baseNameOf ./.;
    };
    users = [
      "mercury_root"
      "mercury_warden"
    ];
    services.openssh = {
      enable = true;
      enableEssentials = false;
      ports = [ 31472 ];
    };
    programs = {
      sets = {
        common.group.server = true;
      };
    };
  };

  # Specify custom bootloader device
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5000cca329d13f56";

  # Auto-login the first tty console
  services.getty.autologinUser = "warden";

  # Services
  services.slskd = {
    settings = {
      shares.directories = [
        "/mnt/drive_m"
        "/var/lib/qBittorrent/qBittorrent/downloads"
      ];
    };
  };

  # Hardware
  services = {
    fstrim.enable = lib.mkDefault false; # Pointless on HDDs
    journald.storage = "volatile"; # Avoid unnecessary operations for HDDs
  };
}
