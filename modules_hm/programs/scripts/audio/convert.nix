{
  config,
  lib,
  pkgs,
  ...
}:

let
  sharedRuntimes = with pkgs; [
    ffmpeg
    glib
  ];
  _ffmpeg = "ffmpeg -hide_banner -y -i $1";
  _trash = "gio trash -f $f";
  pattern = "*.*";

  packages = [
    # WAV
    (pkgs.writeShellApplication {
      name = "aud-to-wav";
      runtimeInputs = sharedRuntimes;
      text = ''
        find "$(pwd)" -type f -name "${pattern}" -exec sh -c '
          f="$1"
          
          ${_ffmpeg} -- "''${f%.*}.wav" && ${_trash}
        ' sh {} \;
      '';
    })
    # FLAC
    (pkgs.writeShellApplication {
      name = "aud-to-flac";
      runtimeInputs = sharedRuntimes;
      text = ''
        find "$(pwd)" -type f -name "${pattern}" -exec sh -c '
          f="$1"

          ${_ffmpeg} -compression_level 12 -- "''${f%.*}.flac" && ${_trash}
        ' sh {} \;
      '';
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
        text = ''
          find "$(pwd)" -type f -name "${pattern}" -exec sh -c '
            f="$1"

            ${_ffmpeg} -vn -c:a ${codec} -b:a ${b}k -vbr on -- "''${f%.*}.${type}" && ${_trash}
          ' sh {} \;
        '';
      })
    ) bitrate;
in
{
  config = lib.mkIf config.hmfiles.programs.scripts.group.audio {
    home.packages = packages ++ opus_packages;
  };
}
