# Home - Services


{ config, pkgs, ... }:

{
  imports = [
		./cleanup.nix
		./random-background.nix
		./screenshot-optimiser.nix
		./theme-changer.nix
  ];
  
  
}
