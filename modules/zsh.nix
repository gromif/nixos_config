# ZSH


{ config, lib, pkgs, ... }:

with lib;

let
  impermanent = config.environment.impermanence.enable or false;
in
{
	users.defaultUserShell = pkgs.zsh;
	environment.shells = with pkgs; [ zsh ];
	environment.variables.ZDOTDIR = "$HOME/.config/zsh";
	
	# Setup ZSH
	programs.zsh = {
	  enable = true;
	  enableBashCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = { # List common aliases
        ll = "ls -l";
        # edit = "sudo -e"; # sudo-rs: not yet implemented
      };
    
      histFile = "$HOME/.config/zsh/history"; # History file path
	  histSize = 10000;
	};
	
	programs.zsh.ohMyZsh = { # OhMyZsh setup
		enable = true;
    plugins = [
      "git"         # also requires `programs.git.enable = true;`
    ];
    theme = "robbyrussell"; # preferred shell theme
	};

	# Persist data
	config = mkIf (impermanent) {
      environment.impermanence.directories = [
		"/root/.config/zsh"
	  ];
    };
}
