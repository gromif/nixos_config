# Sandbox - megasync


{ config, pkgs, lib, ... }:

with lib;

let
  pkg_name = "megasync";
  pkg = pkgs."${pkg_name}";
  isInstalled = builtins.hasAttr pkg_name pkgs;
  home = "$HOME/.sandbox/${pkg_name}";
  
  pkg-wrapper = pkgs.writeShellApplication {
    name = pkg_name;
    runtimeInputs = [ pkg ];
    text = ''
      mkdir -p "${home}/.local/share/data" &> /dev/null
      mkdir -p "${home}/MEGA downloads" &> /dev/null
      bwrap \
      --unshare-all \
      --die-with-parent \
      --new-session \
      --ro-bind /nix/store /nix/store \
      --dev /dev \
      --dev-bind /dev/dri /dev/dri \
      --ro-bind /etc /etc \
      --tmpfs /tmp \
      --proc /proc \
      --bind /run/user/$UID /run/user/$UID \
      --ro-bind /run/current-system /run/current-system \
      --ro-bind /run/opengl-driver /run/opengl-driver \
      --ro-bind /run/opengl-driver-32 /run/opengl-driver-32 \
      --ro-bind /sys/dev/char /sys/dev/char \
      --ro-bind /sys/devices/pci0000:00 /sys/devices/pci0000:00 \
      --unsetenv SESSION_MANAGER \
      --unsetenv QT_STYLE_OVERRIDE \
      --unsetenv QT_QPA_PLATFORMTHEME \
      --share-net \
      --tmpfs ~ \
      --bind "${home}/.local/share/data" "$HOME/.local/share/data" \
      --bind "${home}/MEGA downloads" "$HOME/MEGA downloads" -- ${lib.getExe pkg} "$@"
    '';
  };
in
{
  environment.systemPackages = mkIf (isInstalled) [ pkg-wrapper ];
}
