# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";
  };
  outputs = inputs@{ self, nixpkgs, flatpaks, ... }: {
    nixosConfigurations.apollo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        flatpaks.nixosModules.nix-flatpak
        
        ./configuration.nix
      ];
    };
  };
}
