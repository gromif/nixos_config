# Home - Config - Autostart


{ config, ... }:

{
  imports = [
    ./nicotine.nix
    ./qbittorrent.nix
  ];
  
  xdg.autostart = {
    enable = true;
    readOnly = true; # Make a symlink to a readonly directory so programs cannot install arbitrary services.
  };
}
