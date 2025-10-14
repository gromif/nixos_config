# System - Scripts - Audio - Flac-Remove - Silence
#

{ pkgs, lib, ... }:

let
  runtimes = with pkgs; [ parallel ffmpeg ];
  scriptName = "flac-remove_silence";
  scriptPkg = pkgs.writeShellApplication {
  	  name = scriptName;
  	  runtimeInputs = runtimes;
  	  text = ''
  	    find "$(pwd)" -type f -name "*.flac" \
  	      | parallel "mv {} {.}_old.flac && ffmpeg -i {.}_old.flac -af "silenceremove=start_periods=1:start_threshold=-70dB:start_duration=0.01:stop_periods=-1:stop_threshold=-70dB:stop_duration=0.1:detection=peak:window=0" -- {} && gio trash {.}_old.flac"
  	  '';
  	};
in
{
	environment.systemPackages = with pkgs; [ scriptPkg ];
}
