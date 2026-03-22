{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixfiles.sops;
  cfgImperm = config.nixfiles.impermanence;
  host = config.nixfiles.network.hostName;
  ageKeyFilePath = "/root/.config/sops/age/keys.txt";

  cfgDir = "/etc/nixos";
  sharedRuntimes = with pkgs; [ bash git sops ];
  
  nix-rotate-secrets = pkgs.writeShellApplication {
    name = "nix-rotate-secrets";
    runtimeInputs = sharedRuntimes;
    text = ''
      cd "${cfgDir}/secrets/${host}"
      
      find . -type f -name "*.yaml" | 
        parallel 'sops rotate -i {}' &> /dev/null
      
      git add -A -- ./*
      git commit -m "update secrets for ${host}"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
in
{
  options.nixfiles.sops = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable SOPS configuration.";
    };
  };

  config = mkIf cfg.enable {
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
      nix-rotate-secrets
    ];
  };
}
