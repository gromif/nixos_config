# Hosts - Polaris


{ config, lib, pkgs, ... }:

{
  environment.packages = with pkgs; [
    dwarfs
    git
    nano
    yt-dlp
    wol
    zsh
  ];

  android-integration = {
    termux-setup-storage.enable = true;
  };

  user = {
    shell = "${lib.getExe pkgs.zsh}";
  };

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

  # Backup etc flakes instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";
  
  # Common preferences
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.stateVersion = "24.05";
  # time.timeZone = preferences.time.timeZone;
  # networking.hostName = preferences.hostName;
}
