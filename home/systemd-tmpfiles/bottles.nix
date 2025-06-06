# SystemD Tmpfiles - Bottles


{ config, pkgs, ... }:

let
  bottlesRoot = ".var/app/com.usebottles.bottles/data/bottles/bottles/";
  bottles = [ "Games" "Izotope-Rx-Studio" ];
  users = [ "steamuser" "alex" ];
  files = [
    "/drive_c/ProgramData/Package Cache"
    
    "/drive_c/Program Files/Internet Explorer"
    "/drive_c/Program Files/Windows NT"
    "/drive_c/Program Files/Windows Media Player"
    "/drive_c/Program Files (x86)/Internet Explorer"
    "/drive_c/Program Files (x86)/Windows NT"
    "/drive_c/Program Files (x86)/Windows Media Player"
    
    "/drive_c/windows/Installer"
    "/drive_c/windows/logs"
    "/drive_c/windows/temp"
  ];
  userFiles = [
    "/Temp"
    "/AppData/Local/CEF"
    "/AppData/Local/CrashReportClient"
    "/AppData/Local/Microsoft"
    "/AppData/Local/NVIDIA Corporation"
    "/AppData/Local/Telemetry"
    "/AppData/Local/Temp"
    
    "/AppData/LocalLow/Microsoft"
  ];
  
  rules = builtins.concatMap (b:
    let
      systemPaths = map (f: "R \"%h/${bottlesRoot}${b}${f}\" - - - - -") files;
      userPaths = builtins.concatMap (u:
        map (f: "R \"%h/${bottlesRoot}${b}/drive_c/users/${u}${f}\" - - - - -") userFiles
      ) users;
    in systemPaths ++ userPaths
  ) bottles;
in
{
  systemd.user.tmpfiles.rules = rules;
}
