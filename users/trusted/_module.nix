{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = "trusted";
in
{
  options.nixfiles.user."${id}" = {
    id = mkOption {
      type = types.str;
      default = id;
    };
  };
  config = mkIf (elem id users) {
    users.users."${id}" = mkForce {
      isNormalUser = true;
      description = id;
      home = "/home/${id}";
      createHome = true;
      password = "0000";
      extraGroups = [ ];
      packages = with pkgs; [
        # Terminal
        kitty
        tldr

        # Tools
        mission-center
        bottles
      ];
    };
  };
}
