# Home - Config - OpenRGB - Profiles


{ ... }:

let
  profileDir = ./orp;
  profileFiles = builtins.attrNames (builtins.readDir profileDir);

  profileFileAttrs = builtins.listToAttrs (
    map (p: {
      name = "OpenRGB/${p}";
      value = {
        source = "${profileDir}/${p}";
        force = true;
      };
    }) profileFiles
  );
in
{
  xdg.configFile = profileFileAttrs;
}
