{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nixfiles.de.gnome.services.random-background;
  intervals = types.enum [ "1m" "5m" "15m" "30m" "45m" "1h" "3h" "6h" ];
  wallpapersFolder = "$HOME/Pictures/wallpapers";
  randomWallpaperPkg = pkgs.writeShellApplication {
  	  name = "random-wallpaper";
  	  text = ''
  	    selectedWallpaper=$(find "${wallpapersFolder}" -type f | shuf -n 1)
  	    
  	    gsettings set org.gnome.desktop.background picture-uri "$selectedWallpaper"
  	  '';
  	};
in
{
  options.nixfiles.de.gnome.services.random-background = {
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
    # Install `randomWallpaperPkg` binary
    environment.systemPackages = [ randomWallpaperPkg ];
	
  	# Set up automatic `randomWallpaperPkg`
  	systemd.user.services.random-wallpaper = {
  	  description = "Set random wallpaper";
  	  script = "${lib.getExe randomWallpaperPkg}";
  	};
  
    # Set up automatic `randomWallpaperPkg` timer
    systemd.user.timers.random-wallpaper = {
      description = "Set random wallpaper [Timer]";
      timerConfig = {
        OnBootSec = "${cfg.initialInterval}";
        OnUnitActiveSec = "${cfg.interval}";
        Unit = "random-wallpaper.service";
      };
      wantedBy = ["timers.target"];
    };
  };
}
