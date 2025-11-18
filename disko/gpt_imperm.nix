let
  device = "/dev/nvme0n1";
  persist = "/nix/state";
in
{
  filesystems = {
    "/".neededForBoot = true;
    "${persist}".neededForBoot = true;
  };
  
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "mode=755"
        "size=25%"
      ];
    };
    disk = {
      nvme = {
        type = "disk";
        inherit device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "200M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nodev" "nosuid" "noexec" "relatime" "umask=0077" ];
              };
            };
            root = {
              name = "NixOS";
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = persist;
              };
            };
          };
        };
      };
    };
  };
}
