{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # 可以在這裡引用共用模組
  ];

  home.username = "user1";
  home.homeDirectory = "/home/user1";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  # 這裡放 user1 專屬的 home.packages 或 program 設定
  home.packages = with pkgs; [
    wofi
    kitty
    waybar
    neovim
  ];
}
