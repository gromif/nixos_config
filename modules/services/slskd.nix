# Services - slskd

{ config, ... }:

let
  dataDir = "/var/lib/slskd";
  cfg = config.services.slskd;
in
{
  services.slskd = {
    enable = true;
    domain = null;
    environmentFile = config.sops.secrets."services/slskd_env".path;
    openFirewall = true;
    settings = {
      web.port = 9054;
      soulseek.description = "";
    };
    group = "media";
  };
  users.groups.media = { };

  networking.firewall.allowedTCPPorts = [ config.services.slskd.settings.web.port ];

  # Set up impermanence
  nixfiles.impermanence.directories = [
    "/var/lib/slskd"
  ];

  # Correct permissions
  systemd.tmpfiles.rules = [
    "Z ${dataDir}/ 2750 ${cfg.user} ${cfg.group}"
  ];
}
