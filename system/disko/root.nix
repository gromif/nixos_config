{
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
        device = "/dev/disk/by-id/nvme-eui.0026b728269d4f55";
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
            luks = {
              label = "NixOS (Encrypted)";
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/persist";
                };
              };
            };
          };
        };
      };
    };
  };
}
