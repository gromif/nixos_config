{ config, lib, ... }:

let
  modules =
    builtins.filter
      (f: lib.hasSuffix "_module.nix" f)
      (lib.filesystem.listFilesRecursive ./modules);
in with lib; {
  imports = modules;
  
  options.nixfiles = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the Nixfiles custom configuration.";
    };
    system.type = mkOption {
      type = types.enum [ "linux" "avf" ];
      default = "linux";
      description = ''
        Target system type.
        Should be one of these: [ linux, avf ]
      '';
    };
  };

  config = mkIf config.nixfiles.enable {
    
  };
}
