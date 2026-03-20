{ ... }:

{
  xdg.configFile = {
    "fastfetch/config.jsonc" = {
      force = true;
      source = ../config.jsonc;
    };
  };
}
