{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixfiles.programs.sets.common;
in
{
  options.nixfiles.programs.sets.common = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include common utils.";
    };
    fs-specific = {
      btrfs = mkEnableOption "btrfs common utils";
    };
    group = {
      basic = mkEnableOption "basic common packages";
      server = mkEnableOption "server common packages";
      desktop = mkEnableOption "desktop common packages";
    };
  };

  config = mkIf cfg.enable {
    nixfiles.programs.sets.common = {
      group = {
        basic = mkDefault true;
      };
      fs-specific.btrfs = mkDefault (config.nixfiles.hardware.rootfs == "btrfs");
    };

    environment.variables = {
      EDITOR = "hx";
    };

    systemd.tmpfiles.rules = [ "L+ %h/.config/helix/languages.toml - - - - ${./helix_languages.toml}" ];

    environment.systemPackages =
      with pkgs;
      [
        helix # Post-modern modal text editor
        nixd # Nix language server
        nixfmt # Optional: formatter
      ]
      ++ optionals (cfg.group.basic) [
        btop
        ncdu
        usbutils
        util-linux
        tree # Command to produce a depth indented directory listing
        parallel
        psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
      ]
      ++ optionals (cfg.group.server) [ ]
      ++ optionals (cfg.group.desktop) [
        ddcutil
        pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
        pwgen # Password generator which creates passwords which can be easily memorized by a human
        stress-ng
      ]
      ++ optionals (cfg.fs-specific.btrfs) [
        btrfs-progs
        compsize
        duperemove
      ];

    # Shut Parallel down
    environment.etc."parallel/will-cite".text = "";
  };
}
