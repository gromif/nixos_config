{ config, pkgs, ... }:

let
  path = ../modules/hm/config/pipewire/default;
in
{
  xdg.configFile = {
    "pipewire/pipewire.conf" = {
      force = true;
      source = path + "/pipewire.conf";
    };
    "pipewire/hrtf.wav" = {
      force = true;
      source = path + "/hrtf.wav";
    };
    "pipewire/minimal.conf" = {
      force = true;
      source = path + "/minimal.conf";
    };
  };
}
