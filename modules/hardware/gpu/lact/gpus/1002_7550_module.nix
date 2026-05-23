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
      gpus = {
        "1002:7550-1043:0613-0000:03:00.0" = {
          fan_control_enabled = false;
          pmfw_options = {
            zero_rpm = true;
          };
          performance_level = "auto";
          max_memory_clock = 1350;
          voltage_offset = -100;
        };
      };
      profiles = {
        MANAGED = {
          gpus = {
            "1002:7550-1043:0613-0000:03:00.0" = {
              fan_control_enabled = false;
              pmfw_options = {
                zero_rpm = true;
              };
              performance_level = "auto";
              max_memory_clock = 1350;
              voltage_offset = -100;
            };
          };
        };
      };
    };
  };
}
