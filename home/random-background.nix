# Home - Security

{ config, pkgs, ... }:

{
  services.random-background = {
    enable = true;
    imageDirectory = "~/Pictures/wallpapers";
    interval = "1h";
  };
}
