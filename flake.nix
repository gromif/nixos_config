# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
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

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };
  outputs = inputs@{ self,
    nixpkgs, nixpkgs-stable,
    impermanence,
    sops-nix-stable,
    sops-nix-unstable,
    home-manager-stable,
    home-manager-unstable
  }:
  let
    system = "x86_64-linux";
    sharedModules = [
      impermanence.nixosModules.impermanence
      sops-nix-unstable.nixosModules.sops

      ./modules/impermanence
      ./modules/console.nix
      ./modules/zram.nix
      ./modules/nix/common.nix
      ./modules/zsh.nix
      ./modules/security/common.nix
      ./modules/fonts/common.nix
      ./modules/utils/common.nix
      ./modules/programs/git.nix
    ];
  in {
    nixosConfigurations = {
      apollo = let
        preferences = builtins.fromJSON (builtins.readFile ./preferences/apollo.json);
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit preferences; };
        modules = sharedModules ++ [
          ./hosts/apollo
          ./secrets/apollo
          ./modules/sops.nix
          ./modules/boot/systemd.nix
          ./modules/kernel/latest.nix
          ./modules/kernel/modules/v4l2loopback.nix
          ./modules/security/luks.nix
          ./modules/security/sandbox
          ./modules/hardware/common.nix
          ./modules/network.nix
          ./modules/services/openssh.nix
          ./modules/sound/common.nix
          ./modules/sound/pipewire.nix
          ./modules/locale/en_GB.nix
          ./modules/codecs.nix
          ./modules/desktop/common.nix
          ./modules/desktop/gnome/common.nix
          ./modules/desktop/gnome/services/theme-changer.nix
          ./modules/desktop/gnome/services/random-background.nix
          ./modules/mimetypes.nix
          ./modules/virt/libvirtd.nix
          ./modules/virt/docker.nix
          ./modules/utils/compression.nix
          ./modules/utils/media.nix
          ./modules/games/common.nix
          ./modules/services/wallpapers-optimiser.nix
          ./modules/services/screenshot-optimiser.nix
          ./modules/services/unarchiver.nix
          ./modules/scripts
          ./modules/programs/android-studio.nix
          ./modules/programs/gapless.nix
          ./modules/programs/euphonica.nix
          ./modules/programs/bottles.nix
          ./modules/programs/redroid.nix
          home-manager-unstable.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alex = ./home;
            };
          }
        ];
      };
      mercury = let
        preferences = builtins.fromJSON (builtins.readFile ./preferences/mercury.json);
      in nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit preferences; };
        modules = sharedModules ++ [
          ./hosts/mercury
          ./secrets/mercury
          ./modules/sops.nix
          ./modules/boot/grub2.nix
          ./modules/kernel/lts.nix
          # ./modules/security/sandbox
          ./modules/hardware/common.nix
          ./modules/network.nix
          ./modules/services/openssh.nix
          ./modules/locale/en_GB.nix
          ./modules/scripts/maintainance.nix
          ./modules/services/qbittorrent.nix
        ];
      };
    };
  };
  nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = import nixpkgs { system = "aarch64-linux"; };
    modules = [
      ./hosts/polaris
    ];
  };
}
