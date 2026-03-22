{ config, lib, ... }:

with lib;

let
  cfg = config.nixfiles.impermanence;
  persistPath = "/nix/state";
  inAliases = [ "nixfiles" "impermanence" ];
  toAliases = [ "environment" "persistence" persistPath ];
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
  imports = aliases ++ [ ./scripts.nix  ];
  
  options.nixfiles.impermanence = {
    enable = mkEnableOption "enable the Impermanence module";
  };

  config = {
    nixfiles.impermanence.enable = mkDefault true;
    
    environment.persistence."${persistPath}" = mkIf (cfg.enable) {
      directories = [
        "/home"
        "/etc/NetworkManager/system-connections" # Manual network configs
        { directory = "/etc/nixos"; mode = "u=rwx,g=,o="; }
        "/root/.cache/nix"
        { directory = "/root/.config/sops/age"; mode = "u=rwx,g=,o="; } # Sops keys
        "/var/log"
        { directory = "/var/lib/AccountsService"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; } # User settings
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        #"/var/lib/systemd/coredump"
        "/var/lib/power-profiles-daemon"
        { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
        "/var/tmp"
      ];
      files = [
        "/etc/machine-id"
        "/var/lib/NetworkManager/NetworkManager.state"
        { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      ];
    };
    
    # adjust `persist` mode at runtime
    systemd.tmpfiles.rules = [
      "z ${persistPath} 0750 root root - -"
    ];
  };
}
