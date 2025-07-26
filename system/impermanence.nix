# Impermanence


{ config, pkgs, ... }:

{
  environment.persistence."/persist/sys" = {
    hideMounts = true;
    directories = [
      "/etc/lact" # LACT config folder
      "/etc/NetworkManager/system-connections" # Manual network configs
      "/etc/nixos"
      "/root/.nix-defexpr"
      "/root/.cache/nix"
      { directory = "/root/.config/sops"; mode = "u=rwx,g=rx,o="; } # Sops keys
      "/var/log"
      { directory = "/var/lib/AccountsService"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; } # User settings
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/flatpak"
      "/var/lib/nixos"
      "/var/lib/libvirt"
      "/var/lib/lxc"
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
