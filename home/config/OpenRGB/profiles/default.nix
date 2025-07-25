# Home - Config - OpenRGB - Profiles


{ ... }:

let
  profileDir = ./orp;
  profileFiles = builtins.attrNames (builtins.readDir profileDir);

  profileFileAttrs = builtins.listToAttrs (
    map (p: {
      name = ".config/OpenRGB/${p}";
      value = {
        source = "${profileDir}/${p}";
        force = true;
      };
    }) profileFiles
  );
in
{
  home.file = profileFileAttrs;
}
