# Home - Security

{ config, pkgs, ... }:

{
  # Make systemd folder impermanent
  systemd.user.tmpfiles.rules = [
    "R %h/.cache/appimage-run - - - - -"
    "R %h/.cache/Google/AndroidStudio2024.3.2/tmp - - - - -"
    "R %h/.java - - - - -"
    "R %h/.local/share/kotlin - - - - -"
    "R %h/.m2 - - - - -"
    "R %h/.gradle/daemon - - - - -"
    "R %h/.gradle/.tmp - - - - -"
  ];
}
