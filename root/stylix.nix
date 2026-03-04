{ inputs, pkgs, lib, ... }: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    
    image = ./wallpaper.png;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
    
    # 明确告诉 stylix 不要管理哪些目标
    targets = {
      # 禁用 greetd 管理，因为你已经手动配置了
      greetd.enable = false;
      # 禁用 qt 管理，让 home-manager 处理
      qt.enable = false;
    };
  };
  
  # iconTheme 要放在 stylix 外面（你的注释是对的）
  iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
    light = "Papirus-Light";
  };
}
