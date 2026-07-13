{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.bottles;
  bottlesRoot = ".local/share/bottles";
  relativePaths = [
    "ProgramData/Package Cache"

    "Program Files/Internet Explorer"
    "Program Files/Windows NT"
    "Program Files/Windows Media Player"
    "Program Files (x86)/Internet Explorer"
    "Program Files (x86)/Windows NT"
    "Program Files (x86)/Windows Media Player"

    "windows/Installer"
    "windows/logs"
    "windows/temp"

    "users/*/Temp"
    "users/*/AppData/Local/CEF"
    "users/*/AppData/Local/CrashReportClient"
    "users/*/AppData/Local/Microsoft"
    "users/*/AppData/Local/NVIDIA Corporation"
    "users/*/AppData/Local/Telemetry"
    "users/*/AppData/Local/Temp"

    "users/*/AppData/LocalLow/Microsoft"
  ];

  rules = map (f: "R \"%h/${bottlesRoot}/bottles/*/drive_c/${f}/*\" - - - 0 -") relativePaths;

  extraRules = [
    "R \"%h/${bottlesRoot}/temp/*\" - - - 0 -"
    "R \"%h/${bottlesRoot}/*.bak\" - - - 0 -"
    "R \"%h/${bottlesRoot}/*.log\" - - - 0 -"
  ];
in
{
  options.hmfiles.programs.bottles = {
    enable = mkEnableOption "Bottles package";
  };

  config = mkIf cfg.enable {
    # Set up the package
    home.packages = with pkgs; [
      (bottles.override {
        removeWarningPopup = true;
      })
    ];

    # Set up Tmpfiles rules
    # systemd.user.tmpfiles.rules = rules ++ extraRules;
  };
}
