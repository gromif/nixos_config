# Utils - Media


{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    exiftool # ExifTool is a platform-independent Perl library plus a command-line application for reading, writing and editing meta information in a wide variety of files
    ffmpeg
    flac # Library and tools for encoding and decoding the FLAC lossless audio file format
    sox # Sample Rate Converter for audio
    imagemagick # Software suite to create, edit, compose, or convert bitmap images
    libjxl
  ];
}
