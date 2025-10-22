# System - Scripts - Audio - Convert


{ pkgs, ... }:

let
  sharedRuntimes = with pkgs; [ parallel ffmpeg glib ];
  base_ffmpeg = "ffmpeg -hide_banner -y -i {}";
  base_trash = "gio trash -f {}";
  pattern = "*.*";
  
  
  packages = [
    # WAV
    (pkgs.writeShellApplication {
    	  name = "aud-to-wav";
    	  runtimeInputs = sharedRuntimes;
    	  text = ''
    	    parallel "${base_ffmpeg} -- {.}.wav && ${base_trash}" ::: ${pattern}
    	  '';
    	})
    	# FLAC
    	(pkgs.writeShellApplication {
    	  name = "aud-to-flac";
    	  runtimeInputs = sharedRuntimes;
    	  text = ''
    	    parallel "${base_ffmpeg} -- {.}.flac && ${base_trash}" ::: ${pattern}
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
    	    parallel "${base_ffmpeg} -vn -c:a ${codec} -b:a ${b}k -vbr on -- {.}.${type} && ${base_trash}" ::: ${pattern}
    	  '';
    	})
  ) bitrate;
in
{
	environment.systemPackages = with pkgs; [
    ffmpeg
  ] ++ packages ++ opus_packages;
}
