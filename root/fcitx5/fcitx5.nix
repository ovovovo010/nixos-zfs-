{pkgs, ...}: {
  # 确保主题文件可访问
  environment.pathsToLink = ["/share/fcitx5"];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      kdePackages.fcitx5-chinese-addons
      fcitx5-table-extra
      fcitx5-chewing
      fcitx5-lua
      (catppuccin-fcitx5.override {
        # 显式指定 flavor
        flavor = "mocha";
        accent = "lavender";
      })
      fcitx5-rime
      rime-data
    ];

    fcitx5.settings = {
      addons = {
        classicui.globalSection = {
          "Vertical Candidate List" = "True";
          "WheelForPaging" = "True";
          "Font" = "Sarasa Gothic TC 12";
          "MenuFont" = "Sarasa Gothic TC 12";
          "TrayFont" = "Sarasa Gothic TC Bold 10";
          "TrayOutlineColor" = "#000000";
          "TrayTextColor" = "#ffffff";
          "PreferTextIcon" = "False";
          "ShowLayoutNameInIcon" = "True";
          "UseInputMethodLanguageToDisplayText" = "True";

          # 修正主题名称 - 先试试这个
          "Theme" = "catppuccin-mocha-lavender"; # 全小写
          # 如果上面的不行，试试这个：
          # "Theme" = "Catppuccin-Mocha";

          "DarkTheme" = "catppuccin-mocha-lavender";
          "UseDarkTheme" = "False";
          "FollowSystemDarkMode" = "False";
          "UseAccentColor" = "True";
        };
      };
    };
  };
}
