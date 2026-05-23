{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.hardware.graphics.lact;
in
{
  options.nixfiles.hardware.graphics.lact = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the LACT GPU control service";
      default = true;
    };
    profile = mkOption {
      type = types.str;
      description = "Which GPU profile to load";
    };
  };

  config = mkIf (config.nixfiles.hardware.graphics.vendor != "none") {
    services.lact = {
      enable = cfg.enable;
      settings = {
        version = 5;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        auto_switch_profiles = false;
        current_profile = cfg.profile;
      };
    };
  };
}
