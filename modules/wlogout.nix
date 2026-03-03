{ config, pkgs, lib, ... }:

let
  # 從 Stylix 獲取顏色變數 (帶 # 前綴)
  colors = config.lib.stylix.colors.withHashtag;
  
  # 可選：定義一個強調色，這裡使用你的 Hyprland active border 色調的近似值
  # 如果你希望直接從 Stylix 獲取強調色，可以使用 colors.base0D
  accent-color = colors.base0D; # 通常代表 "強調" 的顏色
  
  # 定義按鈕佈局
  layout = {
    label = [
      {
        # 鎖定
        name = "lock";
        text = "Lock";
        action = "hyprlock";  # 根據你的鎖定工具調整，也可能是 swaylock
        keybind = "l";
        # circle = true;  # 如果你想要圓形按鈕，可以取消註解
      }
      {
        # 登出
        name = "logout";
        text = "Logout";
        action = "hyprctl dispatch exit";
        keybind = "e";
      }
      {
        # 重新啟動
        name = "reboot";
        text = "Reboot";
        action = "systemctl reboot";
        keybind = "r";
      }
      {
        # 關機
        name = "shutdown";
        text = "Shutdown";
        action = "systemctl poweroff";
        keybind = "s";
      }
    ];
  };
  
  # 將佈局轉換為 wlogout 需要的 JSON 格式
  layoutJson = pkgs.writeText "wlogout-layout.json" (builtins.toJSON layout);
  
  # 建立 CSS 樣式，從 Stylix 動態生成
  styleCss = pkgs.writeText "wlogout-style.css" ''
    /* 從 Stylix 動態生成的顏色變數 */
    @define-color background ${colors.base00};
    @define-color background-alt ${colors.base01};
    @define-color foreground ${colors.base05};
    @define-color selected ${accent-color};
    @define-color border ${colors.base03};
    @define-color hover-bg ${colors.base02};
    @define-color text-color ${colors.base05};

    * {
      background-image: none;
      box-shadow: none;
    }

    window {
      background-color: alpha(@background, 0.85);
      backdrop-filter: blur(10px);  /* 可選：毛玻璃效果，與你的 Hyprland blur 呼應 */
    }

    button {
      color: @text-color;
      background-color: alpha(@background-alt, 0.7);
      border-style: solid;
      border-width: 2px;
      border-color: @border;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
      border-radius: 20px;  /* 圓角，與你的 Hyprland rounding 20 一致 */
      margin: 20px;
      padding: 20px;
      font-family: "${config.stylix.fonts.sansSerif.name}";
      font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
      font-weight: normal;
      outline-style: none;
      transition: all 0.2s ease;  /* 平滑過渡 */
    }

    button:focus, button:active, button:hover {
      background-color: alpha(@selected, 0.3);
      border-color: @selected;
      color: @selected;
      background-size: 30%;  /* 懸停時圖標稍微放大 */
    }

    /* 為各個按鈕設定圖標（使用你系統圖標主題的圖示） */
    #lock {
      background-image: image(-gtk-icontheme("system-lock-screen-symbolic"));
    }

    #logout {
      background-image: image(-gtk-icontheme("system-log-out-symbolic"));
    }

    #reboot {
      background-image: image(-gtk-icontheme("system-reboot-symbolic"));
    }

    #shutdown {
      background-image: image(-gtk-icontheme("system-shutdown-symbolic"));
    }

    /* 如果你想要更多按鈕，可以繼續添加 */
    #suspend {
      background-image: image(-gtk-icontheme("system-suspend-symbolic"));
    }

    #hibernate {
      background-image: image(-gtk-icontheme("system-hibernate-symbolic"));
    }
  '';
in
{
  home.packages = with pkgs; [
    wlogout
    # 確保有 librsvg 來載入 SVG 圖標 [citation:1]
    librsvg
  ];

  # 確保 GDK 可以載入 SVG 圖標 [citation:1]
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  # 配置 wlogout
  programs.wlogout = {
    enable = true;
    
    # 設定佈局檔案
    layout = layoutJson;
    
    # 設定樣式檔案
    style = styleCss;
  };

  ];
}
