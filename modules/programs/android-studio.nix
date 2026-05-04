# Programs - Android Studio

{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.programs.android-studio;
  cfgSandbox = config.nixfiles.security.sandbox;

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
  pkgAppData = (if (cfg.sandbox && cfgSandbox.enable) then "%h/.bwrapper/android-studio" else "%h");
  tmpFilesRules = map (f: "R \"${pkgAppData}/${f}\" - - - - -") [
    "cache/Google/*/tmp/"
    "local/share/kotlin"
    "gradle/daemon/"
    "gradle/.tmp/"
  ];
  pkg = (pkgs.android-studio.withSdk android.androidsdk);
  pkg-wrapped = pkgs.mkBwrapper {
    imports = [ pkgs.bwrapperPresets.desktop ];
    app = {
      package = (pkgs.android-studio.withSdk android.androidsdk);
      id = "com.google.AndroidStudio";
    };
    fhsenv.opts = {
      unshareUser = true;
      unshareUts = true;
      unshareCgroup = true;
    };
    sockets = {
      x11 = false;
      pulseaudio = false;
    };
    mounts = {
      read = [
        "$HOME/.ssh"
      ];
      readWrite = [
        "$HOME/Projects"
      ];
      sandbox = [
        {
          name = "android";
          path = "$HOME/.android";
        }
        {
          name = "m2";
          path = "$HOME/.m2";
        }
        {
          name = "java";
          path = "$HOME/.java";
        }
        {
          name = "skiko";
          path = "$HOME/.skiko";
        }
        {
          name = "gradle";
          path = "$HOME/.gradle";
        }
      ];
    };
  };
in
{
  options.nixfiles.programs.android-studio = {
    enable = mkEnableOption "Android Studio IDE";
    users = mkOption {
      type = types.listOf types.str;
      description = "User-profile list to include the package";
    };
    sandbox = mkEnableOption "BubbleWrap sandbox feature for this package";
  };

  config = mkMerge [
    ({
      nixfiles.programs.android-studio.sandbox = mkDefault true;
    })
    (mkIf cfg.enable {
      # Accept the license
      nixpkgs.config.android_sdk.accept_license = true;

      # Set up ANDROID_HOME variable (IDE uses it to find AndroidSDK)
      environment.variables.ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";

      # Set up Tmpfiles rules
      systemd.user.tmpfiles.rules = tmpFilesRules;

      # Set up the package
      users.users = builtins.listToAttrs (
        map (u: {
          name = u;
          value = {
            packages = with pkgs; [
              (if (cfg.sandbox && cfgSandbox.enable) then pkg-wrapped else pkg)
              # (pkgs.androidStudioPackages.canary.withSdk android.androidsdk)
              android.androidsdk
              android-tools
            ];
          };
        }) cfg.users
      );
    })
  ];
}
