{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.gapless;
  root = "com/github/neithern/g4music";
in
{
  options.hmfiles.programs.gapless = {
    enable = mkEnableOption "Gapless package";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.gapless ];
    dconf.settings = with lib.gvariant; {
      "${root}" = {
        rotate-cover = false;
        show-peak = false;
        volume = 1.0;
        width = mkInt32 1269;
      };
    };
  };
}
