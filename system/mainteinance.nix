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
  
  system.autoUpgrade = {
    enable = true;
    flake = "github.com:gromif/nixos_config";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "10:00";
    randomizedDelaySec = "30min";
  };
}
