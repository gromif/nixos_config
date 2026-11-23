{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.hm.gvariant;

let
  _name = "change-brightness";
  _cfg = config.hmfiles.gnome.keybindings.${_name};
  toggleScript = pkgs.writeShellApplication {
    runtimeInputs = with pkgs; [
      ddcutil
    ];
    name = _name;
    text = ''
      MODE=$1

      ddcutil setvcp 10 "$MODE" 15
    '';
  };
in
{
  options.hmfiles.gnome.keybindings.${_name} = {
    enable = mkEnableOption "Gnome keybinding for Brightness Control";
  };

  config = mkIf _cfg.enable {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${_name}_positive/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${_name}_negative/"
      ];

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${_name}_positive" = {
        binding = "<Alt><Super>Page_Up";
        command = "${getExe toggleScript} +";
        name = "Increase Brightness";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${_name}_negative" = {
        binding = "<Alt><Super>Page_Down";
        command = "${getExe toggleScript} -";
        name = "Decrease Brightness";
      };
    };
  };
}
