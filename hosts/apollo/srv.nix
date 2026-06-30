{ pkgs, ... }:

let
  srv-socks = pkgs.writeShellApplication {
    name = "srv-socks";
    text = ''
      KEYS=(
        "/system/proxy/mode"
        "/system/proxy/socks/host"
        "/system/proxy/socks/port"
      )

      declare -A ORIGINAL

      for key in "''${KEYS[@]}"; do
        ORIGINAL["''$key"]="$(dconf read "''$key")"
      done

      restore() {
        echo "Restoring..."
        for key in "''${KEYS[@]}"; do
            dconf write "''$key" "''${ORIGINAL[$key]}"
        done
      }

      trap restore EXIT INT TERM

      dconf write "''${KEYS[0]}" "'manual'"
      dconf write "''${KEYS[1]}" "'localhost'"
      dconf write "''${KEYS[2]}" "1080"

      echo "Running... Ctrl+C to stop"

      ssh ua-mercury-socks -v
    '';
  };
in
{
  environment.systemPackages = [ srv-socks ];
}
