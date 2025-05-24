# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

{
  # Open ports in the firewall.
  # 5555 - ADB TCPIP
  # 2234 - Nicotine+
  # 27508 - Qbittorrent
  networking.firewall.allowedTCPPorts = [ 27508 2234 5555 ];
  
  # 1716 - KDE Connect port
  # 27508 - Qbittorrent
  networking.firewall.allowedUDPPorts = [ 27508 1716 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # Lock Kernel Modules
  # security.lockKernelModules = true;
  
  # Restrict Nix pm for users outside of the @wheel group
  nix.settings.allowed-users = [ "@wheel" ];
  
  # Prevent replacing the running Kernel
  security.protectKernelImage = true;
  
  # Include memory-safe sudo implementation
  security.sudo.enable = false;
  security.sudo-rs = {
  		enable = true;
  		execWheelOnly = true;
  };
}
