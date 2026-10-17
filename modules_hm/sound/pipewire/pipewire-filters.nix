{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.hm.gvariant;

let
  _pipewire = config.hmfiles.sound.pipewire;
  _filters = _pipewire.filters;
  _systemd = _filters.systemd;
  systemdServiceName = "load-pipewire-filters";
  systemdScript = pkgs.writeShellApplication {
    runtimeInputs = [ pkgs.pipewire ];
    name = "${systemdServiceName}_script";
    text = "pipewire -c filter-chain.conf";
  };
  toggleScript = pkgs.writeShellApplication {
    runtimeInputs = with pkgs; [
      systemd
      libnotify
    ];
    name = "toggle-pipewire-filters";
    text = ''
      n_title="Pipewire Filters"

      if systemctl --user is-active --quiet ${systemdServiceName}; then
        systemctl --user stop ${systemdServiceName}
        notify-send -e -t 500 "$n_title" "Disabled"
      else
        systemctl --user start ${systemdServiceName}
        notify-send -e -t 500 "$n_title" "Enabled"
      fi
    '';
  };
in
{
  options.hmfiles.sound.pipewire.filters.systemd = {
    enable = mkEnableOption "Filters persistent service";
    integration = mkOption {
      type = types.enum [
        "none"
        "gnome"
      ];
      default = "none";
      description = "Whether to integrate toggle script support in the selected environment";
    };
  };

  config = mkIf (_pipewire.enable && _systemd.enable) (mkMerge [
    {
      home.packages = [ toggleScript ];
      systemd.user.services."${systemdServiceName}" = {
        Unit.Description = "Loads Pipewire audio filters";
        Service.ExecStart = "${getExe systemdScript}";
      };
    }
    (mkIf (_systemd.integration == "gnome") {
      dconf.settings = {
        "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Control><Super>p";
          command = "${getExe toggleScript}";
          name = "Toggle Pipewire Filters";
        };
      };
    })
  ]);
}
