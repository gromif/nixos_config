{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.redroid;
  redroidRoot = "%h/.local/share/redroid";
  relativePaths = [
    "system/dropbox/*"
    "tombstones"
  ];
in
{
  options.hmfiles.programs.redroid = {
    enable = mkEnableOption "redroid";
  };

  config = mkIf cfg.enable {
    systemd.user.tmpfiles.rules = builtins.map (it: "R ${redroidRoot}/*/${it} - - - - -") relativePaths;

    # System packages
    home.packages = with pkgs; [ scrcpy ];
  };
}
