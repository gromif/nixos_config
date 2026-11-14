let
  deviceId = "usb-_USB_FLASH_DRIVE_0701085D1AD6C886-0:0";
in
{
  disko.devices = {
    disk = {
      drive = {
        type = "disk";
        device = "/dev/disk/by-id/${deviceId}";
        content = {
          type = "gpt";
          partitions = {
            BIOS = {
              label = "BIOS";
              size = "200M";
              content = {
                type = "filesystem";
                format = "vfat";
              };
            };
            luks = {
              label = "Apacer Red [LUKS]";
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
