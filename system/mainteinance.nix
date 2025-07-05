# System - Mainteinance


{ config, inputs, ... }:

{
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
