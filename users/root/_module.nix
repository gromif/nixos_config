{
  config,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = "root";
in
{
  options.nixfiles.user."${id}" = {
    id = mkOption {
      type = types.str;
      default = id;
    };
  };
  config = mkIf (elem id users) {
    users.users."${id}" = {
      hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    };
  };
}
