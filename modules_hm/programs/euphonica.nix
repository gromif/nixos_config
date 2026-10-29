{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.euphonica;
  root = "io/github/htkhiem/Euphonica";
in
{
  options.hmfiles.programs.euphonica = {
    enable = mkEnableOption "Euphonica package";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.euphonica ];
    dconf.settings = with lib.gvariant; {
      "${root}/client" = {
        mpd-visualizer-pcm-source = "pipewire";
      };

      "${root}/library" = {
        max-image-resolution = mkUint32 2048;
        optimize-embedded-cover-loading = false;
      };

      "${root}/metaprovider/musicbrainz" = {
        enabled = true;
        download-artist-avatar = true;
      };

      "${root}/metaprovider/lrclib".enable = true;

      "${root}/metaprovider/lastfm" = {
        enable = true;
        api-key = "ff842c90bce93bb9f218a279ac80640f";
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
        max-columns = mkUint32 9;
        use-album-art-as-bg = true;
        use-hires-for-album-cells = true;
        use-visualizer = false;
      };
    };
  };
}
