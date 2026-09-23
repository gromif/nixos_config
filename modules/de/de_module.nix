{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.de;
  codecs = with pkgs; [
    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-rs # Rust implementation
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
  ];
in
{
  options.nixfiles.de = {
    enable = mkEnableOption "basic support for Desktop Environments";
    includeEssentials = mkEnableOption "common settings and packages";
    gnome.enable = mkEnableOption "the GNOME desktop environment";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nixfiles.de = {
        includeEssentials = mkDefault true;
      };
      services.speechd.enable = mkForce false; # We don't need it
    }
    (mkIf cfg.includeEssentials {
      environment.systemPackages =
        with pkgs;
        [
          tela-icon-theme
        ]
        ++ codecs;
      fonts.packages =
        with pkgs;
        [
          noto-fonts-color-emoji
          inter
          monocraft
        ]
        ++ (with pkgs.nerd-fonts; [
          _0xproto
          adwaita-mono
          caskaydia-cove
          caskaydia-mono
          dejavu-sans-mono
          departure-mono
          droid-sans-mono
          fantasque-sans-mono
          fira-code
          fira-mono
          googlesanscode
          hack
          jetbrains-mono
          liberation
          martian-mono
          roboto-mono
          sauce-code-pro
          shure-tech-mono
          space-mono
          symbols-only
          ubuntu
          ubuntu-mono
          ubuntu-sans
        ]);
    })

    (mkIf cfg.gnome.enable {
      services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
      environment = {
        systemPackages = with pkgs; [
          ghostty
          zenity
          # Theming
          kdePackages.ocean-sound-theme
          adw-gtk3
        ];
        gnome.excludePackages = with pkgs; [
          orca
          decibels
          file-roller
          geary
          epiphany
          gnome-contacts
          gnome-music
          gnome-software
          gnome-system-monitor
          gnome-connections
          gnome-tour
          simple-scan
          yelp
        ];
        # Fix for Nautilus media details page
        variables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (codecs);
      };
      # Enable numlock in gdm.
      programs.dconf.profiles.gdm.databases = [
        {
          settings."org/gnome/desktop/peripherals/keyboard".numlock-state = true;
        }
      ];
    })
  ]);
}
