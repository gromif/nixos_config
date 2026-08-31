{
  config,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = "mercury_root";
in
{
  config = mkIf (elem id users) {
    users.users.root = {
      hashedPasswordFile = config.sops.secrets."users/root/hashedPassword".path;
      # Set up SSH allowed public keys per/user
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlwUoUDRQM98RN6d2aVBvsVl0RhP4lUUBacfbPfbxfP nicklor@apollo" # Nicklor / Apollo
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkstoRvU2rtFcd0kGwI4WKCM+CZYzuk8krRpoz9DC/9 root@mercury" # Alex / Apollo
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILI0hK6R1bUOrz7buYHHRlEvHbIlRUf3MNXNxZjjMjYo moon@mercury" # Root / Moon
      ];
    };
  };
}
