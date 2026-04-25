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
  };

  config = mkIf cfg.enable {
    nixfiles.programs.sets.common.fs-specific.btrfs = mkDefault (
      config.nixfiles.hardware.rootfs == "btrfs"
    );

    environment.variables = {
      EDITOR = "hx";
    };

    systemd.tmpfiles.rules = [ "L+ %h/.config/helix/languages.toml - - - - ${./helix_languages.toml}" ];

    environment.systemPackages =
      with pkgs;
      [
        # base91 # Implementation of the base91 utility, providing efficient binary-to-text encoding with better space utilization than Base64
        ddcutil
        e2fsprogs # Tools for creating and checking ext2/ext3/ext4 filesystems
        helix # Post-modern modal text editor
        nixd # Nix language server
        nixfmt # Optional: formatter
        ncdu
        usbutils # Tools for working with USB devices, such as lsusb
        util-linux # Set of system utilities for Linux
        parallel
        psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
        pwgen # Password generator which creates passwords which can be easily memorized by a human
        stress-ng
      ]
      ++ optionals (cfg.fs-specific.btrfs) [
        btrfs-progs
        compsize
      ];

    programs.htop = {
      enable = true;
      settings = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
        show_cpu_frequency = 1;
        column_meters_0 = "AllCPUs4 CPU Blank System";
        column_meter_modes_0 = "1 1 2 2";
        column_meters_1 = "MemorySwap Blank GPU DiskIO NetworkIO Blank Uptime LoadAverage Tasks";
        column_meter_modes_1 = "1 2 1 2 2 2 2 2 2";
      };
    };
  };
}
