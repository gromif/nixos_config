# Home - Mangohud


{ ... }:

let
  load_enabled = true;
  load_values = [ 50 90];
  load_colors = [ "FFFFFF" "FFAA7F" "CC0000" ];
in
{
  # MangoHud
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    
    settings = {
      # GPU
      gpu_temp = true;
      
      gpu_load_change = load_enabled;
      gpu_load_value = load_values;
      gpu_load_color = load_colors;

      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_voltage = true;
      
      gpu_fan = true;
      throttling_status = true;
      
      # CPU
      cpu_temp = true;
      cpu_mhz = true;
      
      cpu_load_change = load_enabled;
      cpu_load_value = load_values;
      cpu_load_color = load_colors;
      
      # Sensors
      vram = true;
      ram = true;
      fps = true;
      
      # Limit
      fps_limit = [ 90 ];
      toggle_fps_limit = "F1";
      show_fps_limit = true;
      blacklist = [
        "lact"
        "nautilus"
        "kgx"
      ];
      
      # Other
      vulkan_driver = true;
      wine = true;
      frame_timing = true;
      position = "top-right";
      font_size = 24;
      
      # Background
      background_alpha = "0.6";
      round_corners = 5;
      background_color = "000000";
    };
  };
}
