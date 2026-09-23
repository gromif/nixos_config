{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    systemd.enable = true;
    settings = {
      font-size = 12;
      font-family = "0xProto Nerd Font";
      theme = "Desert";
      maximize = true;
    };
  };
}
