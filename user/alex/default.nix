# User - Alex


{ config, pkgs, lib, ... }:

let
  programsList = builtins.attrNames (builtins.readDir ./programs);
  programs = map (c: ./programs + "/${c}") programsList;
  servicesList = builtins.attrNames (builtins.readDir ./services);
  services = map (c: ./services + "/${c}") servicesList;
in
{
  imports = [
    ./desktop_environment.nix
    ./gaming.nix
    ./mimetypes.nix
    ./virtualisation.nix
  ] ++ programs ++ services;
  
  # ============================================================================================================
  # User
  # ============================================================================================================
  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    home = "/home/alex";
    createHome = true;
    hashedPasswordFile = config.sops.secrets.user_root_passwordHash.path;
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    shell = pkgs.zsh;
  };
  
  environment.systemPackages = with pkgs; [
    megasync
  ];
  
  programs.firefox.enable = true; # Install firefox.
  
  # Set up UDEV rules
  services.udev.packages = with pkgs; [ 
    android-udev-rules # Android
  ];
}
