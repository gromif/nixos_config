# Nix - Common


{ ... }:

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
      build-dir = "/nix/build";
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
  
  users.mutableUsers = false; # the contents of the user and group files will be replaced on system activation
}
