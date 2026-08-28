{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.services.mpd;
  aliasesSource = [
    "services"
    "mpd"
  ];
  aliasesTarget = [ "hmfiles" ] ++ aliasesSource;
  aliases =
    map (option: mkAliasOptionModule (aliasesTarget ++ [ option ]) (aliasesSource ++ [ option ]))
      [
        "musicDirectory"
      ];
in
{
  imports = aliases;

  options.hmfiles.services.mpd = {
    enable = mkEnableOption "preconfigured MPD service";
    alsa = {
      enable = mkEnableOption "ALSA output support";
      device = mkOption {
        type = types.str;
        default = "front:CARD=ZH3";
        description = "Which sound device to use with the ALSA output";
      };
    };
  };

  config = mkIf (cfg.enable) {
    services.mpd = {
      enable = true;
      # musicDirectory = config.xdg.userDirs.music;
      network.startWhenNeeded = true;
      extraConfig = ''
        ${optionalString cfg.alsa.enable ''
          audio_output {
            type "alsa"
            name "ALSA"
            device      "${cfg.alsa.device}"
            mixer_type  "none"
          }
        ''}
        audio_output {
          type "pipewire"
          name "PipeWire"
          dsd  "yes"
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
