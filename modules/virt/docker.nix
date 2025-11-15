# Virtualisation - Docker


{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
  };

  # users.users.joe.extraGroups = [ "docker" ];

  # Persist data
  environment.impermanence.directories = [
    "/var/lib/docker"
  ];
}
