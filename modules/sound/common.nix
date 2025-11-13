# Sound - Common


{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
    alsa-utils
  ];
}
