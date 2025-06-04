# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, pkgs, ... }:

with lib.hm.gvariant;

{
  dconf.enable = true;
  dconf.settings = {
    # Shell
    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        blur-my-shell.extensionUuid
        appindicator.extensionUuid
        legacy-gtk3-theme-scheme-auto-switcher.extensionUuid
        caffeine.extensionUuid
        light-style.extensionUuid
        gsconnect.extensionUuid
        control-monitor-brightness-and-volume-with-ddcutil.extensionUuid
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      volume-step = 2;
    };
    # Mutter
    "org/gnome/mutter" = {
      center-new-windows = true;
      experimental-features = [
        "autoclose-xwayland"
        "variable-refresh-rate" # VRR Support
        "xwayland-native-scaling" # Xwayland Native Scaling Support
      ];
    };

    # Interface
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3";
      icon-theme = "Tela-blue";
      clock-format = "12h";
      font-antialiasing = "rgba";
    };
    # Peripherals
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
    # Sound
    "org/gnome/desktop/sound".theme-name = "ocean";

    # Nautilus
    "org/gnome/nautilus/preferences" = {
      show-delete-permanently = true;
      show-create-link = true;
      click-policy = "single";
      show-image-thumbnails = "always";
      recursive-search = "always";
      show-directory-item-counts = "always";
      sort-directories-first = true;
    };

    # Extensions
    "org/gnome/shell/extensions/blur-my-shell/panel".force-light-text = true;
  };
}
