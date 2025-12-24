# Hosts - Polaris


{ config, lib, pkgs, ... }:

{
  environment.packages = with pkgs; [
    busybox
    curlMinimal
    dwarfs
    ffmpeg
    git
    nano
    openssh
    parallel
    yt-dlp
    wol
    zsh
  ];

  android-integration = {
    termux-setup-storage.enable = true;
  };

  user = {
    shell = "${lib.getExe pkgs.zsh}";
  };

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
