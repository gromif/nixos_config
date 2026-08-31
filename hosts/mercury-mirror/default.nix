{
  lib,
  ...
}:

with lib;

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Specify custom bootloader device
  boot.loader.grub.device = mkForce "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55E696FA619B1A863100D-0:0";
}
