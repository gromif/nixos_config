{ config, lib, ... }:

with lib;

let
  _name = "nullfsvfs";
in
{
  options.nixfiles.boot.kernelModules.${_name} = {
    enable = mkEnableOption "${_name} module";
  };

  config = mkIf config.nixfiles.boot.kernelModules.${_name}.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.${_name} ];
    boot.kernelModules = [ _name ];
    # boot.extraModprobeConfig = "";
    fileSystems."/mnt/nullfs" = {
      device = "none";
      fsType = "nullfsvfs";
    };
  };
}
