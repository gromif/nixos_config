{
  config,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = "mercury_warden";
in
{
  config = mkIf (elem id users) {
    users.users.warden = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.sops.secrets."users/warden/hashedPassword".path;
      # Set up SSH allowed public keys per/user
      openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    };
  };
}
