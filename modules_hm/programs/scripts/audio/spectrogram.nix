{
  config,
  pkgs,
  lib,
  ...
}:

let
  runtimes = with pkgs; [
    parallel
    sox
  ];

  walkScriptName = "aud-walk-spectre";
  scriptName = "aud-spectre";

  mainScriptPackage = pkgs.writeShellApplication {
    name = walkScriptName;
    runtimeInputs = with pkgs; [
      parallel
      scriptPackage
    ];
    text = ''
      find "$(pwd)" -type f \
        -name "*.flac" \
        -o -name "*.wav" \
        -o -name "*.alac" \
        -o -name "*.opus" \
      | parallel '${scriptName} {}'
    '';
  };

  scriptPackage = pkgs.writeShellApplication {
    name = scriptName;
    runtimeInputs = runtimes;
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
      mainScriptPackage
      scriptPackage
    ];
  };
}
