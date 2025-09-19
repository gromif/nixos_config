# System - Scripts - Audio - Flac-Tags - Cleanup
#

{ pkgs, lib, ... }:

let
  runtimes = with pkgs; [ parallel flac ];
  whitelist = [
    "ALBUM"
    "ALBUMARTIST"
    "ARTIST"
    "AUTHOR"
    "BPM"
    "COMPOSER"
    "COMPILATION"
    "DATE"
    "DISCNUMBER"
    "DISCTOTAL"
    "GENRE"
    "ISRC"
    "LENGTH"
    "LYRICS"
    "RATING"
    "REPLAYGAIN_TRACK_PEAK"
    "REPLAYGAIN_TRACK_GAIN"
    "REPLAYGAIN_ALBUM_GAIN"
    "TITLE"
    "TBPM"
    "TRACKNUMBER"
    "TRACKTOTAL"
  ];
  tagsList = whitelist ++ (map (t: lib.strings.toLower t) whitelist);
  args = lib.strings.concatStrings (map (i: "=${i}") tagsList);
  
  scriptName = "flac-tags_cleanup";
  scriptPkg = pkgs.writeShellApplication {
  	  name = scriptName;
  	  runtimeInputs = runtimes;
  	  text = ''
  	    find "$(pwd)" -type f -name "*.flac" \
  	      | parallel "metaflac --remove-all-tags-except${args} {}"
  	  '';
  	};
in
{
	environment.systemPackages = with pkgs; [ scriptPkg ];
}
