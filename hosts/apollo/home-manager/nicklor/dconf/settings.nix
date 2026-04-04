# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, pkgs, ... }:

with lib.hm.gvariant;

{
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      volume-step = 2;
    };
    # Mutter
    "org/gnome/mutter" = {
      center-new-windows = true;
      experimental-features = [ "autoclose-xwayland" ];
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
    # Privacy
    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 7;
      recent-files-max-age = mkInt32 14;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
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
  };
}
