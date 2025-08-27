# User - Alex - Config - Virtualisation


{ pkgs, ... }:

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
    storageDriver = "btrfs";
  };

  users.users.alex.extraGroups = [ "docker" ];
  
  # Other stuff
  environment.systemPackages = with pkgs; [
    distrobox
  ];
}
