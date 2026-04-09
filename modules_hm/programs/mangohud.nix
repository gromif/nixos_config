{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.mangohud;
  load_enabled = true;
  load_values = [
    50
    90
  ];
  load_colors = [
    "FFFFFF"
    "FFAA7F"
    "CC0000"
  ];
in
{
  options.hmfiles.programs.mangohud = {
    enable = mkEnableOption "mangohud service";
  };

  config = mkIf (cfg.enable) {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;

      settings = {
        preset = 3;

        # SYSTEM
        vram = true;
        swap = true;

        # GPU
        gpu_load_change = load_enabled;
        gpu_load_value = load_values;
        gpu_load_color = load_colors;
        throttling_status = true;

        # CPU
        cpu_temp = true;
        cpu_power = true;
        cpu_load_change = load_enabled;
        cpu_load_value = load_values;
        cpu_load_color = load_colors;

        # Limit
        fps_limit = [ 90 ];
        show_fps_limit = true;

        # Other
        position = "top-right";
        no_display = true; # Disable / hide the hud by default
        display_server = true;
        vulkan_driver = true;
        wine = true;
        winesync = true;
        frame_timing = true;
        present_mode = true;

        # Background
        background_alpha = "0.6";
        round_corners = 5;
      };
    };
  };
}
