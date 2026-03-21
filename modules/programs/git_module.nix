{ config, lib, ... }:

with lib;

let
  cfg = config.nixfiles.programs.git;
  fromAlias = [ "programs" "git" ];
  toAlias = [ "nixfiles" "programs" "git" ];
  aliases = map (option:
    lib.mkAliasOptionModule (toAlias ++ [ option ]) (fromAlias ++ [ option ])
  ) [ "config" ];
in
{
  imports = aliases;

  options.nixfiles.programs.git = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      config = {
        user = {
          email = mkDefault "alexander.kobrys@proton.me";
          name = mkDefault "gromif";
        };
        submodule = {
          recurse = mkDefault true;
        };
      };
    };
  };
}
