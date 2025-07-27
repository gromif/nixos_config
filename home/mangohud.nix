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
      preset = 3;
      
      # GPU
      gpu_load_change = load_enabled;
      gpu_load_value = load_values;
      gpu_load_color = load_colors;
      throttling_status = true;
      
      # CPU
      cpu_load_change = load_enabled;
      cpu_load_value = load_values;
      cpu_load_color = load_colors;
      
      # Limit
      fps_limit = [ 90 ];
      show_fps_limit = true;
      
      # Other
      no_display = true; # Disable / hide the hud by default
      #vulkan_driver = true;
      #wine = true;
      #frame_timing = true;
      
      # Background
      background_alpha = "0.6";
      round_corners = 5;
    };
  };
}
