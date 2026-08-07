{
  config,
  pkgs,
  lib,
  ...
}:

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

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [
        "10.10.0.1/24"
        "fd10:10:10::2/64"
      ];
      listenPort = port;
      privateKeyFile = config.sops.secrets."network/wireguard/.private".path;
      peers = [
        {
          publicKey = "nTQRqnjdegIjCLKUZcLVojNDW5/YbMXNdBRut4+RqXk=";
          allowedIPs = [
            "10.10.0.2/32"
            "fd10:10:10::2/128"
          ];
        }
      ];
    };
  };
}
