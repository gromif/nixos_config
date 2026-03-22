# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ preferences, config, lib, pkgs, ... }:

{
  imports = [
    # include nixos-avf modules
    # <nixos-avf/avf>
  ];
  nixfiles = {
    system = {
      type = "avf";
      stateVersion = "25.11";
    };
    network = {
      hostName = builtins.baseNameOf ./.;
    };
  };
  
  users.users.root.password = "1111";
  users.users.droid = {
    createHome = true;
  };
  # Change default user
  # avf.defaultUser = "droid";

  environment.systemPackages = with pkgs; [
    helix
    yt-dlp
  ];

  nixfiles.impermanence.enable = lib.mkForce false;
}
