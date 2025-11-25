# Hosts - Polaris


{ config, lib, pkgs, ... }:

{
  environment.packages = with pkgs; [
    dwarfs
    nano
    yt-dlp
  ];

  # Backup etc flakes instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";
  
  # Common preferences
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.stateVersion = "24.05";
  # time.timeZone = preferences.time.timeZone;
  # networking.hostName = preferences.hostName;
}
