# Home


{ config, pkgs, ... }:

{
  imports = [
    ./autostart
    ./git
    ./OpenRGB
    ./qt
  ];
  
  # PipeWire
  xdg.configFile = {
    "pipewire/pipewire.conf" = {
      force = true;
      source = ../config/pipewire/pipewire.conf;
    };
    "pipewire/hrtf.wav" = {
      force = true;
      source = ../config/pipewire/hrtf.wav;
    };
    "pipewire/minimal.conf" = {
      force = true;
      source = ../config/pipewire/minimal.conf;
    };
  };
  
  # Fastfetch
  xdg.configFile = {
    "fastfetch/config.jsonc" = {
      force = true;
      source = ../config/fastfetch/config.jsonc;
    };
  };
}
