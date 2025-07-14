# Home - Services - Random Background

{ config, pkgs, lib, ... }:

let
  wallpapersFolder = "${config.home.homeDirectory}/Pictures/wallpapers";
  bootInterval = "1m";
  interval = "1h";
  randomWallpaperPkg = pkgs.writeShellApplication {
  	  name = "random-wallpaper";
  	  text = ''
  	    selectedWallpaper=$(find ${wallpapersFolder} -type f | shuf -n 1)
  	    
  	    gsettings set org.gnome.desktop.background picture-uri "$selectedWallpaper"
  	  '';
  	};
in
{
  # Install `randomWallpaperPkg` binary
  home.packages = [ randomWallpaperPkg ];
  	
  	# Set up automatic `randomWallpaperPkg`
  	systemd.user.services.random-wallpaper = {
  	  Unit.Description = "Set random wallpaper";
  	  Service = {
      ExecStart = "${lib.getExe randomWallpaperPkg}";
  	  };
  	};
  
  	# Set up automatic `randomWallpaperPkg` timer
  systemd.user.timers.random-wallpaper = {
    Unit.Description = "Set random wallpaper [Timer]";
    Timer = {
      OnBootSec = "${bootInterval}";
      OnUnitActiveSec = "${interval}";
      Unit = "random-wallpaper.service";
    };
    Install.WantedBy = ["timers.target"];
  };
}
