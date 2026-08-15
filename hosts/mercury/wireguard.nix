{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  port = 17238;
in
{
  networking.firewall.allowedUDPPorts = [ port ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.ip_forward" = 1;
  };
  networking.nat = {
    enable = true;
    internalInterfaces = [ "wg0" ];
    externalInterface = "enp0s25";
  };

  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking = {
    networkmanager.enable = mkForce false;
    useNetworkd = mkForce true;
    useDHCP = mkForce false;
  };

  systemd.network.enable = true;

  # DHCP on the physical interface
  systemd.network.networks."10-enp0s25" = {
    matchConfig.Name = "enp0s25";

    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };

    linkConfig = {
      RequiredForOnline = "routable";
    };
  };

  # WireGuard interface
  systemd.network.netdevs."20-wg0" = {
    netdevConfig = {
      Name = "wg0";
      Kind = "wireguard";
    };

    wireguardConfig = {
      PrivateKeyFile = config.sops.secrets."network/wireguard/key".path;
      ListenPort = port;
    };

    wireguardPeers = [
      {
        PublicKey = "T4VLoZHZVQj3Prk+gFo18veJ8K5o4oSmqkaAYnAcvTk=";
        AllowedIPs = [
          "10.10.0.2/32"
          "fd10:10:10::2/128"
        ];
      }
      {
        PublicKey = "pABYs7dIc3WvM3XKmAVmlI4IJmjqJ1tdJoCOy5SiGEw=";
        AllowedIPs = [
          "10.10.0.3/32"
          "fd10:10:10::3/128"
        ];
      }
    ];
  };

  systemd.network.networks."20-wg0" = {
    matchConfig.Name = "wg0";
    networkConfig = {
      IPv4Forwarding = true;
      IPv6Forwarding = true;
    };
    address = [
      "10.10.0.1/24"
      "fd10:10:10::1/64"
    ];
  };
}
