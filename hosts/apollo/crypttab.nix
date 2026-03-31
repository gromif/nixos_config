# crypttab


{ config, ... }:

{
  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # <volume-name> <encrypted-device> [key-file] [options]
      crypto-drive-a UUID=85ba2d4f-b797-4d9a-9b6b-43dc51033737 ${config.sops.secrets."luks/drive_a".path} nofail,noauto
      crypto-drive-f UUID=d7107227-1e74-4854-84c8-2f2b37b6fc0f ${config.sops.secrets."luks/drive_f".path} nofail,noauto
      crypto-usb-a UUID=280aceb1-9123-460b-9535-1260dbfed1fc ${config.sops.secrets."luks/usb_a".path} nofail,noauto
      crypto-sd-a UUID=3055b8b1-b7bd-46e5-87f8-5178a35dfd7d ${config.sops.secrets."luks/sd_a".path} nofail,noauto
    '';
  };
}
