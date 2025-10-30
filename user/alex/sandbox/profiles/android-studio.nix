# Sandbox - android-studio


{ config, pkgs, lib, ... }:

let
  pkg_name = "android-studio";
  pkg = pkgs."${pkg_name}";
  isInstalled = builtins.hasAttr pkg_name pkgs;
  home = "${config.users.users.alex.home}/.sandbox/${pkg_name}";
  
  pkg-wrapper = pkgs.writeShellApplication {
    name = pkg_name;
    runtimeInputs = [ pkg ];
    text = ''
      mkdir -p "${home}/Projects/Android" &> /dev/null
      mkdir -p "${home}/.ssh" &> /dev/null
      bwrap \
      --unshare-ipc --unshare-pid --unshare-cgroup-try \
      --die-with-parent \
      --new-session \
      --ro-bind /nix/store /nix/store \
      --dev-bind /dev /dev \
      --ro-bind /etc /etc \
      --tmpfs /tmp \
      --proc /proc \
      --ro-bind /sys /sys \
      --bind /run /run \
      --bind ${home} ~ \
      --ro-bind ~/.ssh ~/.ssh \
      --bind ~/Projects/Android ~/Projects/Android -- ${lib.getExe pkg} "$@"
    '';
  };
in
{
  environment.systemPackages = [ pkg-wrapper ];
}
