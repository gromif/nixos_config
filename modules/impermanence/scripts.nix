# Impermanence - Scripts


{ config, pkgs, ... }:

let
  overrides = map (o:
    " -path \"${o}\" -prune -o"
  ) [
    # Directories
    "/root/.config/OpenRGB"
    "/tmp"
    "/var/cache/libvirt/qemu/capabilities"
    "/var/lib/upower"
    "/var/lib/OpenRGB"
    "/var/lib/NetworkManager"
    "/var/lib/systemd"
    
    # Files
    "/etc/sudoers"
    "/etc/subgid"
    "/etc/subuid"
    "/etc/shadow"
    "/etc/passwd"
    "/etc/group"
    "/etc/resolv.conf"
    "/etc/.updated"
    "/etc/machine-id"
    "/etc/NIXOS"
    "/etc/.clean"
    "/var/.updated"
    "/var/lib/logrotate.status"
  ];
  
  inspectRuntimes = with pkgs; [ findutils ];
  inspect-root = pkgs.writeShellApplication {
    name = "inspect-root";
    runtimeInputs = inspectRuntimes;
    text = ''
      sudo find / -xdev \
        ${toString overrides} \
        -type f -print
    '';
  };
  
  walkRuntimes = with pkgs; [ ncdu ];
  walk-root = pkgs.writeShellApplication {
    name = "walk-root";
    runtimeInputs = walkRuntimes;
    text = "sudo ncdu / --one-file-system";
  };
in
{
  environment.systemPackages = with pkgs; [
    inspect-root
    
    walk-root
  ];
}
