# User - Alex - Gaming


{ config, pkgs, lib, ... }:

{
  # Automatically load the NTSYNC module
  boot.kernelModules = [ "ntsync" ];
  
  # Set up Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    package = pkgs.steam.override {
      extraEnv = {
        ENABLE_LSFG = true;
        MANGOHUD = true;
      };
    };
    extraPackages = with pkgs; [ 
      mangohud
      lsfg-vk
    ];
  };
  
  environment.systemPackages = with pkgs; [
    lsfg-vk
  ];
  
  # Set up LACT
  services.lact.enable = true;
  systemd.packages = with pkgs; [ lact ];
	systemd.services.lactd.wantedBy = ["multi-user.target"];
	environment.etc."lact/config.yaml".text = ''
    version: 5
    daemon:
      log_level: info
      admin_group: wheel
      disable_clocks_cleanup: false
    apply_settings_timer: 5
    profiles:
      OC:
        gpus:
          '1002:73FF-1458:2334-0000:03:00.0':
            fan_control_enabled: false
            power_cap: 120.0
            performance_level: high
            max_core_clock: 2700
            max_memory_clock: 940
            voltage_offset: -10
    current_profile: OC
    auto_switch_profiles: false
  '';
}
