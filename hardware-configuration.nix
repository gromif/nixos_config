# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  
  services.udisks2.settings = {
    "WDC-WD10EZEX-75WN4A1-WD-WCC6Y3LUAL99.conf" = {
      ATA = {
        StandbyTimeout = 60;
        WriteCacheEnabled = true;
      };
    };
  };

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/96A5-302B";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/645f8701-0f14-4732-95b4-64fb39977b27";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/645f8701-0f14-4732-95b4-64fb39977b27";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd:1" "relatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/645f8701-0f14-4732-95b4-64fb39977b27";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@persist" "compress=zstd:1" "relatime" ];
    };
    
  fileSystems."/mnt/drive_a" =
    { device = "/dev/mapper/luks-drive-a";
      fsType = "btrfs";
      options = [ #"nodev" "nosuid" "noexec" 
        "noatime" "compress=zstd:5" "autodefrag"
      		"x-gvfs-name=Drive%20A" "x-gvfs-show" "x-systemd.automount"
      		"noauto"
      ];
    };
  fileSystems."/mnt/drive_m" =
    { device = "/dev/mapper/luks-drive-m";
      fsType = "btrfs";
      options = [ #"nodev" "nosuid" "noexec"
        "noatime" "compress=zstd:5" "autodefrag"
      		#"ro" # Make it read-only
      		"x-gvfs-name=Drive%20M" "x-gvfs-show" "x-systemd.automount"
      		"noauto"
      ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp10s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp9s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.bluetooth.powerOnBoot = false;
}
