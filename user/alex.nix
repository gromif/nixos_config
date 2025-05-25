# User - Alex


{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
			android-studio
      alsa-utils
      distrobox
      dconf-editor
      fastfetch
      ffmpeg
      gimp3
      grsync
      inkscape
      lact
      mission-center
      mpv
      openrgb-with-all-plugins
      smplayer
      nicotine-plus
      qbittorrent
	  		tldr
    ];
  };
  
  programs.git.enable = true; # Install git.
  programs.thefuck.enable = true; # Install thefuck (correction tool).
  programs.firefox.enable = true; # Install firefox.
  programs.steam.enable = true; # Install steam.
  programs.htop = { # Setup htop.
		enable = true;
		settings = {
			hide_kernel_threads = true;
			hide_userland_threads = true;
		};
  };
  
  # Set up OpenRGB udev rules
  services.udev.packages = [ pkgs.openrgb-with-all-plugins ];
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  systemd.user.services.openrgb-boot = {
    path = [ pkgs.openrgb-with-all-plugins ];
    script = "openrgb --profile Ruby";
    wantedBy = [ "default.target" "reboot.target" ];
  };
  
  # Waydroid
  virtualisation.waydroid.enable = true;
  
  systemd.packages = with pkgs; [ lact ];
	systemd.services.lactd.wantedBy = ["multi-user.target"];
  
}
