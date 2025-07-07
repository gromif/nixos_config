# Home - Redroid - Tmpfiles


{ ... }:

let
  redroidRoot = "%h/.local/share/redroid";
  relativePaths = [
    "system/dropbox/*"
    "tombstones"
  ];
  
  newRules = builtins.map (it:
    "R \"${redroidRoot}/*/${it}\" - - - - -"
  ) relativePaths;
in
{
  systemd.user.tmpfiles.rules = newRules;
}
