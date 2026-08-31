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
  ];

  time.timeZone = "Europe/Kyiv";

  nixfiles = {
    system = {
      stateVersion = "26.05";
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
      ports = [ 4447 ];
    };
    programs = {
      sets = {
        common.group.server = true;
      };
    };
  };

  # Specify custom bootloader device
  boot.loader.grub.device = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55E696FA619B1A863100D-0:0";

  # Auto-login the first tty console
  services.getty.autologinUser = "warden";

  # Hardware
  services = {
    fstrim.enable = lib.mkDefault false; # Pointless on slow media
    journald.storage = "volatile"; # Avoid unnecessary operations for slow media
  };
}
