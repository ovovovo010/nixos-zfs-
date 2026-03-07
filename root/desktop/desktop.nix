{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  programs.hyprland.enable = true;
  services.desktopManager.gnome.enable = true;
}
