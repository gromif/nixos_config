{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.services.wallpapers-optimiser;
  pkg = pkgs.writeShellApplication {
    name = "optimise-wallpapers";
    runtimeInputs = with pkgs; [ libjxl ];
    text = ''
      cd ${cfg.dir}

      find "$(pwd)" -type f -name "*.jpg" \
        -exec sh -c '
          f="$1"
          f_jxl="$(basename $f .jpg).jxl"
          
          ([ ! -f "$f_jxl" ] && cjxl --allow_jpeg_reconstruction 0 "$f" "$f_jxl" && rm "$f") || rm "$f"          
        ' sh {} \;
    '';
  };
in
{
  options.hmfiles.services.wallpapers-optimiser = {
    enable = mkEnableOption "wallpaper-optimiser service";
    dir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Pictures/wallpapers";
      description = "Wallpapers dir";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ];
    # Set up the 'wallpapers-optimiser' service
    systemd.user.services."wallpapers-optimiser" = {
      Service.ExecStart = "${getExe pkg}";
      Unit.Description = "Convert wallpapers to JXL";
    };

    # Set up the 'wallpapers-optimiser' path unit
    systemd.user.paths."wallpapers-optimiser" = {
      Path = {
        PathExistsGlob = "${cfg.dir}/*.jpg";
      };
      Unit = {
        Description = "Watches for any new wallpapers in ${cfg.dir}";
      };
      Install.WantedBy = [ "paths.target" ];
    };
  };
}
