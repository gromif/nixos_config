{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.hmfiles.services.wallpapers-optimiser;
  pkg = pkgs.writeShellApplication {
    name = "optimise-wallpapers";
    runtimeInputs = with pkgs; [ parallel libjxl ];
    text = ''
      cd ${cfg.dir}

      parallel '([ ! -f {.}.jxl ] && cjxl --allow_jpeg_reconstruction 0 {} {.}.jxl && rm {}) || rm {}' ::: *.jpg
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
    home.packages = [ pkg  ];
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
        WantedBy = [ "paths.target" ];
      };
    };
  };
}
