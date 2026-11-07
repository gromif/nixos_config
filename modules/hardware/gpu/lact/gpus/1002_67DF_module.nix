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
  config = mkIf (cfg.enable) {
    services.lact.settings = {
      profiles = {
        RX580_UV = {
          gpus = {
            "1002:67DF-1458:22FC-0000:01:00.0" = {
              fan_control_enabled = false;
              power_cap = 217.0;
              performance_level = "auto";

              gpu_vf_curve = {
                "7".voltage = 1150;
              };

              mem_vf_curve = {
                "2".voltage = 960;
              };
            };
          };
        };
      };
    };
  };
}
