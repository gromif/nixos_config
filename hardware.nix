{ config, ... }:

{
  hardware = {
    bluetooth.powerOnBoot = false;
    enableRedistributableFirmware = true;
  };

  services.udisks2.settings = {
    "WDC-WD10EZEX-75WN4A1-WD-WCC6Y3LUAL99.conf" = {
      ATA = {
        StandbyTimeout = 60;
        WriteCacheEnabled = true;
      };
    };
  };
}
