{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  _presetName = "shared";
  _nixfiles = config.nixfiles;
  _cfg = _nixfiles.preset.${_presetName};
  _root-fs = _nixfiles.hardware.rootfs;
  _helixSettings = [
    "L+ %h/.config/helix/config.toml - - - - ${./helix/config.toml}"
    "L+ %h/.config/helix/languages.toml - - - - ${./helix/languages.toml}"
  ];
in
{
  options.nixfiles.preset.${_presetName} = {
    enable = mkEnableOption "'${_presetName}' preset";
    fs-utils = {
      btrfs = mkEnableOption "BTRFS utils";
    };
  };

  config = mkMerge [
    {
      nixfiles.preset.${_presetName} = {
        fs-utils = {
          btrfs = _root-fs == "btrfs";
        };
      };
    }

    (mkIf _cfg.enable {
      systemd = {
        tmpfiles.rules = [
          "f /tmp/parallel/will-cite 755" # Shut Parallel
        ]
        ++ _helixSettings;
        user.tmpfiles.rules = _helixSettings;
      };
      environment = {
        variables = {
          EDITOR = "hx";
          PARALLEL_HOME = "/tmp/parallel";
        };
        systemPackages =
          with pkgs;
          [
            kitty.terminfo
            helix # Post-modern modal text editor
            nixd # Nix language server
            nixfmt # Optional: formatter

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
          ++ optionals (_cfg.fs-utils.btrfs) [
            btrfs-progs
            compsize
            duperemove
          ];
      };
      programs.firefox.policies = {
        # Disable WebRTC globally
        MediaPeerConnection = {
          enabled = false;
        };
      };
    })
  ];
}
