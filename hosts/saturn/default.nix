{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./lanzaboote.nix
    ./crypttab.nix
  ];

  time.timeZone = "Europe/Berlin";
  nixfiles = {
    preset = {
      shared.enable = true;
      desktop.enable = true;
    };
    system = {
      home-manager = true;
      stateVersion = "25.11";
    };
    network.hostName = baseNameOf ./.;
    hardware = {
      graphics = {
        vendor = "amd";
        lact.profile = "RX580_UV";
      };
    };
    users = [
      "saturn-root"
      "saturn-nicklor"
    ];
    virtualisation.libvirtd.members = [ "nicklor" ];
  };

  xdg.mime.predefined.enable = true;

  # Display OC
  boot.kernelParams = "video=HDMI-A-1:1920x1080@84";
}
