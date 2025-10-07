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
  
  systemd.tmpfiles.rules = [
    # Adjust the home folder mode
    "z /root 0700 root root - -"
    
    # Set up ssh keys
    "d /root/.ssh 0700 root root - -"
    "L+ /root/.ssh/known_hosts - - - - ${config.sops.secrets."ssh/root/known_hosts".path}"
    "L+ /root/.ssh/id_ed25519 - - - - ${config.sops.secrets."ssh/root/id_ed25519".path}"
    "L+ /root/.ssh/id_ed25519.pub - - - - ${config.sops.secrets."ssh/root/id_ed25519_pub".path}"
  ];
}
