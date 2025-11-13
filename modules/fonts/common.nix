# Fonts - Common


{ config, pkgs, ... }:

{
	fonts.packages = with pkgs; [
		inter
		monocraft
		#inter-nerdfont
		nerd-fonts.fira-code
	];
}
