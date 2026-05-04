{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.programs.megasync;
  cfgSandbox = config.nixfiles.security.sandbox;

  pkgAppData = (if (cfg.sandbox && cfgSandbox.enable) then "%h/.bwrapper/megasync" else "%h");
  tmpFilesRules = map (f: "R \"${pkgAppData}/${f}\" - - - - -") [
    "local/share/data/Mega Limited/MEGAsync/logs/"
    "local/share/data/Mega Limited/MEGAsync/crashDumps/"
  ];
  pkg = pkgs.megasync;
  pkg-wrapped = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.desktop ];
    app = {
      package = pkg;
      id = "com.mega.MegaSync";
      env = {
        QT_QPA_PLATFORMTHEME = "";
        QT_STYLE_OVERRIDE = "";
        SESSION_MANAGER = "";
      };
    };
    fhsenv.opts = {
      unshareUser = true;
      unshareUts = true;
      unshareCgroup = true;
    };
    mounts = {
      sandbox = [
        {
          name = "Downloads";
          path = "$HOME/MEGA downloads";
        }
      ];
    };
  };
in
{
  options.nixfiles.programs.megasync = {
    enable = mkEnableOption "MegaSync";
    users = mkOption {
      type = types.listOf types.str;
      description = "User-profile list to include the package";
    };
    sandbox = mkEnableOption "BubbleWrap sandbox feature for this package";
  };

  config = mkMerge [
    ({
      nixfiles.programs.megasync.sandbox = mkDefault true;
    })
    (mkIf cfg.enable {
      # Set up Tmpfiles rules
      systemd.user.tmpfiles.rules = tmpFilesRules;

      # Set up the package
      users.users = builtins.listToAttrs (
        map (u: {
          name = u;
          value = {
            packages = [ (if (cfg.sandbox && cfgSandbox.enable) then pkg-wrapped else pkg) ];
          };
        }) cfg.users
      );
    })
  ];
}
