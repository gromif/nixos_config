# User - Alex - Config - MPD


{ config, pkgs, ... }:

let
  inherit (config.xdg.userDirs) music;
  musicDirectory = music;
in
{
  services.mpd = {
    enable = true;
    musicDirectory = musicDirectory;
    network.startWhenNeeded = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipewire"
      }
      audio_output {
        type "alsa"
        name "alsa-pipe"
      }
      audio_output {
        type      "fifo"
        name      "visualiser"
        path      "/tmp/mpd.fifo"
        format    "44100:16:2"
      }
    '';
  };
}
