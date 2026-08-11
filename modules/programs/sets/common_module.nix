{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixfiles.programs.sets.common;

  pkgs_sound = with pkgs; [
    alsa-utils
  ];

  pkgs_compression = with pkgs; [
    dwarfs
    p7zip
    unrar
    unzip
  ];
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

    systemd.tmpfiles.rules = [
      "L+ %h/.config/helix/config.toml - - - - ${./helix/config.toml}"
      "L+ %h/.config/helix/languages.toml - - - - ${./helix/languages.toml}"
      "f /tmp/parallel/will-cite 755" # Shut Parallel
    ];

    environment.systemPackages =
      with pkgs;
      [
        helix # Post-modern modal text editor
        nixd # Nix language server
        nixfmt # Optional: formatter
      ]
      ++ optionals (cfg.group.basic) [
        binutils # Tools for manipulating binaries (linker, assembler, etc.)
        btop
        dmidecode # Tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
        file
        ncdu
        usbutils
        util-linux
        tree # Command to produce a depth indented directory listing
        rsync # Fast incremental file transfer utility
        parallel
        psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
        smartmontools # Tools for monitoring the health of hard drives
      ]
      ++ optionals (cfg.group.server) [
        memtester # Userspace utility for testing the memory subsystem for faults
        mtr # Network diagnostics tool
        speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
      ]
      ++ optionals (cfg.group.desktop) (
        [
          ddcutil
          pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
          pwgen # Password generator which creates passwords which can be easily memorized by a human
          stress-ng
          wineWow64Packages.waylandFull
        ]
        ++ pkgs_sound
        ++ pkgs_compression
      )
      ++ optionals (cfg.fs-specific.btrfs) [
        btrfs-progs
        compsize
        duperemove
      ];

    environment.variables.PARALLEL_HOME = "/tmp/parallel";
  };
}
