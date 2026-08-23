{ config, lib, ... }:

with lib;

{
  config = mkIf (config.nixfiles.sops.enable) {
    sops.secrets = {
      "ssh/endpoint" = {
        format = "binary";
        sopsFile = ./ssh/.endpoint_uk;
        mode = "0744";
      };
      "ssh/extraConfig" = {
        format = "binary";
        sopsFile = ./ssh/.config;
        mode = "0755";
      };
      "services/slskd_env" = lib.mkIf config.services.slskd.enable {
        sopsFile = ./.slskd.yaml;
        owner = config.services.slskd.user;
        group = config.services.slskd.group;
      };
      ".lossless_scaling.dll" = mkIf config.nixfiles.gaming.enableLSFG {
        sopsFile = ./.lossless_scaling.dll;
        format = "binary";
        path = "/opt/LosslessScaling.dll";
        group = config.users.groups.users.name;
        mode = "0750";
      };
    };
  };
}
