{
  lib,
  ...
}:

with lib;

{
  options.hmfiles.programs.scripts.group.audio = mkEnableOption "audio scripts group";
}
