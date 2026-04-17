{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixfiles.system.shell;
  impermanent = config.nixfiles.impermanence.enable or false;
  shellPkgs = {
    zsh = pkgs.zsh;
  };
  persistData = {
    zsh = [ "/root/.config/zsh" ];
  };
in
{
  options.nixfiles.system.shell = {
    type = mkOption {
      type = types.enum [
        "none"
        "zsh"
      ];
      default = "zsh";
      description = "Whether to use customised shell variants";
    };
    makeDefault = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to make it default for all users";
    };
    console = {
      optimalSettings = mkEnableOption "optimal SystemD console settings";
    };
    zsh = {

    };
  };

  config = mkIf (cfg.type != "none") (mkMerge [
    {
      environment.shells = [ shellPkgs.${cfg.type} ];

      # Persist data
      nixfiles.impermanence.directories = mkIf (impermanent) (persistData.${cfg.type} or [ ]);
    }
    (mkIf cfg.makeDefault {
      users.defaultUserShell = shellPkgs.${cfg.type};
    })
    (mkIf cfg.console.optimalSettings {
      console = {
        # earlySetup = true;
        packages = with pkgs; [ terminus_font ];
        font = "ter-128b.psf.gz";
      };
    })
    (mkIf (cfg.type == "zsh") {
      environment.variables.ZDOTDIR = "$HOME/.config/zsh";
      systemd.user.tmpfiles.rules = [
        "d %h/.config/zsh 700 - - - -"
      ];
      environment.systemPackages = with pkgs; [
        zsh-powerlevel10k
      ];

      # Setup ZSH
      programs.zsh = {
        enable = true;
        enableBashCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          # List common aliases
          ll = "ls -l";
          # edit = "sudo -e"; # sudo-rs: not yet implemented
        };

        histFile = "$HOME/.config/zsh/history"; # History file path
        histSize = 10000;
      };
      programs.zsh.ohMyZsh = {
        # OhMyZsh setup
        enable = true;
        plugins = [
          "git" # also requires `programs.git.enable = true;`
        ];
        theme = "powerlevel10k";
        custom = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      };
    })
  ]);
}
