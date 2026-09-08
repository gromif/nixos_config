# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # include nixos-avf modules
    # <nixos-avf/avf>
  ];

  time.timeZone = "Europe/Berlin";

  nixfiles = {
    system = {
      type = "avf";
      stateVersion = "25.11";
    };
    security = {
      enableCommon = false;
      elevation = "sudo-rs";
    };
    network = {
      hostName = baseNameOf ./.;
    };
    hardware = {
      enableCommon = false;
    };
    users = with config.nixfiles.user; [
      avf_droid.id
    ];
  };

  users.users.root.password = "1111";

  nixfiles.impermanence.enable = lib.mkForce false;
}
