{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.games.prism-launcher;
  cfgSandbox = config.nixfiles.security.sandbox;

  pkgAppData = (if (cfg.sandbox && cfgSandbox.enable) then "%h/.bwrapper/megasync" else "%h");
  tmpFilesRules = map (f: "R \"${pkgAppData}/${f}\" - - - - -") [
  ];
  pkg = pkgs.prismlauncher;
  pkg-wrapped = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.desktop ];
    app = {
      package = pkg;
      id = "org.prism.PrismLauncher";
    };
    fhsenv.opts = {
      unshareUser = true;
      unshareUts = true;
      unshareCgroup = true;
    };
    sockets = {
      x11 = false;
    };
    mounts = {
      read = [
        "$HOME/.config/MangoHud"
        "$HOME/.config/environment.d"
        "$HOME/.config/qt5ct"
        "$HOME/.config/qt6ct"
        "$HOME/.config/Kvantum"
      ];
    };
  };
in
{
  options.nixfiles.games.prism-launcher = {
    enable = mkEnableOption "Prism-Launcher";
    users = mkOption {
      type = types.listOf types.str;
      description = "User-profile list to include the package";
    };
    sandbox = mkEnableOption "BubbleWrap sandbox feature for this package";
  };

  config = mkMerge [
    ({
      nixfiles.games.prism-launcher.sandbox = mkDefault true;

      nixpkgs.overlays = [
        (final: prev: {
          prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs {
            version = "11.0.2-1";
            src = prev.fetchFromGitHub {
              owner = "Diegiwg";
              repo = "PrismLauncher-Cracked";
              tag = "11.0.2-1";
              hash = "sha256-YrqHeE9ZEnmxJiXE+IBAxbmNRFPE7mn9KbxZ3Mpu388=";
            };
          };
        })
      ];
    })
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        temurin-bin-21
      ];

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
