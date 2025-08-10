# User - Alex - Firejail - zstd


{ pkgs, lib, ... }:

let
  pkg = pkgs.zstd;
  isInstalled = builtins.hasAttr "zstd" pkgs;
in
{
  programs.firejail.wrappedBinaries = lib.mkIf isInstalled {
    zstd = {
      executable = "${pkg}/bin/zstd";
      profile = "${pkgs.firejail}/etc/firejail/zstd.profile";
      extraArgs = [
        "--net=none"
      ];
    };
  };
}
