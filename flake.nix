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
  in {
    nixosConfigurations = {
      apollo = let
        pkgs = nixpkgs.legacyPackages.${system};
      in nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          impermanence.nixosModules.impermanence
          sops-nix-unstable.nixosModules.sops

          {
            system.stateVersion = "25.11";
            time.timeZone = "Europe/Kyiv";
            networking.hostName = "apollo";
          }
          ./hosts/apollo
          ./modules/boot/systemd.nix
          ./modules/kernel/latest.nix
          ./modules/kernel/modules/v4l2loopback.nix
          ./modules/console.nix
          ./modules/zram.nix
          ./modules/nix/common.nix
          ./modules/impermanence.nix
          ./modules/zsh.nix
          ./modules/security/common.nix
          ./modules/security/disable_firewall.nix
          ./modules/security/luks.nix
          ./modules/security/sandbox
          ./modules/hardware/common.nix
          ./modules/hardware/fstrim.nix
          ./modules/hardware/mesa.nix
          # ./modules/appimage.nix
          ./modules/network.nix
          ./modules/sound/common.nix
          ./modules/sound/pipewire.nix
          ./modules/locale/en_GB.nix
          ./modules/codecs.nix
          ./modules/desktop/common.nix
          ./modules/desktop/gnome/common.nix
          ./modules/desktop/gnome/services/theme-changer.nix
          ./modules/desktop/gnome/services/random-background.nix
          ./modules/mimetypes.nix
          ./modules/fonts/common.nix
          ./modules/virt/libvirtd.nix
          ./modules/virt/docker.nix
          ./modules/utils/common.nix
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
          ./modules/programs/git.nix
          ./modules/programs/redroid.nix
          ./modules/programs/openrgb
          ./modules/sops.nix
          ./secrets/primary
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
        pkgs = nixpkgs-stable.legacyPackages.${system};
      in nixpkgs-stable.lib.nixosSystem {
        inherit system;
        modules = [
          impermanence.nixosModules.impermanence
          sops-nix-stable.nixosModules.sops

          {
            system.stateVersion = "25.05";
            time.timeZone = "Europe/Kyiv";
            networking.hostName = "mercury";
          }
          ./hosts/mercury
          ./modules/boot/grub2.nix
          ./modules/kernel/lts.nix
          ./modules/console.nix
          ./modules/zram.nix
          ./modules/nix/common.nix
          ./modules/impermanence.nix
          ./modules/zsh.nix
          ./modules/security/common.nix
          # ./modules/security/sandbox
          ./modules/hardware/common.nix
          ./modules/network.nix
          ./modules/services/openssh.nix
          ./modules/locale/en_GB.nix
          ./modules/fonts/common.nix
          ./modules/utils/common.nix
          ./modules/scripts/impermanence.nix
          ./modules/scripts/maintainance.nix
          ./modules/programs/git.nix
          ./modules/services/qbittorrent.nix
          ./modules/sops.nix
          ./secrets/mercury
        ];
      };
    };
  };
}
