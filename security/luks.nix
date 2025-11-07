# Security - LUKS


{ config, ... }:

{
  environment.etc."crypttab".text = ''
    luks-280aceb1-9123-460b-9535-1260dbfed1fc UUID=280aceb1-9123-460b-9535-1260dbfed1fc ${config.sops.secrets."luks/usb1".path} nofail,noauto
    luks-4c42117a-3848-4307-9583-21cb80edd2d5 UUID=4c42117a-3848-4307-9583-21cb80edd2d5 ${config.sops.secrets."luks/sd1".path} nofail,noauto
    luks-3055b8b1-b7bd-46e5-87f8-5178a35dfd7d UUID=3055b8b1-b7bd-46e5-87f8-5178a35dfd7d ${config.sops.secrets."luks/sd2".path} nofail,noauto
  '';
}
