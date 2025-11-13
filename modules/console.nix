# Console

{ config, pkgs, ... }:

{
  console = {
    # earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "ter-128b.psf.gz";
  };
}
