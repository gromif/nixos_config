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
  tmpFilesRules = map (f: "R \"%h/${f}\" - - - - -") [
    ".cache/Google/*/tmp/"
    ".java"
    ".local/share/kotlin"
    ".m2"
    ".gradle/daemon/"
    ".gradle/.tmp/"
    ".skiko"
  ];

  pkg_name = "android-studio";
  pkg = (pkgs.android-studio.withSdk android.androidsdk);
  home = "$HOME/.sandbox/${pkg_name}";

  pkg-wrapper = pkgs.writeShellApplication {
    name = pkg_name;
    runtimeInputs = [ pkg ];
    text = ''
      mkdir -p "${home}/Projects/Android" &> /dev/null
      mkdir -p "${home}/.ssh" &> /dev/null
      bwrap \
      --unshare-ipc --unshare-pid --unshare-cgroup-try \
      --die-with-parent \
      --new-session \
      --ro-bind /nix/store /nix/store \
      --dev-bind /dev /dev \
      --ro-bind /etc /etc \
      --tmpfs /tmp \
      --proc /proc \
      --ro-bind /sys /sys \
      --bind /run /run \
      --bind "${home}" ~ \
      --ro-bind ~/.ssh ~/.ssh \
      --bind ~/Projects/Android ~/Projects/Android -- ${getExe pkg} "$@"
    '';
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
      cfg.sandbox = mkDefault true;
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
          value =
            with pkgs;
            [
              pkg
              # (pkgs.androidStudioPackages.canary.withSdk android.androidsdk)
              android.androidsdk
              android-tools
            ]
            ++ optional (cfg.sandbox && cfgSandbox.enable) pkg-wrapper;
        }) cfg.users
      );
    })
  ];
}
