# System - Scripts - Audio - Convert


{ pkgs, ... }:

let
  sharedRuntimes = with pkgs; [ parallel ffmpeg glib ];
  _parallel = "parallel --will-cite";
  _ffmpeg = "ffmpeg -hide_banner -y -i {}";
  _trash = "gio trash -f {}";
  pattern = "*.*";
  
  
  packages = [
    # WAV
    (pkgs.writeShellApplication {
    	  name = "aud-to-wav";
    	  runtimeInputs = sharedRuntimes;
    	  text = ''
    	    ${_parallel} "${_ffmpeg} -- {.}.wav && ${_trash}" ::: ${pattern}
    	  '';
    	})
    	# FLAC
    	(pkgs.writeShellApplication {
    	  name = "aud-to-flac";
    	  runtimeInputs = sharedRuntimes;
    	  text = ''
    	    ${_parallel} "${_ffmpeg} -- {.}.flac && ${_trash}" ::: ${pattern}
    	  '';
    	})
  ];
  
  # OPUS
  opus_packages = let
    bitrate = [ "90" "160" "190" "320" ];
    type = "opus";
    codec = "libopus";
  in map(b: 
    (pkgs.writeShellApplication {
    	  name = "aud-to-opus_${b}";
    	  runtimeInputs = sharedRuntimes;
    	  text = ''
    	    ${_parallel} "${_ffmpeg} -vn -c:a ${codec} -b:a ${b}k -vbr on -- {.}.${type} && ${_trash}" ::: ${pattern}
    	  '';
    	})
  ) bitrate;
in
{
	environment.systemPackages = with pkgs; [
    ffmpeg
  ] ++ packages ++ opus_packages;
}
