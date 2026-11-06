{ ... }:

{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        version = "0.99.8-beta";

        src = prev.fetchFromGitHub {
          owner = "htkhiem";
          repo = "euphonica";
          tag = "v${version}";
          hash = "sha256-AKM/gyvndgq2rnusoI/TU3C9hIplymQH/RxgBFE42Rs=";
          fetchSubmodules = true;
        };
      in
      {
        euphonica = prev.euphonica.overrideAttrs (old: {
          inherit version src;

          cargoDeps = prev.rustPlatform.fetchCargoVendor {
            inherit (old) pname;
            inherit version src;
            hash = "sha256-ppWKQkQu37HNvG37I9BEO+MA/pU29kZ7w3KGdzXLbVM=";
          };
        });
      }
    )
  ];
}
