{
  lib,
  ...
}:

with lib;

{
  options.nixfiles.preset = mkOption {
    type = types.enum [
      "none"
      "server"
      "desktop"
    ];
    default = "none";
  };
}
