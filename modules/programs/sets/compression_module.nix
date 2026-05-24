{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixfiles.programs.sets.compression;
in
{
  options.nixfiles.programs.sets.compression = {
    enable = mkEnableOption "compression utils";
  };

  config = mkMerge [
    {
      nixfiles.programs.sets.compression.enable = true;
    }
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        dwarfs
        p7zip
        unrar
        unzip
      ];
    })
  ];
}
