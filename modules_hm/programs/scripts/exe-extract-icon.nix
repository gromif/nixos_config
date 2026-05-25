{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  name = "exe-extract-icon";
  cfg = config.hmfiles.programs.scripts."${name}";
  pkg = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      icoutils
      imagemagick
    ];
    text = ''
      targetExe=$1
      out=icon.ico

      wrestool -x -t 14 "$targetExe" > $out
      magick $out "$out".png && rm $out
    '';
  };
in
{
  options.hmfiles.programs.scripts."${name}" = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include a helper-script to find desktop files";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ];
  };
}
