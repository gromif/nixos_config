# Scripts


{ config, lib, pkgs, ... }:

let
  endpoint = "celestial-warden.tplinkdns.com";
  port = "31472";
  ukIdFile = "IdentityFile ~/.ssh/id_ed25519_uk";
  polaris-wake = pkgs.writeShellApplication {
    name = "polaris-wake";
    runtimeInputs = with pkgs; [ wol ];
    text = ''
      wol -v -h ${endpoint} -p 9 00:25:B3:0C:A5:27
    '';
  };
  polaris-ssh-torrent = pkgs.writeShellApplication {
    name = "polaris-ssh-torrent";
    runtimeInputs = with pkgs; [ openssh ];
    text = ''
      ssh -p ${port} -L 8080:localhost:8080 warden@${endpoint}
    '';
  };
  polaris-ssh-router = pkgs.writeShellApplication {
    name = "polaris-ssh-router";
    runtimeInputs = with pkgs; [ openssh ];
    text = ''
      ssh -p ${port} -L 7134:192.168.0.1:443 root@${endpoint}
    '';
  };
in
{
  programs.ssh.extraConfig = ''
    Host apollo-root
      Hostname ${endpoint}
      Port 24942
      User root
      ${ukIdFile}
      
    Host apollo-alex
      Hostname ${endpoint}
      Port 24942
      User alex
      ${ukIdFile}
      
    Host mercury-root
      Hostname ${endpoint}
      Port 31472
      User root
      ${ukIdFile}
      
    Host mercury-warden
      Hostname ${endpoint}
      Port 31472
      User warden
      ${ukIdFile}
  '';
  environment.systemPackages = [
    polaris-wake
    polaris-ssh-torrent
    polaris-ssh-router
  ];
}
