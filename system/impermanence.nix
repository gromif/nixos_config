# Impermanence


{ config, pkgs, ... }:

{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections" # Manual network configs
      { directory = "/etc/nixos"; mode = "u=rwx,g=rx,o="; }
      "/root/.cache/nix"
      { directory = "/root/.config/sops"; mode = "u=rwx,g=rx,o="; } # Sops keys
      "/var/log"
      { directory = "/var/lib/AccountsService"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; } # User settings
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/libvirt"
      "/var/lib/lxc"
      #"/var/lib/systemd/coredump"
      "/var/lib/power-profiles-daemon"
      "/var/tmp"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/NetworkManager/NetworkManager.state"
      "/var/lib/OpenRGB/OpenRGB.json"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
}
