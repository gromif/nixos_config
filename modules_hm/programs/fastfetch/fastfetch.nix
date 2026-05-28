{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  name = "fastfetch";
  cfg = config.hmfiles.programs."${name}";
in
{
  options.hmfiles.programs."${name}" = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the ${name} package";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs."${name}" ];
    xdg.configFile."fastfetch/config.jsonc" = {
      source = ./config.jsonc;
      force = true;
    };
  };
}
