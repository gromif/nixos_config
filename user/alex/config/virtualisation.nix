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
  
  # Docker
  virtualisation.docker = {
    enable = true;
  };
}
