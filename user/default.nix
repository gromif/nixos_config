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
}
