# Home


{ config, pkgs, ... }:

{
  imports = [];
  
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
