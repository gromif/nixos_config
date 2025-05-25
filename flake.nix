# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.apollo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        
        ./configuration.nix
      ];
    };
  };
}
