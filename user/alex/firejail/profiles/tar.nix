# User - Alex - Firejail - tar


{ pkgs, lib, ... }:

let
  pkg = pkgs.tar;
  isInstalled = builtins.hasAttr "tar" pkgs;
in
{
  programs.firejail.wrappedBinaries = lib.mkIf isInstalled {
    tar = {
      executable = "${pkg}/bin/tar";
      profile = "${pkgs.firejail}/etc/firejail/tar.profile";
      extraArgs = [
        "--net=none"
      ];
    };
  };
}
