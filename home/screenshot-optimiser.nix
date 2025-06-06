# Screeshot Optimiser

{ config, pkgs, ... }:

let
  screenshotsFolder = "~/Pictures/Screenshots";
  screenshotOptimiser = pkgs.writeShellApplication {
  	  name = "screenshot-optimiser";
  	  runtimeInputs = with pkgs; [
  	    parallel
  	    libjxl
  	  ];
  	  text = ''
      convert_to_jxl() {
        FILE="$1"
        BASENAME=$(basename "$FILE" .png)
        cjxl -q 80 "$FILE" "./$BASENAME.jxl"
        rm "$FILE"
      }
      
      cd ${screenshotsFolder}
      
      # Remove screenshots older than 90 days
      find ./ -type f -mtime +90 -delete
      
      # Export the function for parallel to use
      export -f convert_to_jxl
      
      find ./ -type f -name "*.png" | parallel convert_to_jxl
  	  '';
  	};
in
{
  # Install `screenshot-optimiser` binary
  home.packages = [ screenshotOptimiser ];
  	
  	# Set up automatic `screenshot-optimiser`
  	systemd.user.services."screenshot-optimiser" = {
  	  Unit.Description = "Convert Screenshots to JXL";
  	  Service = {
      ExecStart = "${screenshotOptimiser}/bin/screenshot-optimiser";
  	  };
  	};
  
  	# Set up automatic `screenshot-optimiser` timer
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
