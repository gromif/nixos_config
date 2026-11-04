# crypttab

{ config, ... }:

{
  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # <volume-name> <encrypted-device> [key-file] [options]
      crypto-drive-f UUID=d7107227-1e74-4854-84c8-2f2b37b6fc0f ${
        config.sops.secrets."luks/drive_f".path
      } nofail,noauto
    '';
  };
}
