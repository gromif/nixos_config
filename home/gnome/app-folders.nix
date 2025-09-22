# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/app-folders".folder-children = [ "System" "Utilities" "debc1815-8f93-41f6-8252-8a22e5f522dc" "9da94c53-050d-44e4-9210-cf797dceba74" "d578561a-14ef-4860-8ce3-c918b19e2f6a" ];

    "org/gnome/desktop/app-folders/folders/9da94c53-050d-44e4-9210-cf797dceba74" = {
      apps = [ "com.toolstack.Folio.desktop" "startcenter.desktop" "base.desktop" "calc.desktop" "draw.desktop" "impress.desktop" "math.desktop" "writer.desktop" "org.gnome.Papers.desktop" ];
      name = "Office";
    };

    "org/gnome/desktop/app-folders/folders/System" = {
      apps = [ "org.gnome.baobab.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Logs.desktop" "nixos-manual.desktop" "org.gnome.tweaks.desktop" "com.mattjakeman.ExtensionManager.desktop" "page.tesk.Refine.desktop" "io.github.ilya_zlobintsev.LACT.desktop" "ca.desrt.dconf-editor.desktop" "org.gnome.Extensions.desktop" "qt5ct.desktop" "qt6ct.desktop" "kvantummanager.desktop" ];
      name = "X-GNOME-Shell-System.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "LocalSend.desktop" "OpenRGB.desktop" "htop.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "scrcpy.desktop" "scrcpy-console.desktop" "org.gnome.Characters.desktop" ];
      name = "X-GNOME-Shell-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/d578561a-14ef-4860-8ce3-c918b19e2f6a" = {
      apps = [ "steam.desktop" "vesktop.desktop" ];
      name = "Games";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/debc1815-8f93-41f6-8252-8a22e5f522dc" = {
      apps = [ "org.nicotine_plus.Nicotine.desktop" "org.qbittorrent.qBittorrent.desktop" "gimp.desktop" "org.inkscape.Inkscape.desktop" "megasync.desktop" "app.drey.EarTag.desktop" "com.github.neithern.g4music.desktop" "com.github.finefindus.eyedropper.desktop" "com.rafaelmardojai.Blanket.desktop" "org.gnome.gitlab.YaLTeR.Identity.desktop" "smplayer.desktop" "io.gitlab.theevilskeleton.Upscaler.desktop" "org.gnome.Totem.desktop" "mpv.desktop" ];
      name = "Media";
      translate = false;
    };
  };
}
