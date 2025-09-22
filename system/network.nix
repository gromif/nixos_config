# System - Network


{ ... }:

{
  networking.hostName = "apollo"; # Define your hostname
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant
  
  # Use BBR congestion control
  # https://en.wikipedia.org/wiki/TCP_congestion_control#TCP_BBR
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
  };
  
  # Disable NetworkManager-wait-online service
  systemd.services.NetworkManager-wait-online.enable = false;
}
