# Scripts - Audio - Remove Cover
#

{ pkgs, lib, ... }:

let
  runtimes = with pkgs; [ parallel flac ];
  
  mainScriptName = "aud-walk-remove_cover";
  mainScriptPkg = pkgs.writeShellApplication {
    name = mainScriptName;
    runtimeInputs = with pkgs; [ parallel scriptPkg ];
    text = ''
      find "$(pwd)" -type f -name "*.flac" \
      | parallel --will-cite '${scriptName} {}'
    '';
  };
  
  scriptName = "aud-remove_cover";
  scriptPkg = pkgs.writeShellApplication {
  	  name = scriptName;
  	  runtimeInputs = runtimes;
  	  text = ''
  	    metaflac --preserve-modtime --remove --block-type=PICTURE {}
  	  '';
  	};
in
{
	environment.systemPackages = with pkgs; [ scriptPkg mainScriptPkg ];
}
