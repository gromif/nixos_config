# Sandbox - gnutar


{ config, pkgs, lib, ... }:

with lib;

let
  pkg_name = "gnutar";
  pkg = pkgs."${pkg_name}";
  isInstalled = builtins.hasAttr pkg_name pkgs;
  
  pkg-wrapper = pkgs.writeShellApplication {
    name = "tar";
    runtimeInputs = [ pkg ];
    text = ''
      bwrap \
      --unshare-ipc --unshare-pid --unshare-net --unshare-uts --unshare-cgroup-try \
      --ro-bind /nix/store /nix/store \
      --die-with-parent \
      --new-session \
      --proc /proc \
      --tmpfs /tmp \
      --hostname "${pkg_name}" \
      --bind "$(pwd)" /sandbox \
      --chdir /sandbox -- ${pkg}/bin/tar "$@"
    '';
  };
in
{
  environment.systemPackages = mkIf (isInstalled) [ pkg-wrapper ];
}
