# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    impermanence.url = "github:nix-community/impermanence";
    #flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, nixpkgs-master, impermanence, sops-nix, home-manager, lsfg-vk-flake,
    #flatpaks,
    ... 
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-master = nixpkgs-master.legacyPackages.${system};
  in {
    nixosConfigurations.apollo = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit pkgs-master;
      };
      modules = [
        impermanence.nixosModules.impermanence
        sops-nix.nixosModules.sops
        lsfg-vk-flake.nixosModules.default
        #flatpaks.nixosModules.nix-flatpak
        
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.alex = ./home;
            extraSpecialArgs = {
              inherit pkgs-master;
            };
          };
        }
      ];
    };
  };
}
