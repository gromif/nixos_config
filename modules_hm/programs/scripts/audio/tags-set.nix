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
    "composer"
    "compilation"
    "date"
    "discNumber"
    "discTotal"
    "genre"
    "performer"
    "release_date"
    "title"
    "trackNumber"
    "trackTotal"
  ];
  scripts = lib.concatMap (
    t:
    let
      name = t;
      walkPkgName = "aud-walk-set-${name}";
      pkgName = "aud-set-${name}";

      pkg = pkgs.writeShellApplication {
        name = pkgName;
        runtimeInputs = with pkgs; [ flac ];
        text =
          let
            tag = lib.strings.toUpper t;
          in
          ''
            filePath="$1"
            value=$2

            metaflac --preserve-modtime \
              --remove-tag=${tag} \
              --set-tag="${tag}=$value" \
              "$filePath"
          '';
      };
    in
    [
      pkg
      (pkgs.writeShellApplication {
        name = walkPkgName;
        runtimeInputs = with pkgs; [
          parallel
          pkg
        ];
        text = ''
          find . -type f -name "*.flac" |
            parallel "${pkgName} {} $1"
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
