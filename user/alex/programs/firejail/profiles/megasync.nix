# Sandbox - megasync


{ config, pkgs, lib, ... }:

let
  pkg_name = "megasync";
  pkg = pkgs."${pkg_name}";
  isInstalled = builtins.hasAttr pkg_name pkgs;
  home = "${config.users.users.alex.home}/.local/share/sandbox/MegaSync";
  
  pkg-wrapper = pkgs.writeShellApplication {
    name = pkg_name;
    runtimeInputs = [ pkg ];
    text = ''
      bwrap \
      --unshare-all \
      --die-with-parent \
      --new-session \
      --ro-bind /nix/store /nix/store \
      --ro-bind /etc /etc \
      --ro-bind /sys /sys \
      --ro-bind /run/current-system /run/current-system \
      --tmpfs /tmp \
      --proc /proc \
      --dev /dev \
      --bind /run/user/$UID /run/user/$UID \
      --unsetenv SESSION_MANAGER \
      --unsetenv QT_STYLE_OVERRIDE \
      --unsetenv QT_QPA_PLATFORMTHEME \
      --share-net \
      --tmpfs ~ \
      --bind "${home}/.local/share/data" "$HOME/.local/share/data" \
      --bind "${home}/MEGA downloads" "$HOME/MEGA downloads" \
      --bind "${home}/MEGA" "$HOME/MEGA" \
      --bind "${home}/Downloads" "$HOME/Downloads" -- ${lib.getExe pkg} "$@"
    '';
  };
in
{
  environment.systemPackages = [ pkg-wrapper ];
}
