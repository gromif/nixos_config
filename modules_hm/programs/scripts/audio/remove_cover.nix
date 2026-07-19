{
  config,
  pkgs,
  lib,
  ...
}:

let
  findPkgName = "aud-walk-remove_cover";
  findPkg = pkgs.writeShellApplication {
    name = findPkgName;
    runtimeInputs = [ pkg ];
    text = ''
      find "$(pwd)" -type f -name "*.flac" \
      -exec ${pkgName} {} \;
    '';
  };

  pkgName = "aud-remove_cover";
  pkg = pkgs.writeShellApplication {
    name = pkgName;
    runtimeInputs = with pkgs; [ flac ];
    text = ''
      metaflac --preserve-modtime --remove --block-type=PICTURE "$1"
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
