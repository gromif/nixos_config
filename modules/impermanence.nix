# Impermanence


{ config, lib, ... }:

with lib;

let
  cfg = config.environment.impermanence;
  persistencePath = "/persist";
  inAliases = [ "environment" "impermanence" ];
  toAliases = [ "environment" "persistence" persistencePath ];
  aliases = map (option:
    mkAliasOptionModule (inAliases ++ [ option ]) (toAliases ++ [ option ])
  ) [
    "enableDebugging"
    "enableWarnings"
    "directories"
    "files"
    "hideMounts"
    "persistentStoragePath"
    "users"
  ];
in
{
  imports = aliases;
   
  options.environment.impermanence = {
    enable = mkEnableOption "enable the Impermanence module";
  };

  config = {
    environment.impermanence.enable = true; # Enable by default
    environment.persistence."${persistencePath}" = mkIf (cfg.enable) {
      directories = [
        "/home"
        "/nix"
        "/etc/NetworkManager/system-connections" # Manual network configs
        { directory = "/etc/nixos"; mode = "u=rwx,g=,o="; }
        "/root/.cache/nix"
        { directory = "/root/.config/sops/age"; mode = "u=rwx,g=,o="; } # Sops keys
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
  };
}
