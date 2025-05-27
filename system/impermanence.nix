# Impermanence


{ config, pkgs, ... }:

{
  environment.persistence."/nix/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/root/.nix-defexpr"
      "/root/.cache/nix"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/flatpak"
      "/var/lib/nixos"
      #"/var/lib/systemd/coredump"
      "/var/lib/power-profiles-daemon"
      "/var/lib/waydroid"
      "/var/tmp"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/NetworkManager/NetworkManager.state"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
}
