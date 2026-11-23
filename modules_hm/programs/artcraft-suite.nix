{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  _name = "artcraft-suite";
  _cfg = config.hmfiles.programs.${_name};
in
{
  options.hmfiles.programs.${_name} = {
    enable = mkEnableOption "${_name}";
  };

  config = mkIf _cfg.enable {
    home.packages = with pkgs; [
      photocraft
      vectorcraft
      lightcraft
      filmcraft
      pdfcraft
      wordcraft
      deckcraft
      gridcraft
    ];
  };
}
