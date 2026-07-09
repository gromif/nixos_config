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
      systemd.user.sessionVariables = {
        # Set up ANDROID_HOME variable (IDE uses it to find AndroidSDK)
        ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";

        # Gradle
        GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";

        # Android SDK/user config
        ANDROID_USER_HOME = "${config.xdg.dataHome}/android";

        # Kotlin
        KOTLIN_HOME = "${config.xdg.dataHome}/kotlin";

        # Maven
        MAVEN_USER_HOME = "${config.xdg.dataHome}/maven";

        # Skiko / Compose Desktop
        SKIKO_CACHE_DIR = "${config.xdg.cacheHome}/skiko";

        # Java
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
      };

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
