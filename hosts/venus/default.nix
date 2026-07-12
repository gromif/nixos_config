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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.warden = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets."users/warden/hashedPassword".path;
    # Set up SSH allowed public keys per/user
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."users/root/hashedPassword".path;
    # Set up SSH allowed public keys per/user
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkstoRvU2rtFcd0kGwI4WKCM+CZYzuk8krRpoz9DC/9 root@mercury" # Alex / Apollo
    ];
    packages = with pkgs; [
      tcpdump
    ];
  };

  # Hardware
  services = {
    fstrim.enable = lib.mkDefault false; # Pointless on slow media
    journald.storage = "volatile"; # Avoid unnecessary operations for slow media
  };
}
