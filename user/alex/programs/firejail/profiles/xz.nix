# User - Alex - Firejail - xz


{ config, pkgs, lib, ... }:

let
  pkg = pkgs.xz;
  isInstalled = builtins.hasAttr "xz" pkgs;
in
{
  programs.firejail.wrappedBinaries = lib.mkIf isInstalled {
    xz = {
      executable = "${pkg}/bin/xz";
      profile = "${pkgs.firejail}/etc/firejail/xz.profile";
      extraArgs = [
        "--net=none"
      ];
    };
  };
}
