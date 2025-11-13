# Desktop - Common


{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
    tela-icon-theme
  ];
}
