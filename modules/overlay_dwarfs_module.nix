{ lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      dwarfs = prev.dwarfs.overrideAttrs (old: {
        doCheck = false;
        cmakeFlags =
          (lib.remove "-DWITH_TESTS=ON" (old.cmakeFlags or [ ]))
          ++ [ "-DWITH_TESTS=OFF" ];
      });
    })
  ];
}
