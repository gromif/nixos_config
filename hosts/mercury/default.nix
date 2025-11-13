# Hosts - Mercury


{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCHwV0zA22QHV1DLpaoJusNjg7xO+COQ2QOZ7EBkMSI alexander.kobrys@proton.me"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfs0HEb2cuq00UCYgXGJ3U9jaQ4gmNa7vpTw8DgCXV4 u0_a229@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKKLMwjIS7/ZR83zk5q3taxnnGdRbc8dUBIR5N3gWBe u0_a135@localhost"
    ];
    packages = with pkgs; [
      tcpdump
    ];
  };
}
