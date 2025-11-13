# Hosts - Mercury


{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # Auto-login the first tty console
  services.getty.autologinUser = "warden";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.warden = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = config.sops.secrets."users/warden/hashedPassword".path;
    # Set up SSH allowed public keys per/user
    openssh.authorizedKeys.keyFiles = [
      config.sops.secrets."ssh/apollo/public_key".path
      config.sops.secrets."ssh/galileo/public_key".path
      config.sops.secrets."ssh/polaris/public_key".path
    ];    
  };
  users.users.root = {
    hashedPassword = config.sops.secrets."users/root/hashedPassword".path;
    # Set up SSH allowed public keys per/user
    openssh.authorizedKeys.keyFiles = [
      config.sops.secrets."ssh/apollo/public_key".path
      config.sops.secrets."ssh/galileo/public_key".path
      config.sops.secrets."ssh/polaris/public_key".path
    ];
    packages = with pkgs; [
      tcpdump
    ];
  };
}
