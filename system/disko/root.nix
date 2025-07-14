let
  sharedMountOptions = [
    "compress=zstd:1" "relatime"
  ];
in
{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        # set mode to 755, otherwise systemd will set it to 777, which cause problems.
        # relatime: Update inode access times relative to modify or change time.
        "mode=755"
        "size=3G"
      ];
    };
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.0026b728269d4f55";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "300M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nodev" "nosuid" "noexec" "relatime" "umask=0077" ];
              };
            };
            NixOS = {
              label = "NixOS";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = sharedMountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = sharedMountOptions;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = sharedMountOptions;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
