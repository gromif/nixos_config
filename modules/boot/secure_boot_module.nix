{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  _cfg = config.nixfiles.boot.lanzaboote;
  aliasesSource = [
    "boot"
    "lanzaboote"
  ];
  aliasesTarget = [ "nixfiles" ] ++ aliasesSource;
  aliases = map (
    option: mkAliasOptionModule (aliasesTarget ++ [ option ]) (aliasesSource ++ [ option ])
  ) [ "settings" ];
in
{
  imports = aliases;

  options.nixfiles.boot.lanzaboote = {
    enable = mkEnableOption "Lanzaboote";
  };

  config = mkIf _cfg.enable (mkMerge [
    (mkIf _cfg.enable {
      users.users.root.packages = with pkgs; [ sbctl ];
      boot = {
        loader.systemd-boot.enable = mkForce false;
        lanzaboote = optionalAttrs _cfg.enable {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    })
  ]);
}
