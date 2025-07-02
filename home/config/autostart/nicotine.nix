# Home - Config - Autostart - Nicotine+


{ lib, config, pkgs, ... }:

let
  autostartNicotine = pkgs.writeShellApplication {
  	  name = "autostart-nicotine";
  	  runtimeInputs = with pkgs; [
  	    util-linux
  	    nicotine-plus
  	  ];
  	  text = ''
  	    sleep 10
  	    nicotine
  	  '';
  	};
in
{
  home.packages = [ autostartNicotine ];
  
  xdg.autostart.entries = [
    (
      (pkgs.makeDesktopItem {
        name = "Nicotine";
        destination = "/";
        desktopName = "Nicotine+";
        icon = "org.nicotine_plus.Nicotine";
        startupNotify = true;
        terminal = false;
        exec = "${lib.getExe autostartNicotine}";
        extraConfig = {
          X-GNOME-SingleWindow = "true";
          X-GNOME-UsesNotifications = "true";
        };
      }) + /Nicotine.desktop
    )
  ];
}
