{ config, lib, preferences, ... }:

let
  cfg = config.nixfiles.system.nix;
  isAvf = config.nixfiles.system.type == "avf";
in with lib;
{
  imports = [
    (mkAliasOptionModule [ "nixfiles" "system" "nix" "allowUnfree" ] [ "nixpkgs" "config" "allowUnfree"])
  ];
  
  options.nixfiles.system.nix = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable sane defaults for Nix.";
    };
    enableGC = mkOption {
      type = types.bool;
      description = "Whether to enable the GC service for Nix.";
    };
    enableOptimise = mkOption {
      type = types.bool;
      description = "Whether to optimise the Nix store automatically.";
    };
    buildDir = mkOption {
      type = types.path;
      default = "/nix/build";
      description = "Absolute path to the Nix build directory.";
    };
  };

  config = mkIf cfg.enable {
    nixfiles.system.nix = {
      allowUnfree = mkDefault true;
      enableGC = mkDefault (!isAvf);
      enableOptimise = mkDefault (!isAvf);
    };
    nix = {
      channel.enable = mkForce false; # Disable usage of nix channels
      settings = {
        # Enable the Flakes feature and the accompanying new nix command-line tool
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        download-buffer-size = 1073741824;
        build-dir = cfg.buildDir;
      };
      gc = mkIf cfg.enableGC {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };
      optimise = mkIf cfg.enableOptimise {
        automatic = true;
        dates = [ "11:00" ];
      };
    };

    # Automatically create & clean the build dir
    systemd.tmpfiles.rules = [
      "d ${cfg.buildDir} 0750 root root 7d -"
      "R /nix/var/nix/profiles/per-user - - - - -"
    ];
  
    users.mutableUsers = false; # the contents of the user and group files will be replaced on system activation
  };
}
