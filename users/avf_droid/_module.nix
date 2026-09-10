{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  users = config.nixfiles.users;
  id = "avf_droid";
in
{
  config = mkIf (elem id users) (mkMerge [
    (optionalAttrs (options ? avf) {
      # Change the default AVF user
      avf = {
        defaultUser = "droid";
      };

      users.users.droid = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [
          yt-dlp
        ];
      };
    })
  ]);
}
