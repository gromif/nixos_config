{ config, preferences, ... }:

{
  home = {
    homeDirectory = "/home/${config.home.username}";
    stateVersion = preferences.system.home.stateVersion;
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.autostart = {
    enable = true;
    readOnly = true; # Make a symlink to a readonly directory so programs cannot install arbitrary services.
  };
}
