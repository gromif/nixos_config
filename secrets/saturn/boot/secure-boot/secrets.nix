{ config, lib, ... }:

with lib;

let
  _prefix = "boot/secure-boot";
  _sbctlPath = "/var/lib/sbctl";
  _keysPath = "${_sbctlPath}/keys";
  _keyGroups = [
    "db"
    "KEK"
    "PK"
  ];
  _keySecrets = map (group: {
    name = "${_prefix}/${group}.key";
    value = {
      sopsFile = ./. + "/.${group}.key";
      format = "binary";
      path = "${_keysPath}/${group}/${group}.key";
      owner = "root";
      mode = "0400";
    };
  }) _keyGroups;
  _pemSecrets = map (group: {
    name = "${_prefix}/${group}.pem";
    value = {
      sopsFile = ./. + "/.${group}.pem";
      format = "binary";
      path = "${_keysPath}/${group}/${group}.pem";
      owner = "root";
      mode = "0400";
    };
  }) _keyGroups;
in
{
  config = mkIf (config.nixfiles.sops.enable && config.nixfiles.network.hostName == "saturn") {
    sops.secrets = {
      "${_prefix}/GUID" = {
        sopsFile = ./.GUID;
        format = "binary";
        path = "${_sbctlPath}/GUID";
        owner = "root";
        mode = "0644";
      };
    }
    // listToAttrs (_keySecrets ++ _pemSecrets);
  };
}
