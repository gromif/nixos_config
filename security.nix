# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

{
  environment.etc."crypttab".text = ''
    luks-drive-a UUID=7dfbbd9f-f52f-48b0-b677-1b812ca1250f ${config.sops.secrets."luks/drive_a".path} nofail,noauto
    luks-drive-m UUID=7b9cfc12-ad71-4af0-a252-f903decc2876 ${config.sops.secrets."luks/drive_m".path} nofail,noauto
    luks-280aceb1-9123-460b-9535-1260dbfed1fc UUID=280aceb1-9123-460b-9535-1260dbfed1fc ${config.sops.secrets."luks/usb1".path} nofail,noauto
    luks-4c42117a-3848-4307-9583-21cb80edd2d5 UUID=4c42117a-3848-4307-9583-21cb80edd2d5 ${config.sops.secrets."luks/sd1".path} nofail,noauto
    luks-3055b8b1-b7bd-46e5-87f8-5178a35dfd7d UUID=3055b8b1-b7bd-46e5-87f8-5178a35dfd7d ${config.sops.secrets."luks/sd2".path} nofail,noauto
  '';
  
  # Open ports in the firewall.
  # 5555 - ADB TCPIP
  # 2234 - Nicotine+
  # 27508 - Qbittorrent
  #networking.firewall.allowedTCPPorts = [ 27508 2234 5555 ];
  
  # 1716 - KDE Connect port
  # 27508 - Qbittorrent
  #networking.firewall.allowedUDPPorts = [ 27508 1716 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  
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
