# Home - Config - Autostart - Qbittorrent


{ lib, config, pkgs, ... }:

let
  autostartQbittorrent = pkgs.writeShellApplication {
  	  name = "autostart-qbittorrent";
  	  runtimeInputs = with pkgs; [
  	    util-linux
  	    qbittorrent
  	  ];
  	  text = ''
  	    sleep 10
  	    setsid -f qbittorrent
  	  '';
  	};
in
{
  # home.packages = [ autostartQbittorrent ];
  
  # xdg.autostart.entries = [
  #   (
  #     (pkgs.makeDesktopItem {
  #       name = "qBittorrent";
  #       destination = "/";
  #       desktopName = "qBittorrent";
  #       icon = "qbittorrent";
  #       startupNotify = false;
  #       startupWMClass = "qbittorrent";
  #       terminal = false;
  #       exec = "${lib.getExe autostartQbittorrent}";
  #       extraConfig = {
  #         X-GNOME-Autostart-Delay = "60";
  #       };
  #     }) + /qBittorrent.desktop
  #   )
  # ];
}
