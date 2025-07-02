# Global Theme Changer

{ config, pkgs, ... }:

let
  themeChanger = pkgs.writeShellApplication {
  	  name = "theme-changer";
  	  runtimeInputs = with pkgs; [
  	    psmisc
    	  kdePackages.qtstyleplugin-kvantum
    	  openrgb-with-all-plugins
    	  qbittorrent
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

      killall -qwr openrgb && setsid -f openrgb --startminimized
      killall -qwr qbittorrent && setsid -f qbittorrent
  	  '';
  	};
in
{
  # Install `theme-changer` binary
  home.packages = [ themeChanger ];
  	
  	# Set up automatic theme changer
  	systemd.user.services."theme-changer@" = {
  	  Unit.Description = "Change System Theme";
  	  Service = {
  	    ExecStartPre = "${pkgs.coreutils}/bin/sleep 10s";
      ExecStart = "${themeChanger}/bin/theme-changer %i";
      KillMode = "process";
  	  };
  	};
  
  	# Set up automatic [dark] theme changer timer
  systemd.user.timers."theme-changer-dark" = {
    Unit.Description = "Dark theme change";
    Timer = {
      OnCalendar = "20:00";
      Unit = "theme-changer@dark.service";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
  
  	# Set up automatic [light] theme changer timer
  systemd.user.timers."theme-changer-light" = {
    Unit.Description = "Light theme change";
    Timer = {
      OnCalendar = "07:00";
      Unit = "theme-changer@light.service";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
  
}
