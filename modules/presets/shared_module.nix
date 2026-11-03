{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  _presetName = "Shared";
  _enableOptionName = "enable${_presetName}";
  _state = config.nixfiles.preset.${_enableOptionName};
in
{
  options.nixfiles.preset.${_enableOptionName} = mkEnableOption "'${_presetName}' preset";

  config = mkIf _state {
    programs.firefox.policies = {
      # Disable WebRTC globally
      MediaPeerConnection = {
        enabled = false;
      };
    };
  };
}
