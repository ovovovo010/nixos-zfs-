{pkgs, inputs, ...}: {
  imports = [
    ./home/packages.nix
    ./home/hyprland.nix
    ./home/fonts.nix
    ./home/steam.nix
    ./home/nushell.nix
    ./home/rofi.nix
    ./home/mako.nix
    ./home/zen.nix
    ./home/neovim.nix
    ./home/cursor.nix
    ./home/kitty.nix
    ./home/qt.nix
    ./home/gtk.nix
    ./home/spicetify.nix
    ./home/eww.nix
    ./home/obs.nix
    ./home/lact.nix
    ./home/fcitx5.nix
    ./home/openbox.nix
    ./home/wlogout.nix
    ./home/swaylock.nix
  ];

  home.username = "eric";
  home.homeDirectory = "/home/eric";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    FLAKE = "/home/eric/nixos-config";
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
