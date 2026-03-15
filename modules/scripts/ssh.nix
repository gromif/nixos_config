# Scripts


{ config, lib, pkgs, ... }:

let
  wake-mercury = pkgs.writeShellApplication {
    name = "wake-mercury";
    runtimeInputs = with pkgs; [ wol ];
    text = ''
      endpoint=$(cat ${config.sops.secrets."ssh/endpoint".path})
      wol -v -h "$endpoint" -p 9 00:25:B3:0C:A5:27
    '';
  };
in
{
  programs.ssh.extraConfig = ''
    Include ${config.sops.secrets."ssh/extraConfig".path}    
  '';
  environment.systemPackages = [
    wake-mercury
  ];
}
