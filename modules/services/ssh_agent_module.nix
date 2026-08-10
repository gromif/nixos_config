{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.nixfiles.services.sshAgent;
in
{
  options.nixfiles.services.sshAgent = {
    enable = mkEnableOption "SSH Agent service";
    userKeys = mkOption {
      type = types.attrsOf (types.listOf types.path);
      default = { };
      description = ''
        SSH private key paths to load into each user's SSH agent.
        The attribute name is the username.
      '';
    };
  };

  config = mkIf (cfg.enable) {
    systemd.user.services.load-keys-to-sshAgent = {
      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = getExe (
          pkgs.writeShellApplication {
            name = "load-sops-sshKeys";
            runtimeInputs = with pkgs; [ openssh ];
            text = ''
              case "$USER" in
            ''
            + concatStringsSep "\n" (
              mapAttrsToList (user: keys: ''
                ${user})
                  ssh-add -D
                  ${concatMapStringsSep "\n" (key: ''
                    ssh-add "${key}"
                  '') keys}
                  ;;
              '') cfg.userKeys
            )
            + ''
                *)
                  echo "No SSH keys configured for user: $USER" >&2
                  exit 1
                  ;;
              esac
            '';
          }
        );
      };
    };
  };
}
