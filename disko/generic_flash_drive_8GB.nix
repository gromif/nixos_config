let
  deviceId = "usb-Generic_Flash_Disk_7F03509F-0:0";
in
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/disk/by-id/${deviceId}";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              label = "GFD (8GB)";
              size = "100%";
              content = {
                type = "luks";
                name = "${deviceId}-crypted";
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
