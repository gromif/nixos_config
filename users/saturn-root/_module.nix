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
      hashedPasswordFile = config.sops.secrets."users/root/hashedPassword".path;
    };
  };
}
