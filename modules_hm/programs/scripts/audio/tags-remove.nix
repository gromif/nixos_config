{
  config,
  pkgs,
  lib,
  ...
}:

let
  tags = [
    "album"
    "albumArtist"
    "artist"
    "author"
    "bpm"
    "composer"
    "compilation"
    "date"
    "discNumber"
    "discTotal"
    "genre"
    "isrc"
    "length"
    "lyrics"
    "performer"
    "rating"
    "release_date"
    "replayGain_track_peak"
    "replayGain_track_gain"
    "replayGain_album_gain"
    "title"
    "tbpm"
    "trackNumber"
    "trackTotal"
    "vgmdb"
  ];
  scripts = lib.concatMap (
    t:
    let
      name = t;
      walkPkgName = "aud-walk-remove-${name}";
      pkgName = "aud-remove-${name}";

      pkg = pkgs.writeShellApplication {
        name = pkgName;
        runtimeInputs = with pkgs; [ flac ];
        text =
          let
            tag = lib.strings.toUpper t;
          in
          ''
            filePath="$1"

            metaflac --preserve-modtime \
              --remove-tag=${tag} \
              "$filePath"
          '';
      };
    in
    [
      pkg
      (pkgs.writeShellApplication {
        name = walkPkgName;
        runtimeInputs = [ pkg ];
        text = ''
          find . -type f -name "*.flac" \
            -exec ${pkgName} {} \;
        '';
      })
    ]
  ) tags;
in
{
  config = lib.mkIf config.hmfiles.programs.scripts.group.audio {
    home.packages = scripts;
  };
}
