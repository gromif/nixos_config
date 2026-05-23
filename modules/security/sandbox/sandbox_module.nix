{
  lib,
  ...
}:

with lib;

{
  options.nixfiles.security.sandbox.enable = mkEnableOption "BubbleWrap sandbox feature";
}
