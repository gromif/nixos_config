# System - Scripts - Maintainance


{ config, pkgs, ... }:

let
  system_config_path = "/etc/nixos";
  sharedRuntimes = with pkgs; [ bash git ];
  
  flake-update = pkgs.writeShellApplication {
    name = "flake-update";
    runtimeInputs = sharedRuntimes;
    text = ''
      cd "${system_config_path}"
      nix flake update --flake .
      
      git add -- flake.lock
      git commit -m "update \`flake.lock\`"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
  
  nix-rotate-secrets = pkgs.writeShellApplication {
    name = "nix-rotate-secrets";
    runtimeInputs = sharedRuntimes ++ [ pkgs.rsync ];
    text = ''
      cd "${system_config_path}"
      
      find ./secrets -type f -name "*.yaml" | 
        parallel 'sops rotate -i {}' &> /dev/null
      
      git add -A -- ./secrets/*
      git commit -m "update secrets"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
  
  nix-upload = pkgs.writeShellApplication {
    name = "nix-upload";
    runtimeInputs = sharedRuntimes ++ [ pkgs.rsync ];
    text = ''
      cd "${system_config_path}"
      
      echo "The repository status:"
      git status
      echo "Is everything all right? [ENTER to continue]"
      read -r
      
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
  # Mark the /etc/nixos folder as safe for Git
  programs.git.config.safe.directory = "/etc/nixos";
  
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
