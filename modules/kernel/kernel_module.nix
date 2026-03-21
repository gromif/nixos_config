{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixfiles.boot.kernel;
  isAvf = config.nixfiles.system.type == "avf";
in
{
  options.nixfiles.boot.kernel = mkOption {
    type = types.enum [ "none" "lts" "latest" ];
  };

  config = mkMerge [
    {
      nixfiles.boot.kernel = if isAvf then mkDefault "none" else "lts";
    }
    
    (mkIf (cfg == "lts") {
      boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
    })

    (mkIf (cfg == "latest") {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    })
  ];
}
