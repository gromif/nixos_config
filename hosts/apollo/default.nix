{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./crypttab.nix
    ./vfio.nix
  ];

  time.timeZone = "Europe/Berlin";

  nixfiles = {
    system = {
      shell.console.optimalSettings = true;
      stateVersion = "25.11";
    };
    boot.kernelModules.v4l2loopback.enable = true;
    network = {
      hostName = baseNameOf ./.;
    };
    sound.backend = "pipewire";
    hardware = {
      ddc = {
        enable = true;
        allowedUsers = [
          "alex"
          "nicklor"
        ];
      };
      graphics.vendor = "amd";
    };
    de = {
      enable = true;
      gnome = {
        enable = true;
        services = {
          theme-changer.enable = true;
        };
      };
    };
    virtualisation = {
      libvirtd = {
        enable = true;
        members = [
          "alex"
        ];
      };
      docker = {
        enable = true;
        users = [ "alex" ];
      };
    };
    programs = {
      appimage.enable = true;
      android-studio = {
        enable = true;
        users = [ "alex" ];
      };
      megasync = {
        enable = true;
        users = [ "alex" ];
      };
      sets = {
        media.enable = true;
      };
    };
    games = {
      prism-launcher = {
        enable = true;
        users = [ "alex" ];
      };
    };
    security = {
      sandbox.enable = true;
    };
  };

  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    home = "/home/alex";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
    ];
  };

  users.users.nicklor = {
    isNormalUser = true;
    description = "nicklor";
    home = "/home/nicklor";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_nicklor_passwordHash.path;
    extraGroups = [
      "networkmanager"
      "kvm"
      "wheel"
    ];
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
  };

  programs.firefox.enable = true; # Install firefox.

  xdg.mime.predefined.enable = true;

  boot.kernelParams = [
    "video=HDMI-A-1:1920x1080@83"
  ];

  services.lact.settings = {
    version = 5;
    daemon = {
      log_level = "info";
      admin_group = "wheel";
      disable_clocks_cleanup = false;
    };
    apply_settings_timer = 5;
    gpus = {
      "1002:7550-1043:0613-0000:03:00.0" = {
        fan_control_enabled = false;
        pmfw_options = {
          zero_rpm = true;
        };
        performance_level = "auto";
        max_memory_clock = 1350;
        voltage_offset = -100;
      };
    };
    profiles = {
      MANAGED = {
        gpus = {
          "1002:7550-1043:0613-0000:03:00.0" = {
            fan_control_enabled = false;
            pmfw_options = {
              zero_rpm = true;
            };
            performance_level = "auto";
            max_memory_clock = 1350;
            voltage_offset = -100;
          };
        };
      };
    };
    current_profile = "MANAGED";
    auto_switch_profiles = false;
  };
}
