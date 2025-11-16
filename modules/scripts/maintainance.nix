# System - Scripts - Maintainance


{ config, pkgs, ... }:

let
  nix_conf = "/etc/nixos";
  sharedRuntimes = with pkgs; [ bash git ];
  
  programs.zsh.shellAliases = {
    nix-rebuild = "sudo nixos-rebuild --flake ${nix_conf}";
    nix-void = "sudo nix-collect-garbage -d";
  };
  
  nix-update = pkgs.writeShellApplication {
    name = "nix-update";
    runtimeInputs = sharedRuntimes;
    text = ''
      cd "${nix_conf}"
      nix flake update --flake .
      
      git add -- flake.lock
      git commit -m "update \`flake.lock\`"
      setsid -f bash -c "git push" &> /dev/null
    '';
  };
  nix-upload = pkgs.writeShellApplication {
    name = "nix-upload";
    runtimeInputs = sharedRuntimes ++ [ pkgs.rsync ];
    text = ''
      cd "${nix_conf}"
      
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
in
{
  # Mark the /etc/nixos folder as safe for Git
  programs.git.config.safe.directory = "/etc/nixos";
  
  environment.systemPackages = with pkgs; [
    nix-update
    nix-upload
  ];
}
