{
  config,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = "avf_droid";
in
{
  config = mkIf (elem id users) {
    # Change the default AVF user
    avf.defaultUser = mkForce "droid";

    users.users.droid = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        yt-dlp
      ];
    };
  };
}
