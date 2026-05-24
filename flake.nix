# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    impermanence.url = "github:nix-community/impermanence";

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops-nix-unstable = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix-stable = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixos-avf = {
      url = "github:nix-community/nixos-avf";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      impermanence,
      sops-nix-stable,
      sops-nix-unstable,
      home-manager-stable,
      home-manager-unstable,
      nixos-avf,
    }:
    let
      system = "x86_64-linux";
      sharedModules = [
        impermanence.nixosModules.impermanence
        sops-nix-unstable.nixosModules.sops
        ./nixfiles.nix
      ];
    in
    {
      nixosConfigurations = {
        apollo = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = sharedModules ++ [
            ./hosts/apollo
            ./modules/boot/systemd.nix
            ./modules/mimetypes.nix
            ./modules/services/unarchiver.nix
            ./modules/scripts
            home-manager-unstable.nixosModules.home-manager
          ];
        };
        mercury = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          modules = sharedModules ++ [
            ./hosts/mercury
            ./modules/boot/grub2.nix
            ./modules/scripts/maintainance.nix
            ./modules/services/qbittorrent.nix
            ./modules/services/slskd.nix
          ];
        };
        moon = nixpkgs-stable.lib.nixosSystem {
          system = "aarch64-linux";
          modules = sharedModules ++ [
            nixos-avf.nixosModules.avf
            ./hosts/moon

            ./modules/scripts
          ];
        };
      };
    };
}
