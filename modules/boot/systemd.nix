# Boot - Systemd


{ ... }:

{
  boot.loader = {
    timeout = 0;
    systemd-boot = {
      enable = true;
      editor = false;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}
