# ZRAM

{ config, lib, ... }:
let
  cfg = config.nixfiles.system.zramSwap;
in
with lib; {
  options.nixfiles.system.zramSwap = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the custom ZramSwap configuration.";
    };
    kernelOptimisations = {
      type = types.bool;
      default = true;
      description = "Whether to use optimised kernel parameters.";
    };
  };
  
  config = mkIf cfg.enable {
    # Setup ZRAM.
    zramSwap = mkIf (config.nixfiles.system.type != "avf") {
      enable = true;
      algorithm = "zstd";
      memoryPercent = mkForce 50;
    };

    # Optimise ZRAM
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  }; 
}
