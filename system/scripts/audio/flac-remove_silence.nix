# System - Scripts - Audio - Remove - Silence
#

{ pkgs, lib, ... }:

let
  mainScriptName = "aud-walk-remove_silence";
  mainScriptPkg = pkgs.writeShellApplication {
    name = mainScriptName;
    runtimeInputs = with pkgs; [ parallel scriptPkg ];
    text = ''
      find "$(pwd)" -type f \
        -name "*.flac" \
        -o -name "*.wav" \
        -o -name "*.alac" \
      | parallel --will-cite 'aud-remove_silence {}'
    '';
  };
  scriptName = "aud-remove_silence";
  scriptPkg = pkgs.writeShellApplication {
    name = scriptName;
    runtimeInputs = with pkgs; [ ffmpeg glib ];
    text = ''
      file="$1"
      base=$(basename "$file")
      old="''${base}_old.flac"

      # Extract bit depth safely
      bit_depth=$(ffprobe -v error -select_streams a:0 \
        -show_entries stream=bits_per_raw_sample \
        -of default=noprint_wrappers=1:nokey=1 "$file" || true)
      
      # Default if empty or unset
      if [ -z "$bit_depth" ]; then
        bit_depth=16
      fi
      case "$bit_depth" in
        16) sample_fmt="s16" ;;
        24|32) sample_fmt="s32" ;;
        *) sample_fmt="s16" ;; # fallback
      esac

      mv "$file" "$old"

      ffmpeg -hide_banner -loglevel error -i "$old" \
        -af "silenceremove=start_periods=1:start_threshold=-70dB:start_duration=0.01:stop_periods=-1:stop_threshold=-70dB:stop_duration=0.1:detection=peak:window=0" \
        -sample_fmt "$sample_fmt" "$file"

      gio trash "$old"
    '';
  };
in
{
  environment.systemPackages = with pkgs; [ scriptPkg mainScriptPkg ];
}

