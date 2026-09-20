{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.gaming.hypervisor;
in
{
  options.nixfiles.gaming.hypervisor = {
    enable = mkEnableOption "support Hupervisor bypass";
    type = mkOption {
      type = types.enum [
        "runtime-parameter"
        "kernel-patch"
      ];
      default = "kernel-patch";
      description = "Which Hypervisor bypass method to use";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    (mkIf (cfg.type == "runtime-parameter") {
      boot.kernelParams = [
        "clearcpuid=umip" # Trade-off: Hypervisor via Proton
      ];
    })
    (mkIf (cfg.type == "kernel-patch") {
      boot.kernelPatches = [
        {
          name = "hypervisor-umip-dummy-limit-static";
          patch = ./.umip_dummyLimit_static_value.patch;
        }
      ];
    })
  ]);
}
