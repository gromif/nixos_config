{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.hmfiles.services.random-background;
  intervals = types.enum [ "1m" "5m" "15m" "30m" "45m" "1h" "3h" "6h" ];
  wallpapersFolder = "${config.xdg.userDirs.pictures}/wallpapers";
  randomWallpaperPkg = pkgs.writeShellApplication {
	  name = "random-wallpaper";
	  text = ''
	    selectedWallpaper=$(find "${wallpapersFolder}" -type f | shuf -n 1)
	    
	    gsettings set org.gnome.desktop.background picture-uri "$selectedWallpaper"
	  '';
  };
in
{
  options.hmfiles.services.random-background = {
    enable = mkEnableOption "the Random-Background service";
    interval = mkOption {
      type = intervals;
      default = "1h";
      description = "Standard interval to the next wallpaper change";
    };
    initialInterval = mkOption {
      type = intervals;
      default = "1m";
      description = "Initial service startup delay (boot)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ randomWallpaperPkg ];
	
  	systemd.user.services.random-wallpaper = {
  	  Unit.Description = "Set random wallpaper";
  	  Service.ExecStart = "${getExe randomWallpaperPkg}";
  	};
  
    systemd.user.timers.random-wallpaper = {
      Unit.Description = "Set random wallpaper [Timer]";
      Timer = {
        OnBootSec = "${cfg.initialInterval}";
        OnUnitActiveSec = "${cfg.interval}";
        Unit = "random-wallpaper.service";
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
