# /etc/nixos/root/stylix.nix
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    enableReleaseChecks = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";

    image = ./mika-wallpaper.png;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
    cursor = {
      name = "catppuccin-macchiato-pink-cursors"; # 確保小寫
      package = pkgs.catppuccin-cursors.macchiatoPink;
      size = 24;
    };
  };
}
