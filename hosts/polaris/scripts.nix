# Scripts


{ config, lib, pkgs, ... }:

let
  endpoint = "134.249.111.37";
  port = "31472";
  polaris-wake = pkgs.writeShellApplication {
    name = "polaris-wake";
    runtimeInputs = with pkgs; [ wol ];
    text = ''
      wol -v -h ${endpoint} -p 9 00:25:B3:0C:A5:27
    '';
  };
  polaris-ssh = pkgs.writeShellApplication {
    name = "polaris-ssh";
    runtimeInputs = with pkgs; [ openssh ];
    text = ''
      ssh -p ${port} warden@${endpoint}
    '';
  };
  polaris-ssh-root = pkgs.writeShellApplication {
    name = "polaris-ssh-root";
    runtimeInputs = with pkgs; [ openssh ];
    text = ''
      ssh -p ${port} root@${endpoint}
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
  environment.packages = [
    polaris-wake
    polaris-ssh
    polaris-ssh-root
    polaris-ssh-torrent
    polaris-ssh-router
  ];
}
