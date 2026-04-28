# Services - qbittorrent

{ config, ... }:

let
  dataDir = "/var/lib/qBittorrent";
  cfg = config.services.qbittorrent;
in
{
  services.qbittorrent = {
    enable = true;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          LocalHostAuth = false;
        };
        General.Locale = "en";
      };
    };
    openFirewall = true;
    torrentingPort = 47540;
    group = "media";
  };

  # Persist data
  nixfiles.impermanence.directories = [
    dataDir
  ];

  # Correct permissions
  systemd.tmpfiles.rules = [
    "Z ${dataDir}/qBittorrent 2750 ${cfg.user} ${cfg.group}"
  ];
}
