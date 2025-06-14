{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.spicetify];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.starryNight;
  };
}
