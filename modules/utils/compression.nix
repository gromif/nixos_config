# Utils - Compression


{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
    dwarfs
    p7zip
    unrar
    unzip
  ];
}
