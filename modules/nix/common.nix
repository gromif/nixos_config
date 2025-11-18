# Nix - Common


{ preferences, ... }:

let
  build-dir = preferences.nix.build-dir or "/nix/build";
in
{
  nixpkgs.config.allowUnfree = true;
  
  nix = {
    channel.enable = false; # Disable usage of nix channels
    settings = {
      # Enable the Flakes feature and the accompanying new nix command-line tool
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      download-buffer-size = 1073741824;
      inherit build-dir;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    optimise = {
      automatic = true;
      dates = [ "11:00"  ];
    };
  };

  # Automatically create & clean the build dir
  systemd.tmpfiles.rules = [
    "d ${build-dir} 0750 root root 7d -"
    "R /nix/var/nix/profiles/per-user - - - - -"
  ];
  
  users.mutableUsers = false; # the contents of the user and group files will be replaced on system activation
}
