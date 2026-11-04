{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./crypttab.nix
  ];

  time.timeZone = "Europe/Berlin";
  nixfiles = {
    preset = {
      shared.enable = true;
      desktop.enable = true;
    };
    system = {
      home-manager = true;
      stateVersion = "25.11";
    };
    network.hostName = baseNameOf ./.;
    hardware = {
      graphics = {
        vendor = "amd";
        # lact.profile = "MANAGED";
      };
    };
    users = [
      "saturn-root"
      "saturn-nicklor"
    ];
    virtualisation.libvirtd.members = [ "nicklor" ];
  };

  xdg.mime.predefined.enable = true;
}
