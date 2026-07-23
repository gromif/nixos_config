{
  config,
  pkgs,
  lib,
  ...
}:

let
  bits = [
    16
    24
    32
  ];

  findPkgName = "aud-walk-resample";
  pkgName = "aud-resample";

  findPkgs = map (
    b:
    pkgs.writeShellApplication {
      name = "${findPkgName}_${toString b}";
      runtimeInputs = packages;
      text = ''
        find "$(pwd)" -type f \
          -name "*.flac" \
          -o -name "*.wav" \
          -o -name "*.alac" |
          parallel '${pkgName}_${toString b} {}'
      '';
    }
  ) bits;

  packages = map (
    b:
    (pkgs.writeShellApplication {
      name = "${pkgName}_${toString b}";
      runtimeInputs = with pkgs; [
        glib
        sox
      ];
      text = ''
        filePath="$1"
        tempFile="''${filePath}.old"

        mv "$filePath" "$tempFile"

        (sox "$tempFile" -G -b ${toString b} "$filePath" && gio trash "$tempFile") ||
          mv -f "$tempFile" "$filePath"
      '';
    })
  ) bits;
in
{
  config = lib.mkIf config.hmfiles.programs.scripts.group.audio {
    home.packages = findPkgs ++ packages;
  };
}
