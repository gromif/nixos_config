# Security - UsbGuard


{ config, ... }:

{
  services.usbguard = {
    enable = false;
    # Dbus integration
    # dbus.enable = true;
    ruleFile = config.sops.secrets.usbguard-rules.path;
  };
}
