{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.games.prism-launcher;

  tmpFilesRules = map (f: "R \"%h/.local/share/PrismLauncher/${f}\" - - - - -") [
    "logs/*"
    "instances/*/minecraft/logs/*"
  ];
  pkg = pkgs.prismlauncher;
in
{
  options.nixfiles.games.prism-launcher = {
    enable = mkEnableOption "Prism-Launcher";
    users = mkOption {
      type = types.listOf types.str;
      description = "User-profile list to include the package";
    };
  };

  config = mkMerge [
    ({
      nixpkgs.overlays = [
        (final: prev: {
          prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs {
            version = "11.0.3";
            src = prev.fetchFromGitHub {
              owner = "Diegiwg";
              repo = "PrismLauncher-Cracked";
              tag = "11.0.3";
              hash = "sha256-pFIDOP03I76r14bXoKL7tEEaLlGFJ10MqMgGR4D/mvE=";
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
            packages = [ pkg ];
          };
        }) cfg.users
      );
    })
  ];
}
