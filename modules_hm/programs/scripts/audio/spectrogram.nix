{
  config,
  pkgs,
  lib,
  ...
}:

let
  findPkgName = "aud-walk-spectre";
  pkgName = "aud-spectre";

  findPkg = pkgs.writeShellApplication {
    name = findPkgName;
    runtimeInputs = with pkgs; [
      parallel
      pkg
    ];
    text = ''
      find "$(pwd)" -type f \
        -name "*.flac" \
        -o -name "*.wav" \
        -o -name "*.alac" \
        -o -name "*.opus" | parallel '${pkgName} {}'
    '';
  };

  pkg = pkgs.writeShellApplication {
    name = pkgName;
    runtimeInputs = with pkgs; [ sox ];
    text = ''
      filePath="$1"
      outputFile="''${filePath}.png"

      sox "$filePath" -n spectrogram -x 2048 -Y 2048 -z 140 -o "$outputFile"
    '';
  };
in
{
  config = lib.mkIf config.hmfiles.programs.scripts.group.audio {
    home.packages = [
      pkg
      findPkg
    ];
  };
}
