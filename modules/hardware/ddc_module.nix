{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.hardware.ddc;
in
{
  options.nixfiles.hardware.ddc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable ddcutil support";
    };
    allowedUsers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Allowed users to run DDC commands";
    };
  };

  config = mkIf cfg.enable {
    hardware.i2c = {
      enable = true;
    };
    users.groups."${config.hardware.i2c.group}".members = cfg.allowedUsers;
  };
}
