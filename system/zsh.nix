# ZSH


{ config, pkgs, ... }:

{
	users.defaultUserShell = pkgs.zsh;
	environment.shells = with pkgs; [ zsh ];
	
	# Setup ZSH
	programs.zsh = {
		enable = true;
		enableBashCompletion = true;
		autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = { # List common aliases
      ll = "ls -l";
      # edit = "sudo -e"; # sudo-rs: not yet implemented
      nix-apply = "sudo nixos-rebuild switch";
      nix-upgrade = "sudo nixos-rebuild boot --upgrade";
      nix-dry = "sudo nixos-rebuild dryrun";
      nix-test = "sudo nixos-rebuild test";
      nix-void = "sudo nix-collect-garbage -d";
    };
    
		histFile = "$HOME/.zsh_history"; # History file path
	};
	
	programs.zsh.ohMyZsh = { # OhMyZsh setup
		enable = true;
    plugins = [
      "git"         # also requires `programs.git.enable = true;`
      "thefuck"     # also requires `programs.thefuck.enable = true;` 
    ];
    theme = "robbyrussell"; # preferred shell theme
	};
}
