# System - Scripts


{ pkgs, ... }:

let
  scriptsMkOutput = pkgs.writeShellApplication {
    name = "scriptsMkOutput";
    text = ''
      prefix="$1"
      dir="''${prefix}_1"
      i=2

      while [[ -e "$dir" ]]; do
        dir="''${prefix}_$i"
        ((i++))
      done

      mkdir "$dir"
      echo "$dir"
    '';
  };
in
{
	imports = [
		./audio
		
		./maintainance.nix
  ];
  
  environment.systemPackages = with pkgs; [
    parallel
    
    scriptsMkOutput
  ];
}
