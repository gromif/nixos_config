{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.hardware.graphics.lact;
in
{
  options.nixfiles.hardware.graphics.lact = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the LACT GPU control service";
      default = true;
    };
    profile = mkOption {
      type = types.str;
      description = "Which GPU profile to load";
    };
  };

  config = mkIf (config.nixfiles.hardware.graphics.vendor != "none") {
    services.lact = {
      enable = cfg.enable;
      settings = {
        version = 7;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        auto_switch_profiles = false;
        current_profile = cfg.profile;
      };
    };

    # Hardening
    systemd.services.lactd.serviceConfig = {
      # --- Identity / privilege ---
      KeyringMode = "private";
      NoNewPrivileges = true;
      CapabilityBoundingSet = [
        "CAP_DAC_OVERRIDE"
        "CAP_CHOWN"
      ];
      RestrictSUIDSGID = true;

      # --- Process / kernel isolation ---
      LockPersonality = true;
      MemoryDenyWriteExecute = true; # see warning below
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectProc = "invisible";
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];

      # --- Filesystem / mount namespace ---
      PrivateTmp = true;
      ProtectHome = "tmpfs"; # allows /root/.cache shader cache inside tmpfs
      ProtectSystem = "strict";
      ReadWritePaths = [ "/etc/lact" ];

      # --- Devices ---
      PrivateDevices = false; # required, otherwise DRM char device is hidden
      DeviceAllow = [ "char-drm" ];

      # --- IPC ---
      RemoveIPC = true;

      # --- Network ---
      PrivateNetwork = true;
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_NETLINK"
      ]; # AF_LOCAL dropped, see note
    };
  };
}
