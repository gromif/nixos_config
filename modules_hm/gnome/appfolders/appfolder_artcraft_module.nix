{
  config,
  lib,
  ...
}:

with lib;
with lib.hm.gvariant;

let
  _name = "ARTCRAFT";
  _cfg = config.hmfiles.gnome.appfolders.${_name};

in
{
  options.hmfiles.gnome.appfolders.${_name} = {
    enable = mkEnableOption "Gnome keybinding for Brightness Control";
  };

  config = mkIf _cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/app-folders".folder-children = [ "${_name}" ];
      "org/gnome/desktop/app-folders/folders/${_name}" = {
        apps = [
          "ai.storyteller.deckcraft.desktop"
          "ai.storyteller.filmcraft.desktop"
          "ai.storyteller.gridcraft.desktop"
          "ai.storyteller.lightcraft.desktop"
          "ai.storyteller.pdfcraft.desktop"
          "ai.storyteller.photocraft.desktop"
          "ai.storyteller.vectorcraft.desktop"
          "ai.storyteller.wordcraft.desktop"
        ];
        name = "${_name}";
        translate = true;
      };
    };
  };
}
