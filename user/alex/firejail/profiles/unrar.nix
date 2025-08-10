# User - Alex - Firejail - unrar


{ pkgs, lib, ... }:

let
  pkg = pkgs.unrar;
  isInstalled = builtins.hasAttr "unrar" pkgs;
in
{
  programs.firejail.wrappedBinaries = lib.mkIf isInstalled {
    unrar = {
      executable = "${pkg}/bin/unrar";
      profile = "${pkgs.firejail}/etc/firejail/unrar.profile";
      extraArgs = [
        "--net=none"
      ];
    };
  };
}
