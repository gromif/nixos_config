{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  name = "fastfetch";
  cfg = config.nixfiles.programs.fastfetch;
in
{
  options.nixfiles.programs."${name}" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the ${name} package";
    };
    preset = mkOption {
      type = types.str;
      default = "none";
      description = "Which preset to load";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ pkgs."${name}" ];
    }

    (mkIf (cfg.preset == "nixos_1") {
      environment.etc = {
        "fastfetch/config.jsonc".source = ./nixos_1/config.jsonc;
        "fastfetch/logo.txt".source = ./nixos_1/logo.txt;
      };
    })

    (mkIf (cfg.preset == "nixos_2") {
      environment.etc = {
        "fastfetch/config.jsonc".source = ./nixos_2/config.jsonc;
        "fastfetch/logo.txt".source = ./nixos_2/logo.txt;
      };
    })
  ]);
}
