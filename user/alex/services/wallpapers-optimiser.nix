# Wallpapers Optimiser

{ config, pkgs, lib, ... }:

let
  wallpapersFolder = "${config.users.users.alex.home}/Pictures/wallpapers";
in
{
  	# Set up the 'wallpapers-optimiser' service
  	systemd.user.services."wallpapers-optimiser" = {
  	  unitConfig.Description = "Convert wallpapers to JXL";
  	  path = with pkgs; [ parallel libjxl ];
  	  script = ''
      cd ${wallpapersFolder}
      
      parallel '([ ! -f {.}.jxl ] && cjxl --allow_jpeg_reconstruction 0 {} {.}.jxl && rm {}) || rm {}' ::: *.jpg
  	  '';
  	};
  
  	# Set up the 'wallpapers-optimiser' path unit
  	systemd.user.paths."wallpapers-optimiser" = {
  	  description = "Watches for any new wallpapers in ${wallpapersFolder}";
  	  pathConfig.PathExistsGlob = "${wallpapersFolder}/*.jpg";
  	  wantedBy = [ "paths.target" ];
  	};
}
