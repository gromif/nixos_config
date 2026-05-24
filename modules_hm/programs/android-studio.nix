{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.hmfiles.programs.android-studio;

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
  pkgAppData = "%h";
  tmpFilesRules = map (f: "R \"${pkgAppData}/${f}\" - - - - -") [
    ".cache/Google/*/tmp/"
    ".local/share/kotlin"
    ".gradle/daemon/"
    ".gradle/.tmp/"
  ];
  pkg = (pkgs.android-studio.withSdk android.androidsdk);
in
{
  options.hmfiles.programs.android-studio = {
    enable = mkEnableOption "Android Studio IDE";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # Set up ANDROID_HOME variable (IDE uses it to find AndroidSDK)
      home.sessionVariables.ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";

      # Set up Tmpfiles rules
      systemd.user.tmpfiles.rules = tmpFilesRules;

      # Set up the package
      home.packages = with pkgs; [
        pkg
        # (pkgs.androidStudioPackages.canary.withSdk android.androidsdk)
        android.androidsdk
        android-tools
      ];
    })
  ];
}
