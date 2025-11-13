# Random Background

{ config, pkgs, lib, ... }:

let
  wallpapersFolder = "${config.users.users.alex.home}/Pictures/wallpapers";
  bootInterval = "1m";
  interval = "1h";
  randomWallpaperPkg = pkgs.writeShellApplication {
  	  name = "random-wallpaper";
  	  text = ''
  	    selectedWallpaper=$(find "${wallpapersFolder}" -type f | shuf -n 1)
  	    
  	    gsettings set org.gnome.desktop.background picture-uri "$selectedWallpaper"
  	  '';
  	};
in
{
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
      OnBootSec = "${bootInterval}";
      OnUnitActiveSec = "${interval}";
      Unit = "random-wallpaper.service";
    };
    wantedBy = ["timers.target"];
  };
}
