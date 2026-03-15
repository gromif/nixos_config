# Services - slskd


{ config, ... }:

{
  services.slskd = {
    enable = true;
    domain = null;
    environmentFile = config.sops.secrets."services/slskd_env".path;
    settings = {
      soulseek.description = "";
    };
    group = "media";
  };
  users.groups.media = {};

  # Set up impermanence
  environment.impermanence.directories = [
    "/var/lib/slskd"
  ];
}
