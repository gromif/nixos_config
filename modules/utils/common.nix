# Utils - Common


{ pkgs, ... }:

{
	environment.variables = {
		EDITOR = "hx";
	};
	environment.systemPackages = with pkgs; [
    # base91 # Implementation of the base91 utility, providing efficient binary-to-text encoding with better space utilization than Base64
    ddcutil
    helix # Post-modern modal text editor
    ncdu
    usbutils # Tools for working with USB devices, such as lsusb
    util-linux # Set of system utilities for Linux
    parallel
    psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
    pwgen # Password generator which creates passwords which can be easily memorized by a human
  ];
  
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
