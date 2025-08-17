# Home - sops.nix

{ config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    age.keyFile = "${config.home.homeDirectory}/.config/sops_key";
  };

  sops.secrets = {
    
  };
}
