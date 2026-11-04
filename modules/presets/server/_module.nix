{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  _presetName = "server";
  _nixfiles = config.nixfiles;
  _cfg = _nixfiles.preset.${_presetName};
in
{
  options.nixfiles.preset.${_presetName} = {
    enable = mkEnableOption "'${_presetName}' preset";
  };

  config = mkMerge [
    {
      nixfiles.preset.${_presetName} = {
      };
    }

    (mkIf _cfg.enable {
      environment = {
        systemPackages = with pkgs; [
          memtester # Userspace utility for testing the memory subsystem for faults
          mtr # Network diagnostics tool
          speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
        ];
      };
    })
  ];
}
