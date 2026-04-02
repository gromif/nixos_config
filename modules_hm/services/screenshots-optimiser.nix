{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.hmfiles.services.screenshots-optimiser;
  pkg = pkgs.writeShellApplication {
    name = "optimise-screenshots";
    runtimeInputs = with pkgs; [ parallel libjxl ];
    text = ''
      cd ${cfg.dir}

      parallel 'cjxl -q 80 {} {.}.jxl && rm {}' ::: *.png
    '';
  };
  pkg_cleanup = pkgs.writeShellApplication {
    name = "cleanup-screenshots";
    runtimeInputs = with pkgs; [ parallel libjxl ];
    text = ''find "${cfg.dir}" -type f -mtime +90 -delete'';
  };
in
{
  options.hmfiles.services.screenshots-optimiser = {
    enable = mkEnableOption "screenshots-optimiser service";
    dir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Pictures/Screenshots";
      description = "Screenshots dir";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ];
    
    systemd.user.services."screenshots-optimiser" = {
      Service.ExecStart = "${getExe pkg}";
      Unit.Description = "Convert PNG screenshots to JXL";
    };

    systemd.user.paths."screenshots-optimiser" = {
      Path = {
        PathExistsGlob = "${cfg.dir}/*.jpg";
      };
      Unit = {
        Description = "Watches for any new screenshots in ${cfg.dir}";
        WantedBy = [ "paths.target" ];
      };
    };

    systemd.user.services."screenshots-cleanup" = {
      Service.ExecStart = "${getExe pkg_cleanup}";
      Unit.Description = "Removes old screenshots";
    };
    systemd.user.timers."screenshots-cleanup-weekly" = {
      Timer = {
        OnCalendar = "weekly";
        Unit = "screenshots-optimiser.service";
        Persistent = true;
      };
      Unit.Description = "A weekly timer for removing old screenshots";
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
