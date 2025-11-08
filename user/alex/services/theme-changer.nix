# Global Theme Changer

{ config, pkgs, lib, ... }:

let
  themeChanger = pkgs.writeShellApplication {
  	  name = "theme-changer";
  	  runtimeInputs = with pkgs; [
  	    glib
  	    psmisc
    	  kdePackages.qtstyleplugin-kvantum
    	  qbittorrent
    	  util-linux
  	  ];
  	  text = ''
  	    case $1 in
        light)
          kvantummanager --set KvLibadwaita
          #sudo kvantummanager --set KvLibadwaita
          gsettings set org.gnome.desktop.interface color-scheme 'default'
          ;;
        dark)
          kvantummanager --set KvLibadwaitaDark
          #sudo kvantummanager --set KvLibadwaitaDark
          gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
          ;;
      esac

      killall -qwr qbittorrent && setsid -f qbittorrent
  	  '';
  	};
in
{
  # Install `theme-changer` binary
  environment.systemPackages = [ themeChanger ];
  	
  	# Set up automatic theme changer
  	systemd.user.services."theme-changer@" = {
  	  description = "Change System Theme";
  	  serviceConfig = {
  	    ExecStartPre = "${pkgs.coreutils}/bin/sleep 10s";
      ExecStart = "${lib.getExe themeChanger} %i";
      KillMode = "process";
  	  };
  	};
  
  	# Set up automatic [dark] theme changer timer
  systemd.user.timers."theme-changer-dark" = {
    description = "Dark theme change";
    timerConfig = {
      OnCalendar = "16:00";
      Unit = "theme-changer@dark.service";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };
  
  	# Set up automatic [light] theme changer timer
  systemd.user.timers."theme-changer-light" = {
    description = "Light theme change";
    timerConfig = {
      OnCalendar = "08:00";
      Unit = "theme-changer@light.service";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };
  
}
