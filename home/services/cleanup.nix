# Home - Services - Cleanup

{ config, pkgs, ... }:

{
  # General TmpFiles rules
  systemd.user.tmpfiles.rules = [
    "R %h/.cache/appimage-run - - - - -"
    "R %h/.parallel - - - - -"
  ];
}
