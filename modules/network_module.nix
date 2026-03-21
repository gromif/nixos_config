{ config, lib, ... }:

let
  cfg = config.nixfiles.network;
in with lib;
{
  options.nixfiles.network = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the network module.";
    };
    useBBR = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use the BBR congestion control.
        More info: https://en.wikipedia.org/wiki/TCP_congestion_control#TCP_BBR
      '';
    };
  };

  config = mkIf cfg.enable {  
    networking.networkmanager.enable = true;
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant

    boot = mkIf cfg.useBBR {
      kernelModules = [ "tcp_bbr" ];
      kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
    };
  
    # Disable NetworkManager-wait-online service
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
