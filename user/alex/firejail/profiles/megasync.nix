# User - Alex - Firejail - megasync


{ config, pkgs, lib, ... }:

let
  pkg = pkgs.megasync;
  isInstalled = builtins.hasAttr "megasync" pkgs;
  home = "${config.users.users.alex.home}/.local/share/firejail/MegaSync";
in
{
  programs.firejail.wrappedBinaries = lib.mkIf isInstalled {
    megasync = {
      executable = "${lib.getExe pkgs.megasync}";
      extraArgs = [
        "--name=MegaSync"
        "--hostname=mega"
        "--disable-mnt"
        "--mkdir=${home}"
        "--private=${home}"
        "--private-cache"
        
        "--keep-config-pulse"
      ];
    };
  };
}
