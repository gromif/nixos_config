{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

# Direnv is an automatic environment setup utility,
# loading the specified project environment automatically
# when you enter your project directory, and reporting
# the loaded variables to you.

let
  cfg = config.nixfiles.programs.direnv;
  shellType = config.nixfiles.system.shell.type;
in
{
  options.nixfiles.programs.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = shellType == "bash";
        enableFishIntegration = shellType == "fish";
        enableXonshIntegration = shellType == "xonsh";
        enableZshIntegration = shellType == "zsh";
      };
    }

    {
      environment.systemPackages =
        let
          pkgSetup = pkgs.writeShellApplication {
            name = "direnv-setup";
            text = ''
              echo "use flake" | tee "$(pwd)/.envrc" 1> /dev/null
            '';
          };
        in
        [ pkgSetup ];
    }
  ]);
}
