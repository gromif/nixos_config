{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixfiles.sops;
  cfgImperm = config.nixfiles.impermanence;
  ageKeyFilePath = "/root/.config/sops/age/keys.txt";

  sharedRuntimes = with pkgs; [
    bash
    git
    sops
  ];

  nix-rotate-secrets = pkgs.writeShellApplication {
    name = "nix-rotate-secrets";
    runtimeInputs = sharedRuntimes;
    text = ''
      find . -type f -name "*.yaml" \
        -exec sops rotate -i {} \;

      git add -A -- ./*
      git commit -m "update secrets"
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
      age.keyFile =
        if (cfgImperm.enable) then
          "${cfgImperm.persistentStoragePath}${ageKeyFilePath}"
        else
          ageKeyFilePath;
    };

    # Install the sops package
    environment.systemPackages = with pkgs; [
      sops
      age
      nix-rotate-secrets
    ];
  };
}
