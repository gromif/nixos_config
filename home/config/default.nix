# Home


{ config, pkgs, ... }:

{
  imports = [
    ./autostart
    ./git
    ./qt
  ];
  
  # PipeWire
  home.file = {
    ".config/pipewire/pipewire.conf" = {
      force = true;
      source = ../config/pipewire/pipewire.conf;
    };
    ".config/pipewire/hrtf.wav" = {
      force = true;
      source = ../config/pipewire/hrtf.wav;
    };
    ".config/pipewire/minimal.conf" = {
      force = true;
      source = ../config/pipewire/minimal.conf;
    };
  };
  
  # Fastfetch
  home.file = {
    ".config/fastfetch/config.jsonc" = {
      force = true;
      source = ../config/fastfetch/config.jsonc;
    };
  };
  
  # MangoHud
  home.file = {
    ".config/MangoHud/MangoHud.conf" = {
      force = true;
      source = ../config/MangoHud/MangoHud.conf;
    };
    ".config/MangoHud/custom.conf" = {
      force = true;
      source = ../config/MangoHud/MangoHud.conf;
    };
  };
  
}
