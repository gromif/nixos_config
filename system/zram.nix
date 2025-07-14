# ZRAM

{ config, ... }:

{
  # Setup ZRAM.
  zramSwap = {
  	enable = true;
  	algorithm = "zstd";
  	memoryPercent = 50;
  };
  
  # Optimise ZRAM
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
	"vm.watermark_scale_factor" = 125;
	"vm.page-cluster" = 0;
  };
  
}
