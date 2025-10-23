# System - Boot


{ config, pkgs, ... }:

let
  kernelModules = builtins.toPath ./modules;
  modulesList = builtins.attrNames (builtins.readDir kernelModules);
  modules = builtins.map (m:
    ./modules + "/${m}"
  ) modulesList;
in
{
  imports = modules;
  # Kernel
  # fixed: pkgs.linuxKernel.packages.linux_6_15
  # latest: pkgs.linuxPackages_latest
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  boot.kernelParams = [
    "net.core.bpf_jit_harden=2" # Enables hardening for the BPF Just-In-Time (JIT) compiler
  ];
  
  # Bootloader
  boot.loader = {
    timeout = 0;
    systemd-boot = {
      enable = true;
      editor = false;
      memtest86.enable = true;
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
}
