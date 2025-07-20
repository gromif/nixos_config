# Security - UsbGuard


{ config, ... }:

{
  services.usbguard = {
    enable = true;
    # Dbus integration
    # dbus.enable = true;
    ruleFile = config.sops.secrets.usbguard-rules.path;
  };
}
