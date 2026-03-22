# Hosts - Mercury


{ preferences, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Kyiv";
  
  nixfiles = {
    system = {
      stateVersion = "25.05";
    };
    network = {
      hostName = builtins.baseNameOf ./.;
    };
  };
  
  # Auto-login the first tty console
  services.getty.autologinUser = "warden";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
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
      # M
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdbc4rd6oLhikNKR4/Agp1VUVWsnWoR0v0POAdU/rkx u0_a1731@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCHwV0zA22QHV1DLpaoJusNjg7xO+COQ2QOZ7EBkMSI alexander.kobrys@proton.me"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfs0HEb2cuq00UCYgXGJ3U9jaQ4gmNa7vpTw8DgCXV4 u0_a229@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItp6Vb/vq72smtPuMdL9Iwvp5wIDxJujYagHjeCoBAI u0_a284@localhost"
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
      ];
    };
  };

  # Hardware
  services.fstrim.enable = lib.mkDefault false; # Pointless on HDDs
}
