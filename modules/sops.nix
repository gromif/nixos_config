# sops.nix

{ inputs, config, pkgs, ... }:

let
  cfgImperm = config.environment.impermanence;
  host = config.networking.hostName;
  ageKeyFilePath = "/root/.config/sops/age/keys.txt";

  cfgDir = "/etc/nixos";
  sharedRuntimes = with pkgs; [ bash git ];
  
  nix-rotate-secrets = pkgs.writeShellApplication {
    name = "nix-rotate-secrets";
    runtimeInputs = sharedRuntimes ++ [ pkgs.rsync ];
    text = ''
      cd "${cfgDir}"
      targetSecrets=./secrets/${host}
      
      find "$targetSecrets" -type f -name "*.yaml" | 
        parallel 'sops rotate -i {}' &> /dev/null
      
      git add -A -- "$targetSecrets/*"
      git commit -m "update secrets for \`${host}\`"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
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
    nix-rotate-secrets
  ];
}
