# Impermanence


{ config, pkgs, ... }:

let
  persistencePath = "/persist";
in
{
  environment.persistence."${persistencePath}" = {
    hideMounts = true;
    directories = [
      "/home"
      "/nix"
      "/etc/NetworkManager/system-connections" # Manual network configs
      { directory = "/etc/nixos"; mode = "u=rwx,g=rx,o="; }
      "/root/.cache/nix"
      { directory = "/root/.config/sops"; mode = "u=rwx,g=rx,o="; } # Sops keys
      "/var/log"
      { directory = "/var/lib/AccountsService"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; } # User settings
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/nixos"
      "/var/lib/libvirt"
      "/var/lib/lxc"
      #"/var/lib/systemd/coredump"
      "/var/lib/power-profiles-daemon"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      "/var/tmp"
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/NetworkManager/NetworkManager.state"
      "/var/lib/OpenRGB/OpenRGB.json"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
  
  # adjust `persist` mode at runtime
  systemd.tmpfiles.rules = [
    "z ${persistencePath} 0750 root root - -"
  ];
}
