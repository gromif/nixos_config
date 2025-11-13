# Boot - grub2


{ ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader = {
    timeout = 2;
    grub = {
      enable = true;
      device = "/dev/sda";
    };
  };
}
