# Virtualisation - Docker


{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
  };

  # users.users.joe.extraGroups = [ "docker" ];
}
