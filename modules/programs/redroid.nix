# Programs - Redroid


{ pkgs, ... }:

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

  # System packages
  environment.systemPackages = with pkgs; [ scrcpy ];
}
