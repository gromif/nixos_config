# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./hardware-configuration.nix
    ./sops.nix
    ./security
    ./system
    ./user
  ];

  nixpkgs.config.allowUnfree = true;
  
  nix = {
    channel.enable = false; # Disable usage of nix channels
    settings = {
      # Enable the Flakes feature and the accompanying new nix command-line tool
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      download-buffer-size = 1073741824;
      build-dir = "/nix/build";
    };
  };
  system.stateVersion = "25.11";
}
