# System - Scripts - Maintainance


{ config, pkgs, ... }:

let
  system_config_path = "/etc/nixos";
  git_config_path = "${config.users.users.alex.home}/.config/nixos_config";
  sharedRuntimes = with pkgs; [ bash git ];
  
  flake-update = pkgs.writeShellApplication {
    name = "flake-update";
    runtimeInputs = sharedRuntimes;
    text = ''
      sudo nix flake update --flake "${system_config_path}"
      
      cd "${git_config_path}"
      cp -f "${system_config_path}/flake.lock" "flake.lock"
      
      git add -- flake.lock
      git commit -m "update \`flake.lock\`"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
  
  nix-rotate-secrets = pkgs.writeShellApplication {
    name = "nix-rotate-secrets";
    runtimeInputs = sharedRuntimes ++ [ pkgs.rsync ];
    text = ''
      secretsDir="${system_config_path}/secrets"
      cd "$secretsDir"
      sudo parallel 'sops rotate -i {}' ::: *.yaml &> /dev/null
      
      homeSecretsDir="${system_config_path}/home/secrets"
      cd "$homeSecretsDir"
      sudo parallel 'sops rotate -i {}' ::: *.yaml &> /dev/null
      
      cd "${git_config_path}"
      rsync -r --del "$secretsDir/" "./secrets/"
      rsync -r --del "$homeSecretsDir/" "./home/secrets/"
      
      git add -A -- ./secrets/* ./home/secrets/*
      git commit -m "update secrets"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
  
  nix-upload = pkgs.writeShellApplication {
    name = "nix-upload";
    runtimeInputs = sharedRuntimes ++ [ pkgs.rsync ];
    text = ''
      cd "${git_config_path}"
      
      rsync -r \
        --exclude "/.git" \
        --exclude "/README.md" \
        --del "${system_config_path}/" "./"
      
      echo "Commit message:"
      read -r msg
      
      git add -A
      git commit -m "$msg"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
  
  nix-switch = pkgs.writeShellApplication {
    name = "nix-switch";
    runtimeInputs = sharedRuntimes;
    text = ''
      sudo nixos-rebuild --flake "${system_config_path}" switch
    '';
  };
  nix-dry = pkgs.writeShellApplication {
    name = "nix-dry";
    runtimeInputs = sharedRuntimes;
    text = ''
      sudo nixos-rebuild --flake "${system_config_path}" dry-run
    '';
  };
  nix-test = pkgs.writeShellApplication {
    name = "nix-test";
    runtimeInputs = sharedRuntimes;
    text = ''
      sudo nixos-rebuild --flake "${system_config_path}" test
    '';
  };
  nix-rollback = pkgs.writeShellApplication {
    name = "nix-rollback";
    runtimeInputs = sharedRuntimes;
    text = ''
      sudo nixos-rebuild --flake "${system_config_path}" --rollback
    '';
  };
  nix-void = pkgs.writeShellApplication {
    name = "nix-void";
    runtimeInputs = sharedRuntimes;
    text = "sudo nix-collect-garbage -d";
  };
in
{
  environment.systemPackages = with pkgs; [
    flake-update
    nix-rotate-secrets
    
    nix-switch
    nix-dry
    nix-test
    nix-rollback
    nix-upload
    nix-void
  ];
}
