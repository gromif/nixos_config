# Virtualisation - Distrobox


{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ distrobox ];
}
