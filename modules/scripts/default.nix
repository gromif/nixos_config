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
  
  audioList = builtins.attrNames (builtins.readDir ./audio);
  audio = map (c: ./audio + "/${c}") audioList;
in
{
	imports = [
		./maintainance.nix
		./ssh.nix
  ] ++ audio;
  
  environment.systemPackages = with pkgs; [
    parallel
    
    scriptsMkOutput
  ];
}
