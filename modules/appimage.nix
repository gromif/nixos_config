# AppImage Support


{ config, pkgs, ... }:

{
	# Enable AppImage Support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
}
