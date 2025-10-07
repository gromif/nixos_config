# Users


{ config, ... }:

{
  imports = [ ./alex ];
  users.mutableUsers = false; # the contents of the user and group files will be replaced on system activation
  
  # ============================================================================================================
  # Root user
  # ============================================================================================================
  users.users.root = {
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
  };
  
  # Set up ssh keys
  systemd.tmpfiles.rules = [
    "d /root/.ssh 0700 root root - -"
    "L+ /root/.ssh/known_hosts - - - - ${config.sops.secrets."ssh/root/known_hosts".path}"
    "L+ /root/.ssh/id_ed25519 - - - - ${config.sops.secrets."ssh/root/id_ed25519".path}"
    "L+ /root/.ssh/id_ed25519.pub - - - - ${config.sops.secrets."ssh/root/id_ed25519_pub".path}"
  ];
}
