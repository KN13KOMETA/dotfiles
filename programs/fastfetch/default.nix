let
  fetchimg = ./gb3764659.webp;
in
{ config, pkgs, ... }:
{
  enable = true;
  settings = builtins.fromJSON (
    builtins.replaceStrings
      [
        "%FETCHIMG_PATH%"
        "%FETCHIMG_NAME%"
      ]
      [
        (builtins.toString fetchimg)
        (builtins.baseNameOf fetchimg)
      ]
      (builtins.readFile ./kometa.jsonc)
  );
}
