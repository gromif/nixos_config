# Sandbox - tree


{ config, pkgs, lib, ... }:

with lib;

let
  pkg = pkgs.tree;
  pkg_name = "tree";
  isInstalled = builtins.hasAttr pkg_name pkgs;
  
  pkg-wrapper = pkgs.writeShellApplication {
    name = pkg_name;
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
      --chdir /sandbox -- ${pkg}/bin/tree "$@"
    '';
  };
in
{
  environment.systemPackages = mkIf (isInstalled) [ pkg-wrapper ];
}
