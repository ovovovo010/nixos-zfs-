# /etc/nixos/root/stylix.nix（系統層，只留必要的最小配置）
{ inputs, pkgs, lib, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    
    # 系統層只需要指定圖片（因為登入管理器需要）
    image = ./wallpaper.png;
    
    # 明確告訴 stylix 不要管理哪些目標（由 home-manager 管理）
    targets = {
    qt.enable = false;
    mako.enable = false;
    rofi.enable = false;
    }
  };
  
  # 確保壁紙能被 greeter 用戶讀取
  users.users.greeter.extraGroups = [ "users" ];
}
