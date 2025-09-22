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
  };

  users.users.alex.extraGroups = [ "docker" ];
  
  # Other stuff
  environment.systemPackages = with pkgs; [
    distrobox
  ];
}
