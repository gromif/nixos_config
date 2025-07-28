# Screeshot Optimiser

{ config, pkgs, lib, ... }:

let
  inherit (config.xdg.userDirs) pictures;
  
  screenshotsFolder = "${pictures}/Screenshots";
  screenshotOptimiser = pkgs.writeShellApplication {
  	  name = "screenshot-optimiser";
  	  runtimeInputs = with pkgs; [
  	    parallel
  	    libjxl
  	  ];
  	  text = ''
      cd ${screenshotsFolder}
      
      # Remove screenshots older than 90 days
      find . -type f -mtime +90 -delete
      
      # Convert screenshots to the JXL format
      parallel 'cjxl -q 80 {} {.}.jxl && rm {}' ::: *.png
  	  '';
  	};
in
{
  # Install `screenshot-optimiser` binary
  home.packages = [ screenshotOptimiser ];
  	
  	# Set up Service
  	systemd.user.services."screenshot-optimiser" = {
  	  Unit.Description = "Convert Screenshots to JXL";
  	  Service = {
      ExecStart = "${lib.getExe screenshotOptimiser}";
  	  };
  	};
  
  	# Set up Timer
  systemd.user.timers."screenshot-optimiser-weekly" = {
    Unit.Description = "Convert Screenshots to JXL [Timer]";
    Timer = {
      OnCalendar = "weekly";
      Unit = "screenshot-optimiser.service";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
  
}
