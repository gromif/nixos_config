# System - Mainteinance


{ ... }:

{
  services.fstrim.enable = true; # Enable FSTrim (weekly)
  
  # Garbage Collector
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };
  
  # Optimiser
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "11:00" ];
}
