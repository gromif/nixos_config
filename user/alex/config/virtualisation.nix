# User - Alex - Config - Virtualisation


{ ... }:

{
  # Virt Manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["alex"];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  # Podman
  virtualisation = {
    containers.enable = true; # Enable common container config files in /etc/containers
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.alex.extraGroups = [ "podman" ];
}
