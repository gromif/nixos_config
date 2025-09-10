# Home - Games - Prism Launcher


{ config, pkgs, ... }:

let
  tmpFilesRules = map (f: "R \"%h/.local/share/PrismLauncher/${f}\" - - - - -") [
    "cache/"
    "logs/"
    "instances/*/minecraft/crash-reports/"
    "instances/*/minecraft/downloads/"
    "instances/*/minecraft/logs/"
    "instances/*/minecraft/screenshots/"
  ];
in
{
  # Set up Tmpfiles rules
  systemd.user.tmpfiles.rules = tmpFilesRules;
}
