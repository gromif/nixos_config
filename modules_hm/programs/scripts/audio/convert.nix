{
  config,
  lib,
  pkgs,
  ...
}:

let
  sharedRuntimes = with pkgs; [
    parallel
    ffmpeg
  ];
  _ffmpeg = "ffmpeg -hide_banner -y -i {}";
  _trash = "mv {} {}.old";
  pattern = "*.*";

  packages = [
    # WAV
    (pkgs.writeShellApplication {
      name = "aud-to-wav";
      runtimeInputs = sharedRuntimes;
      text = ''find . -type f | parallel "${_ffmpeg} -- {.}.wav && touch -r {} {.}.wav && ${_trash}"'';
    })
    (pkgs.writeShellApplication {
      name = "aud-flac-to-wav";
      runtimeInputs = sharedRuntimes ++ [ pkgs.flac ];
      text = ''find . -type f | parallel "flac -d {} && ${_trash}"'';
    })
    # FLAC
    (pkgs.writeShellApplication {
      name = "aud-to-flac";
      runtimeInputs = sharedRuntimes;
      text = ''parallel "${_ffmpeg} -compression_level 12 -- {.}.flac && ${_trash}" ::: ${pattern}'';
    })
    # WavPack
    (pkgs.writeShellApplication {
      name = "aud-to-wavpack";
      runtimeInputs = sharedRuntimes ++ [ pkgs.wavpack ];
      text = ''find . -type f | parallel "wavpack -tmvhh --import-id3 --threads=12 {} && ${_trash}"'';
    })
  ];

  # OPUS
  opus_packages =
    let
      bitrate = [
        "90"
        "160"
        "190"
        "320"
      ];
      type = "opus";
      codec = "libopus";
    in
    map (
      b:
      (pkgs.writeShellApplication {
        name = "aud-to-opus_${b}";
        runtimeInputs = sharedRuntimes;
        text = ''parallel "${_ffmpeg} -vn -c:a ${codec} -b:a ${b}k -vbr on -- {.}.${type} && ${_trash}" ::: ${pattern}'';
      })
    ) bitrate;
in
{
  config = lib.mkIf config.hmfiles.programs.scripts.group.audio {
    home.packages =
      with pkgs;
      [
        ffmpeg
      ]
      ++ packages
      ++ opus_packages;
  };
}
