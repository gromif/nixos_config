{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixfiles.preset;

  normalUsers = lists.remove "root" config.nixfiles.users;
in
{
  config = mkIf (cfg == "desktop") {
    environment.systemPackages =
      with pkgs;
      [
        ddcutil
        pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
        poppler-utils # PDF rendering library
        pwgen # Password generator which creates passwords which can be easily memorized by a human
        stress-ng
        wineWow64Packages.waylandFull
      ]
      # SOUND
      ++ [ alsa-utils ];
    nixfiles = {
      system = {
        shell.console.optimalSettings = true;
      };
      boot.kernelModules.v4l2loopback.enable = true;
      sound.backend = "pipewire";
      hardware = {
        ddc = {
          enable = true;
          allowedUsers = normalUsers;
        };
      };
      de = {
        enable = true;
        gnome = {
          enable = true;
          services = {
            theme-changer.enable = true;
          };
        };
      };
      virtualisation = {
        libvirtd = {
          enable = true;
        };
        podman.enable = true;
        distrobox.enable = true;
      };
      gaming = {
        enable = true;
        enableLSFG = true;
      };
      programs = {
        appimage.enable = true;
        direnv.enable = true;
        fastfetch = {
          enable = true;
          preset = "nixos_1";
        };
        sets = {
          common.group.desktop = true;
          media.enable = true;
        };
      };
    };
    programs.firefox.enable = true;
  };
}
