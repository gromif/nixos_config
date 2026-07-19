{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.services.screenshots-optimiser;
  pkg = pkgs.writeShellApplication {
    name = "optimise-screenshots";
    runtimeInputs = with pkgs; [ libjxl ];
    text = ''
      cd ${cfg.dir}

      find "${cfg.dir}" -name "*.png" -exec sh -c '
        f="$1"

        cjxl -q 60 "$f" "''${f%.png}.jxl"
      ' sh {} \; \
      -delete
    '';
  };
  pkg_cleanup = pkgs.writeShellApplication {
    name = "cleanup-screenshots";
    runtimeInputs = with pkgs; [ libjxl ];
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
    home.packages = [
      pkg
      pkg_cleanup
    ];

    systemd.user.services."screenshots-optimiser" = {
      Service.ExecStart = "${getExe pkg}";
      Unit.Description = "Convert PNG screenshots to JXL";
    };

    systemd.user.paths."screenshots-optimiser" = {
      Path = {
        PathExistsGlob = "${cfg.dir}/*.png";
      };
      Unit = {
        Description = "Watches for any new screenshots in ${cfg.dir}";
      };
      Install.WantedBy = [ "paths.target" ];
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
