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
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1;
            };
            ESP = {
              label = "ESP";
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "nodev"
                  "nosuid"
                  "noexec"
                  "relatime"
                  "umask=0077"
                ];
              };
              priority = 2;
            };
            root = {
              size = "100%";
              priority = 3;
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
