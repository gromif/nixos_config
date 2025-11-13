# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, impermanence, sops-nix, home-manager }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      apollo = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops

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
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alex = ./home;
            };
          }
        ];
      };
      mercury = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops

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
          ./modules/security/sandbox
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
