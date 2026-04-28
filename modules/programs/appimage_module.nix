# AppImage Support

{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.programs.appimage;
in
{
  options.nixfiles.programs.appimage = {
    enable = mkEnableOption "AppImage support";
  };

  config = mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.icu
          pkgs.libxcrypt-legacy
          pkgs.python312
          pkgs.python312Packages.torch
        ];
      };
    };
  };
}
