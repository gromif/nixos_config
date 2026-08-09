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
          AuthSubnetWhitelistEnabled = true;
          AuthSubnetWhitelist = "10.10.0.1, 10.10.0.2";
          LocalHostAuth = false;
          Username = "root";
          Password_PBKDF2 = "@ByteArray(TVKWeyBPesw9FDofThW5RQ==:AqT74nk/MfgMrJdfikJqAdIHwlIzW75Th9udmMYsKRMDC9Uw5nRnvMDVZmVE4sV+8IkJFtuWBecV+wO8KBa7yg==)";
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
