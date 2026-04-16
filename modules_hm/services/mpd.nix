{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.services.mpd;
in
{
  options.hmfiles.services.mpd = {
    enable = mkEnableOption "preconfigured MPD service";
  };

  config = mkIf (cfg.enable) {
    services.mpd = {
      enable = true;
      musicDirectory = config.xdg.userDirs.music;
      network.startWhenNeeded = true;
      extraConfig = ''
        audio_output {
          type "alsa"
          name "ALSA"
          device      "front:CARD=ZH3"
          mixer_type  "none"
        }
        audio_output {
          type "pipewire"
          name "PipeWire"
        }
        audio_output {
          type      "fifo"
          name      "visualiser"
          path      "/tmp/mpd.fifo"
          format    "44100:16:2"
        }
      '';
    };
  };
}
