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
    (mkIf cfg.colourful.enable (
      let
        themes = attrNames (readDir ./themes);
        outputDir = cfg.colourful.installPath;
        config_modules = readFile ./config_modules.jsonc;
      in
      {
        environment.etc = listToAttrs (
          map (theme: {
            name = "${outputDir}/${theme}.jsonc";
            value.text = ''
              {
                  "logo": {
                      "type": "kitty-direct",
                      "source": "${./themes/${theme}/.logo.png}",
                      "padding": {
                          "top": 1,
                          "left": 2
                      },
                      "height": 13,
                      "width": 32
                  },
                  "display": {
                      "separator": " ",
                      "constants": [
                          ${readFile ./themes/${theme}/constants.jsonc}
                          "┌──────",   // {$11},
                          "───────",   // {$12},
                          "────────┐",   // {$13},
                       ],
                      "percent": {
                          "type": 9,         // 1=number, 2=bar, 3=both, 9=colored number
                          "color": {
                              ${readFile ./themes/${theme}/percent_colors.jsonc}
                          }
                      }
                  },
                  "modules": [
                      ${config_modules}
                  ]
              }
            '';
          }) themes
        );
      }
    ))
  ]);
}
