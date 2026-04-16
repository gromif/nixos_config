let
  device = "/dev/nvme0n1";
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
      main = {
        type = "disk";
        inherit device;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "200M";
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
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/secret.key";
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "${root}" = {
                      mountpoint = root;
                      mountOptions = [
                        "compress=zstd:1"
                        "noatime"
                      ];
                    };
                    "/home/alex" = {
                      mountpoint = "${persist}/home/alex";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                    "/home/nicklor" = {
                      mountpoint = "${persist}/home/nicklor";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                    "/etc" = {
                      mountpoint = "${persist}/etc";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                    "/root" = {
                      mountpoint = "${persist}/root";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                    "/var" = {
                      mountpoint = "${persist}/var";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                    "/var/log" = {
                      mountpoint = "${persist}/var/log";
                      mountOptions = [
                        "noatime"
                      ];
                    };
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
