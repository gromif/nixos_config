{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.megasync;

  pkgAppData = "%h";
  tmpFilesRules = map (f: "R \"${pkgAppData}/${f}\" - - - - -") [
    ".local/share/data/Mega Limited/MEGAsync/logs/"
    ".local/share/data/Mega Limited/MEGAsync/crashDumps/"
  ];
  pkg = pkgs.megasync;
in
{
  options.hmfiles.programs.megasync = {
    enable = mkEnableOption "MegaSync";
    users = mkOption {
      type = types.listOf types.str;
      description = "User-profile list to include the package";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # Set up Tmpfiles rules
      systemd.user.tmpfiles.rules = tmpFilesRules;

      # Set up the package
      home.packages = [ pkg ];
    })
  ];
}
