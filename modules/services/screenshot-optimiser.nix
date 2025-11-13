# Screeshot Optimiser

{ config, pkgs, lib, ... }:

let
  screenshotsFolder = "${config.users.users.alex.home}/Pictures/Screenshots";
in
{
  	# Set up the 'screenshot-optimiser' service
  	systemd.user.services."screenshot-optimiser" = {
  	  unitConfig.Description = "Convert Screenshots to JXL";
  	  path = with pkgs; [ parallel libjxl ];
  	  script = ''
      cd ${screenshotsFolder}
      
      # Convert screenshots to the JXL format
      parallel 'cjxl -q 80 {} {.}.jxl && rm {}' ::: *.png
  	  '';
  	};
  	
  		# Set up the 'remove-old-screenshots' service
  	systemd.user.services."remove-old-screenshots" = {
  	  unitConfig.Description = "Removes old screenshots";
  	  script = ''
      # Remove screenshots older than 90 days
      find "${screenshotsFolder}" -type f -mtime +90 -delete
  	  '';
  	};
  
  	# Set up the 'screenshot-optimiser' path unit
  	systemd.user.paths."screenshot-optimiser" = {
  	  description = "Watches for any new png screenshots in ${screenshotsFolder}";
  	  pathConfig.PathExistsGlob = "${screenshotsFolder}/*.png";
  	  wantedBy = [ "paths.target" ];
  	};
  	
  	# Set up the 'remove-old-screenshots-weekly' timer
  systemd.user.timers."remove-old-screenshots-weekly" = {
    description = "Removes old screenshots [Timer]";
    timerConfig = {
      OnCalendar = "weekly";
      Unit = "remove-old-screenshots.service";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
