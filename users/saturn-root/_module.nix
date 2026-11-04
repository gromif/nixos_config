{
  config,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = baseNameOf ./.;
in
{
  config = mkIf (elem id users) {
    users.users.root = {
      hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    };
  };
}
