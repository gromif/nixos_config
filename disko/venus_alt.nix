let
  device = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55E696FA619B1A863100D-0:0";
  root = "/nix";
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
          type = "table"; # MBR partition table
          format = "msdos"; # explicitly MBR
          partitions = [
            {
              name = "boot";
              size = "512M";
              bootable = true; # CRITICAL: BIOS needs this flag
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
                mountOptions = [
                  "nodev"
                  "nosuid"
                  "noexec"
                  "relatime"
                ];
              };
            }
            {
              name = "root";
              size = "10G";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/nix" = {
                    mountpoint = root;
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            }
            {
              name = "usb";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            }
          ];
        };
      };
    };
  };
}
