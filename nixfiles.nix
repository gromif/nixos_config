{ config, lib, ... }:

with lib;

let
  cfg = config.nixfiles;
  lsr = lib.filesystem.listFilesRecursive;
  modules = builtins.filter (f: lib.hasSuffix "_module.nix" f) (
    (lsr ./modules) ++ (lsr ./secrets) ++ (lsr ./users)
  );
  aliases = [
    (lib.mkAliasOptionModule [ "nixfiles" "system" "stateVersion" ] [ "system" "stateVersion" ])
  ];
in
{
  imports = modules ++ aliases;

  options.nixfiles = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the Nixfiles custom configuration.";
    };
    system = {
      home-manager = mkEnableOption "Home-Manager support";
      type = mkOption {
        type = types.enum [
          "linux"
          "avf"
        ];
        default = "linux";
        description = ''
          Target system type.
          Should be one of these: [ linux, avf ]
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.system.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ ./hmfiles.nix ];
      };
    })
  ];
}
