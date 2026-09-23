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
    colourful = {
      enable = mkEnableOption "colourful Fastfetch profiles";
      installPath = mkOption {
        type = types.str;
        default = "fastfetch/colourful";
        description = "Where to install the profiles under /etc";
      };
      enableWrapper = mkEnableOption "colourful Fastfetch wrapper";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ pkgs."${name}" ];
    }
    (mkIf cfg.colourful.enable {
      environment.systemPackages =
        [ ]
        ++ optional (cfg.colourful.enableWrapper) (
          pkgs.writeShellApplication {
            name = "${name}-colourful";
            runtimeInputs = [ pkgs.fastfetch ];
            text = ''
              preset=$(find "/etc/${cfg.colourful.installPath}" -type l | shuf | head -n1)

              fastfetch --config "$preset"
            '';
          }
        );
    })
  ]);
}
