# Virtualisation - libvirtd


{ preferences, pkgs, ... }:

{
  # Virt Manager
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = preferences.virtualisation.libvirtd.members;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
 
  # Other stuff
  environment.systemPackages = with pkgs; [
    virtiofsd
  ];

  # Persist data
  environment.impermanence.directories = [
    "/var/lib/libvirt"
  ];
}
