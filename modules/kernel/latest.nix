# Kernel - Latest


{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
