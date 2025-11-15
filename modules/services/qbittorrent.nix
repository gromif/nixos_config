# Services - qbittorrent


{ ... }:

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
    group = "users";
  };

  # Persist data
  environment.impermanence.directories = [
    "/var/lib/qBittorrent"
  ];
}
