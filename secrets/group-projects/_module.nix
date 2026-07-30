{ config, lib, ... }:

with lib;

let
  isEnabled = config.nixfiles.sops.enable;
  isAllowed = builtins.elem config.nixfiles.network.hostName [
    "apollo"
  ];
  secretsPrefix = "groups/projects";
in
{
  config = mkIf (isEnabled && isAllowed) {
    sops.secrets = {
      "${secretsPrefix}/astra-crypt" = {
        format = "binary";
        sopsFile = ./.astra-crypt.enc;
        group = config.users.groups.users.name;
        mode = "750";
      };
    };
  };
}
