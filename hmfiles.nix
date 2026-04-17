{ config, lib, ... }:

let
  modules = builtins.filter (f: lib.hasSuffix ".nix" f) (
    (lib.filesystem.listFilesRecursive ./modules_hm)
  );
  aliases = [
    # (lib.mkAliasOptionModule [ "nixfiles" "system" "stateVersion" ] [ "system" "stateVersion" ])
  ];
in
with lib;
{
  imports = modules ++ aliases;

  options.hmfiles = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the HM-files custom configuration.";
    };
  };

  config = mkIf config.hmfiles.enable {
    home = {
      homeDirectory = "/home/${config.home.username}";
      stateVersion = "26.05";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    xdg = {
      autostart = {
        enable = true;
        readOnly = true; # Make a symlink to a readonly directory so programs cannot install arbitrary services.
      };
      userDirs = {
        enable = mkForce true;
        createDirectories = mkForce true;
      };
      configFile."user-dirs.dirs".force = mkForce true;
    };
  };
}
