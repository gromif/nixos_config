{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixfiles.preset;
in
{
  config = mkIf (cfg != "none") {
    programs.firefox.policies = {
      # Disable WebRTC globally
      MediaPeerConnection = {
        enabled = false;
      };
    };
  };
}
