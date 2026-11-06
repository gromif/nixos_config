{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  _presetName = "desktop";
  _nixfiles = config.nixfiles;
  _cfg = _nixfiles.preset.${_presetName};
  _normalUsers = filter (item: !strings.hasSuffix "root" item) config.nixfiles.users;
  _pkgs-sound = with pkgs; [
    alsa-utils
  ];
  _pkgs-compression = with pkgs; [
    dwarfs
    p7zip
    unrar
    unzip
  ];
in
{
  options.nixfiles.preset.${_presetName} = {
    enable = mkEnableOption "'${_presetName}' preset";
  };

  config = mkIf _cfg.enable {
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
      ++ _pkgs-sound
      ++ _pkgs-compression;
    nixfiles = {
      system = {
        shell.console.optimalSettings = true;
      };
      boot = {
        # kernelModules.v4l2loopback.enable = true;
        plymouth.enable = false;
      };
      network.networkmanager.useSecureDNS = true;
      sound.backend = "pipewire";
      hardware = {
        ddc = {
          enable = true;
          allowedUsers = _normalUsers;
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
        hypervisor = {
          enable = true;
          type = "runtime-parameter";
        };
      };
      programs = {
        appimage.enable = true;
        direnv.enable = true;
        fastfetch = {
          enable = true;
          colourful = {
            enable = true;
            enableWrapper = true;
          };
        };
        sets = {
          media.enable = true;
        };
      };
    };
    programs.firefox.enable = true;
  };
}
