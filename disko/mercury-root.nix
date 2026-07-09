let
  device = "/dev/sda";
  root = "/nix";
  persist = "/nix/state";
in
{
  filesystems = {
    "/".neededForBoot = true;
    "${root}".neededForBoot = true;
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
      sda = {
        type = "disk";
        inherit device;
        content = {
          type = "mbr";
          partitions = {
            boot = {
              size = "1G";
              type = "83";
              bootable = true;
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/nix" = {
                    mountpoint = root;
                    mountOptions = [
                      "compress=zstd"
                      "autodefrag"
                      "noatime"
                    ];
                  };
                  "${persist}" = {
                    mountpoint = persist;
                    mountOptions = [
                      "noatime"
                    ];
                  };
                  "${persist}/home" = { };
                  "${persist}/var" = { };
                  "${persist}/root" = { };
                  "${persist}/etc" = { };
                };
              };
            };
          };
        };
      };
    };
  };
}
