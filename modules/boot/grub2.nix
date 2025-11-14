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

  # Whitelist /boot folder if using Impermanence
  environment.impermanence.directories = [
    { directory = "/boot"; mode = "u=rwx,g=,o="; }
  ];
}
