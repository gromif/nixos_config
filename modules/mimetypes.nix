# XDG-Mimetypes


{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.xdg.mime.predefined;
  type = types.str;
in
{
  options.xdg.mime.predefined = {
    enable = mkEnableOption "Enable custom Mime/Apps";
    image = mkOption { inherit type; default = "org.gnome.Loupe.desktop"; };
    video = mkOption { inherit type; default = "smplayer.desktop"; };
    audio = mkOption { inherit type; default = "com.github.neithern.g4music.desktop"; };
    text = mkOption { inherit type; default = "org.gnome.TextEditor.desktop"; };
    reader = mkOption { inherit type; default = "org.gnome.Papers.desktop"; };
    archiver =  mkOption { inherit type; default = "org.gnome.Nautilus.desktop"; };
    tg = mkOption { inherit type; default = "io.github.kukuruzka165.materialgram.desktop"; };
    discord = mkOption { inherit type; default = "vesktop.desktop"; };
  };

  config = {        
    xdg.mime.defaultApplications = mkIf (cfg.enable) {
      # Text
      "text/plain" = cfg.text;
      "application/xml" = cfg.text;
      "application/vnd.apple.keynote" = cfg.text;
      "application/vnd.ms-publisher" = cfg.text;
  
      # Archives
      "application/zip" = cfg.archiver;
      "application/x-zstd-compressed-tar" = cfg.archiver;
      "application/x-xz-compressed-tarzip" = cfg.archiver;
      "application/x-7z-compressed" = cfg.archiver;
      "application/x-zpaq" = cfg.archiver;
  
      # Other
      "application/pdf" = cfg.reader;
  
      # scheme-handler
      "x-scheme-handler/tg" = cfg.tg;
      "x-scheme-handler/tonsite" = cfg.tg;
      "x-scheme-handler/discord" = cfg.discord;
  
      # Image
      "image/jxl" = cfg.image;
      "image/png" = cfg.image;
      "image/avif" = cfg.image;
      "image/svg" = cfg.image;
      "image/jpeg" = cfg.image;
      "image/vnd.microsoft.icon" = cfg.image;
  
      # Audio
      "audio/flac" = cfg.audio;
      "audio/ogg" = cfg.audio;
      "audio/mpeg" = cfg.audio;
      "audio/mp4" = cfg.audio;
      "audio/vnd.wave" = cfg.audio;
      "audio/opus" = cfg.audio;
  
      # Video
      "video/x-matroska" = cfg.video;
      "video/mp4" = cfg.video;
    };
  };
}
