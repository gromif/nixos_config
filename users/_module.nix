{
  config,
  lib,
  ...
}:

with lib;

{
  options.nixfiles.users = mkOption {
    type = types.listOf types.str;
    default = [ ];
    description = "Include predefined user configurations by id";
  };
}
