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
                name = "NixOS (Encrypted)";
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
                        "force-compress=zstd"
                        "noatime"
                      ];
                    };
                    "/home/alex" = {
                      mountpoint = "${persist}/home/alex";
                      mountOptions = [
                        "compress=zstd:1"
                        "noatime"
                      ];
                    };
                    "/home/nicklor" = {
                      mountpoint = "${persist}/home/nicklor";
                      mountOptions = [
                        "compress=zstd:1"
                        "noatime"
                      ];
                    };
                    "/var/log" = {
                      mountpoint = "${persist}/var/log";
                      mountOptions = [
                        "force-compress=zstd:10"
                        "noatime"
                      ];
                    };
                    "/home/shared" = {
                      mountpoint = "${persist}/home/shared";
                      mountOptions = [
                        "compress=zstd:1"
                        "relatime"
                        "x-gvfs-show"
                        "x-gvfs-name=Shared"
                      ];
                    };
                    "/home/development" = {
                      mountpoint = "${persist}/home/development";
                      mountOptions = [
                        "force-compress=zstd:5"
                        "relatime"
                        "x-gvfs-show"
                        "x-gvfs-name=Development"
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
