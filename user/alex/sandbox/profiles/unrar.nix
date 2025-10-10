# Sandbox - unrar


{ config, pkgs, lib, ... }:

let
  pkg = pkgs.unrar;
  pkg_name = "unrar";
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
      --chdir /sandbox -- ${pkg}/bin/unrar "$@"
    '';
  };
in
{
  environment.systemPackages = [ pkg-wrapper ];
}
