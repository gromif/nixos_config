# Home - Config


{ config, pkgs, ... }:

let
  autostartsList = builtins.attrNames (builtins.readDir ./autostart);
  autostarts = builtins.map (c:
    ./autostart + "/${c}"
  ) autostartsList;
in
{
  imports = autostarts ++ [
    ./git
  ];
  
  xdg.autostart = {
    enable = true;
    readOnly = true; # Make a symlink to a readonly directory so programs cannot install arbitrary services.
  };
  
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
