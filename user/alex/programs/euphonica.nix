# User - Programs - Euphonica


{ lib, pkgs, ... }:

with lib.gvariant;

let
  root = "io/github/htkhiem/Euphonica";
  dconfSettings = {
    "${root}/client" = {
      mpd-fifo-format = "44100:16:2";
      mpd-fifo-path = "/tmp/mpd.fifo";
      mpd-visualizer-pcm-source = "fifo";
    };
    
    "${root}/player" = {
      visualizer-fft-samples = mkUint32 4096;
      visualizer-fps = mkUint32 30;
      visualizer-spectrum-bins = mkUint32 10;
      visualizer-spectrum-curr-step-weight = 0.20000000000000007;
      visualizer-spectrum-max-hz = mkUint32 16000;
      visualizer-spectrum-min-hz = mkUint32 30;
      visualizer-spectrum-use-log-bins = true;
    };
    
    "${root}/state" = {
      autostart = false;
      run-in-background = false;
    };

    "${root}/state/albumview" = {
      sort-direction = "asc";
    };

    "${root}/ui" = {
      bg-opacity = 0.36;
      max-columns = mkInt32 9;
      use-album-art-as-bg = true;
      use-visualizer = true;
      visualizer-blend-mode = mkUint32 6;
      visualizer-gradient-height = 0.10000000000000002;
      visualizer-scale = 4.0;
      visualizer-stroke-width = 0.0;
      visualizer-top-opacity = 0.8999999999999999;
      visualizer-use-splines = true;
    };
  };
in
{
  environment.systemPackages = [ pkgs.euphonica ];
  programs.dconf.profiles.user.databases = [ { settings = dconfSettings; } ];
}
