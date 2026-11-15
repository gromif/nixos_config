{ lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      mpd = prev.mpd.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ final.wavpack ];
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.wavpack ];
        mesonFlags = old.mesonFlags ++ [ "-Dwavpack=enabled" ];
      });
    })
  ];
}
