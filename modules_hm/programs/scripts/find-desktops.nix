{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.scripts.find-desktops;
  usr = config.home.username;
  pkg = pkgs.writeShellApplication {
    name = "find-desktops";
    text = ''
      echo "********************************"
      echo "************SYSTEM**************"
      echo "********************************"
      ls /run/current-system/sw/share/applications/

      echo "********************************"
      echo "************${usr}**************"
      echo "********************************"
      ls /etc/profiles/per-user/${usr}/share/applications/
    '';
  };
in
{
  options.hmfiles.programs.scripts.find-desktops = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include a helper-script to find desktop files";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ];
  };
}
