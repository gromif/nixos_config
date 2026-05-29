{
  config,
  pkgs,
  lib,
  ...
}:

let
  runtimes = with pkgs; [
    parallel
    glib
    sox
  ];
  bits = [
    16
    24
    32
  ];

  walkScriptName = "aud-walk-resample";
  scriptName = "aud-resample";

  mainScriptPackages = map (
    b:
    pkgs.writeShellApplication {
      name = "${walkScriptName}_${toString b}";
      runtimeInputs = with pkgs; [ parallel ] ++ scriptPackages;
      text = ''
        find "$(pwd)" -type f \
          -name "*.flac" \
          -o -name "*.wav" \
          -o -name "*.alac" \
        | parallel '${scriptName}_${toString b} {}'
      '';
    }
  ) bits;

  scriptPackages = map (
    b:
    (pkgs.writeShellApplication {
      name = "${scriptName}_${toString b}";
      runtimeInputs = runtimes;
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
    home.packages = mainScriptPackages ++ scriptPackages;
  };
}
