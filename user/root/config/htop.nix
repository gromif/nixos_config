# User - Root - Config - Htop


{ ... }:

{
  programs.htop = {
		enable = true;
		settings = {
			hide_kernel_threads = true;
			hide_userland_threads = true;
      show_cpu_frequency = 1;
      column_meters_0 = "AllCPUs4 CPU Blank System";
      column_meter_modes_0 = "1 1 2 2";
      column_meters_1 = "MemorySwap Blank GPU DiskIO NetworkIO Blank Uptime LoadAverage Tasks";
      column_meter_modes_1 = "1 2 1 2 2 2 2 2 2";
		};
  };
}
