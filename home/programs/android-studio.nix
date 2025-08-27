# Home - Programs - Android Studio


{ config, pkgs, ... }:

let
  tmpFilesRules = map (f: "R \"%h/${f}\" - - - - -") [
    ".cache/Google/*/tmp/"
    ".java"
    ".local/share/kotlin"
    ".m2"
    ".gradle/daemon/"
    ".gradle/.tmp/"
  ];
in
{
  # Set up the package
  home.packages = with pkgs; [
    android-studio
  ];
  
  # Set up Tmpfiles rules
  systemd.user.tmpfiles.rules = tmpFilesRules;
}
