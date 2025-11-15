# Virtualisation - Docker


{ preferences, pkgs, ... }:

let
  members = builtins.listToAttrs (
    map (u: {
      name = u;
      value = {
        extraGroups = [ "docker" ];
      };
    }) preferences.virtualisation.docker.members
  );
in
{
  virtualisation.docker = {
    enable = true;
  };

  users.users = members;

  # Persist data
  environment.impermanence.directories = [
    "/var/lib/docker"
  ];
}
