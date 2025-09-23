# Unarchiver

{ config, pkgs, ... }:

let
  downloadsFolder = "${config.users.users.alex.home}/Downloads";
  findBase = "find -depth -maxdepth 1 -type f -name ";
in
{
  	# Set up the 'unarchiver' service
  	systemd.user.services."unarchiver" = {
  	  unitConfig.Description = "Unpack supported arhives in ${downloadsFolder}";
  	  path = with pkgs; [ parallel unzip unrar ];
  	  serviceConfig.WorkingDirectory = downloadsFolder;
  	  script = ''
      ${findBase} "*.zip" | parallel 'mkdir {.} && unzip -o -d {.} {} && rm {}'
      ${findBase} "*.rar" | parallel 'unrar x -o -y {} {.}/ && rm {}'
      ${findBase} "*.7z" | parallel '7z x -y {} && rm {}'
  	  '';
  	};
  
  	# Set up the 'unarchiver' path unit
  	systemd.user.paths."unarchiver" = {
  	  description = "Watches for any supported archives in ${downloadsFolder}";
  	  pathConfig.PathExistsGlob = map (f: "${downloadsFolder}/*." + f) [
  	    "zip" "rar" "7z"
  	  ];
  	  wantedBy = [ "paths.target" ];
  	};
}
