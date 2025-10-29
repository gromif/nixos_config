# User - Programs - Android Studio


{ config, pkgs, ... }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
    buildToolsVersions = [
      "35.0.0"
      "35.0.1"
      "36.0.0"
      "latest"
    ];
    platformVersions = [
      "35"
      "36"
    ];
    includeSystemImages = true;
    systemImageTypes = [ "google_apis" ];
    abiVersions = [ "x86_64" ];
    includeEmulator = true;
  };
  tmpFilesRules = map (f: "R \"%h/${f}\" - - - - -") [
    ".cache/Google/*/tmp/"
    ".java"
    ".local/share/kotlin"
    ".m2"
    ".gradle/daemon/"
    ".gradle/.tmp/"
    ".skiko"
  ];
in
{
  # Accept the license
  nixpkgs.config.android_sdk.accept_license = true;
  
  # Set up the package
  environment.systemPackages = with pkgs; [
    (pkgs.android-studio.withSdk android.androidsdk)
    # (pkgs.androidStudioPackages.canary.withSdk android.androidsdk)
    android.androidsdk
  ];
  
  # Set up ANDROID_HOME variable (IDE uses it to find AndroidSDK)
  environment.variables.ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
  
  # Set up Tmpfiles rules
  systemd.user.tmpfiles.rules = tmpFilesRules;
}
