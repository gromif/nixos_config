# System - Scripts


{ pkgs, ... }:

let
  scriptsMkOutput = pkgs.writeShellApplication {
    name = "scriptsMkOutput";
    text = ''
      prefix="$1"
      targetDate="$(date "+%a %d - %X - %b %Y")"
      dir="''${prefix} — ''${targetDate}"

      mkdir "$dir"
      echo "$dir"
    '';
  };
in
{
	imports = [
		./audio
		
		./impermanence.nix
		./maintainance.nix
  ];
  
  environment.systemPackages = with pkgs; [
    parallel
    
    scriptsMkOutput
  ];
}
