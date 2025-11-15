# Services - OpenSSH


{ config, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 31472 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password"; # prohibit-password
    };
  };

  services = {
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
  environment.impermanence.directories = [
    "/var/lib/fail2ban"
  ];
}
