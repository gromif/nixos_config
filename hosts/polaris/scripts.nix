# Scripts


{ config, lib, pkgs, ... }:

let
  endpoint = "celestial-warden.tplinkdns.com";
  ukIdFile = "IdentityFile ~/.ssh/id_ed25519_uk";
  polaris-wake = pkgs.writeShellApplication {
    name = "polaris-wake";
    runtimeInputs = with pkgs; [ wol ];
    text = ''
      wol -v -h ${endpoint} -p 9 00:25:B3:0C:A5:27
    '';
  };
in
{
  programs.ssh.extraConfig = ''
    Host router
      Hostname ${endpoint}
      Port 31472
      User root
      ${ukIdFile}
      LocalForward 7134 192.168.0.1:443
      RequestTTY no
    
    Host mercury-torrent
      Hostname ${endpoint}
      Port 31472
      User root
      ${ukIdFile}
      LocalForward 8080 localhost:8080
      RequestTTY no

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
  ];
}
