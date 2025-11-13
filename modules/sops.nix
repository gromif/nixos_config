# sops.nix

{ inputs, config, pkgs, ... }:

let
  cfgImperm = config.environment.impermanence;
  host = config.networking.hostName;
  ageKeyFilePath = "/root/.config/sops/age/keys.txt";
in
{
  sops = {
    # defaultSopsFile = "../secrets.yaml"; To be overrided by a host config
    defaultSopsFormat = "yaml";

    # set the persisted AGE key-file path
    age.keyFile = if (cfgImperm.enable) then
      "${cfgImperm.persistentStoragePath}${ageKeyFilePath}" else ageKeyFilePath;
  };

  # Install the sops package
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
