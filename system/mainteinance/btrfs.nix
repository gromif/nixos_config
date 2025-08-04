# System - Mainteinance - Btrfs


{ ... }:

{
  services.beesd.filesystems = {
    drive_a = {
      spec = "/mnt/drive_a";
      hashTableSizeMB = 128;
      verbosity = "info";
      extraOptions = [
        "--loadavg-target"
        "2.0"
      ];
    };
    drive_m = {
      spec = "/mnt/drive_m";
      hashTableSizeMB = 128;
      verbosity = "info";
      extraOptions = [
        "--loadavg-target"
        "2.0"
      ];
    };
  };
}
