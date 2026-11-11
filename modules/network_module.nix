{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.nixfiles.network;
  aliases = [
    (lib.mkAliasOptionModule [ "nixfiles" "network" "hostName" ] [ "networking" "hostName" ])
  ];
  isAvf = config.nixfiles.system.type == "avf";
  blocklist = pkgs.writeText "blocklist.txt" ''
    ${builtins.readFile inputs.hagezi_pro}    
  '';
in
with lib;
{
  imports = aliases;

  options.nixfiles.network = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the network module.";
    };
    networkmanager = {
      useSecureDNS = mkEnableOption "Dismail Secure DNS";
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

  config = mkIf cfg.enable (mkMerge [
    {
      networking.networkmanager = {
        enable = mkIf (!isAvf) true;
        wifi = {
          macAddress = "random";
          powersave = true;
          scanRandMacAddress = true;
        };
      };
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant
      #
      # Disable NetworkManager-wait-online service
      systemd.services.NetworkManager-wait-online.enable = false;
    }
    (mkIf cfg.useBBR {
      boot = {
        kernelModules = [ "tcp_bbr" ];
        kernel.sysctl = {
          "net.core.default_qdisc" = "fq";
          "net.ipv4.tcp_congestion_control" = "bbr";
        };
      };
    })
    (mkIf cfg.networkmanager.useSecureDNS {
      networking.networkmanager = {
        dns = "none";
      };
      services.dnscrypt-proxy = {
        enable = true;
        # defaults from
        # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
        upstreamDefaults = true;
        settings = {
          ipv6_servers = true;
          block_ipv6 = false;
          require_dnssec = true;
          require_nolog = false;
          require_nofilter = true;
          blocked_names.blocked_names_file = blocklist;
        };
      };
    })
  ]);
}
