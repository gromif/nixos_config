{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  name = "ns";
  cfg = config.hmfiles.programs.scripts."${name}";
  runtimeInputs = with pkgs; [
    fzf
    nix-search-tv
  ];
  nsi = pkgs.writeShellApplication {
    name = "nsi";
    inherit runtimeInputs;
    text = ''
      nix-search-tv print | fzf --preview 'nix-search-tv preview {}' +s -e --header="np | hm" --header-border=rounded
    '';
  };
  ns = pkgs.writeShellApplication {
    inherit name;
    inherit runtimeInputs;
    text = ''
      nix-search-tv print | fzf --preview 'nix-search-tv preview {}' +s -e --header="np | hm" --header-border=rounded
    '';
  };
in
{
  options.hmfiles.programs.scripts."${name}" = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include a helper-script to enable nixpkgs fuzzy search";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      ns
      nsi
    ];
  };
}
