{ config, lib, ... }:

with lib;

let
  cfg = config.nixfiles.system.locale;
in
{
  options.nixfiles.system.locale = mkOption {
    type = types.str;
    default = "en_GB.UTF-8";
    description = "The default locale.";
  };

  config = {
    i18n = let
      locale = cfg;
    in {
      defaultLocale = locale;
      extraLocaleSettings = {
        LC_ADDRESS = locale;
        LC_IDENTIFICATION = locale;
        LC_MEASUREMENT = locale;
        LC_MONETARY = locale;
        LC_NAME = locale;
        LC_NUMERIC = locale;
        LC_PAPER = locale;
        LC_TELEPHONE = locale;
        LC_TIME = locale;
      };
    };
  };
}
