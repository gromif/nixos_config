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
    ./resilience.nix
    ./srv-watchdog.nix
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
    services.openssh = {
      enable = true;
      ports = [ 31472 ];
    };
    programs = {
      sets = {
        common.group.server = true;
      };
    };
  };

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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlwUoUDRQM98RN6d2aVBvsVl0RhP4lUUBacfbPfbxfP nicklor@apollo" # Nicklor / Apollo
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkstoRvU2rtFcd0kGwI4WKCM+CZYzuk8krRpoz9DC/9 root@mercury" # Alex / Apollo
    ];
    packages = with pkgs; [
      tcpdump
    ];
  };

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
