# SystemD Tmpfiles - Bottles


{ config, pkgs, ... }:

let
  bottlesRoot = ".local/share/bottles/bottles";
  relativePaths = [
    "ProgramData/Package Cache/*"
    
    "Program Files/Internet Explorer/*"
    "Program Files/Windows NT/*"
    "Program Files/Windows Media Player/*"
    "Program Files (x86)/Internet Explorer/*"
    "Program Files (x86)/Windows NT/*"
    "Program Files (x86)/Windows Media Player/*"
    
    "windows/Installer/*"
    "windows/logs/*"
    "windows/temp/*"
    
    "users/*/Temp/*"
    "users/*/AppData/Local/CEF/*"
    "users/*/AppData/Local/CrashReportClient/*"
    "users/*/AppData/Local/Microsoft/*"
    "users/*/AppData/Local/NVIDIA Corporation/*"
    "users/*/AppData/Local/Telemetry/*"
    "users/*/AppData/Local/Temp/*"
    
    "users/*/AppData/LocalLow/Microsoft/*"
  ];
  
  rules = map (f: 
    "R \"%h/${bottlesRoot}/*/drive_c/${f}\" - - - - -"
  ) relativePaths;
in
{
  systemd.user.tmpfiles.rules = rules;
}
