# crypttab


{ config, ... }:

{
  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # <volume-name> <encrypted-device> [key-file] [options]
      crypto-drive-a UUID=85ba2d4f-b797-4d9a-9b6b-43dc51033737 ${config.sops.secrets."luks/drive_a".path} nofail,noauto
      crypto-drive-f UUID=d7107227-1e74-4854-84c8-2f2b37b6fc0f ${config.sops.secrets."luks/drive_f".path} nofail,noauto
    '';
  };
}
