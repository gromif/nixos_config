{ config, lib, ... }:

with lib;

let
  cfg = config.nixfiles.services.openssh;
  aliases = [
    mkAliasOptionModule
      [ "nixfiles" "services" "openssh" "ports" ]
      [ "services" "openssh" "ports" ]
  ];
in
{
  imports = aliases;
  
  options.nixfiles.services.openssh = {
    enable = mkEnableOption "Whether to enable preconfigured OpenSSH.";
    enableEssentials = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use the essential tools, such as fail2ban and endlessh.";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password"; # prohibit-password
      };
    };

    services = mkIf cfg.enableEssentials {
      fail2ban = {
        enable = true;
      };
      endlessh = {
        enable = true;
        port = 22;
        openFirewall = true;
      };
    };

    # Persist data
    nixfiles.impermanence.directories = mkIf config.services.fail2ban.enable [
      "/var/lib/fail2ban"
    ];
  };
}
