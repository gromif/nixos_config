# User - Alex - XDG-Mimetypes


{ config, pkgs, lib, ... }:

let
  image = "org.gnome.Loupe.desktop";
  video = "smplayer.desktop";
  audio = "com.github.neithern.g4music.desktop";
  text = "org.gnome.TextEditor.desktop";
  reader = "org.gnome.Papers.desktop";
  archiver = "org.gnome.Nautilus.desktop";
  
  tg = "io.github.kukuruzka165.materialgram.desktop";
  discord = "io.github.kukuruzka165.materialgram.desktop";
in
{
  xdg.mime.defaultApplications = {
    # Text
    "text/plain" = "${text}";
    "application/xml" = "${text}";
    "application/vnd.apple.keynote" = "${text}";
    "application/vnd.ms-publisher" = "${text}";
    
    # Archives
    "application/zip" = "${archiver}";
    "application/x-zstd-compressed-tar" = "${archiver}";
    "application/x-xz-compressed-tarzip" = "${archiver}";
    "application/x-7z-compressed" = "${archiver}";
    "application/x-zpaq" = "${archiver}";
    
    # Other
    "application/pdf" = "${reader}";
    
    # scheme-handler
    "x-scheme-handler/tg" = "${tg}";
    "x-scheme-handler/tonsite" = "${tg}";
    "x-scheme-handler/discord" = "${discord}";
    
    # Image
    "image/jxl" = "${image}";
    "image/png" = "${image}";
    "image/avif" = "${image}";
    "image/svg" = "${image}";
    "image/jpeg" = "${image}";
    "image/vnd.microsoft.icon" = "${image}";
    
    # Audio
    "audio/flac" = "${audio}";
    "audio/ogg" = "${audio}";
    "audio/mpeg" = "${audio}";
    "audio/mp4" = "${audio}";
    "audio/vnd.wave" = "${audio}";
    "audio/opus" = "${audio}";
    
    # Video
    "video/x-matroska" = "${video}";
    "video/mp4" = "${video}";
  };
}
