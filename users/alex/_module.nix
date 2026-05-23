{
  config,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = "alex";
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
      isNormalUser = true;
      description = id;
      home = "/home/${id}";
      createHome = true;
      hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
      extraGroups = [
        "networkmanager"
        "wheel"
        "kvm"
      ];
    };

    home-manager.users."${id}" = {
      imports = [ ./hm ];
      home.username = id;
    };
  };
}
