{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixfiles.virtualisation;
  isImperm = config.nixfiles.impermanence.enable;
in
{
  options.nixfiles.virtualisation = {
    docker = {
      enable = mkEnableOption "Docker";
      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of users to include in the docker group";
      };
    };
    libvirtd = {
      enable = mkEnableOption "libvirtd";
      members = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Include in the libvirtd group";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.docker.enable) {
      virtualisation.docker = {
        enable = true;
      };

      users.users = builtins.listToAttrs (
        map (u: {
          name = u;
          value = {
            extraGroups = [ "docker" ];
          };
        }) cfg.docker.users
      );

      # Persist data
      nixfiles.impermanence.directories = mkIf (isImperm) [
        "/var/lib/docker"
      ];
    })
    (mkIf cfg.libvirtd.enable {
      # Virt Manager
      programs.virt-manager.enable = true;

      users.groups.libvirtd.members = cfg.libvirtd.members;

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
 
      # Other stuff
      environment.systemPackages = with pkgs; [
        virtiofsd
      ];

      # Persist data
      nixfiles.impermanence.directories = mkIf isImperm [
        "/var/lib/libvirt"
      ];
    })
  ];
}
