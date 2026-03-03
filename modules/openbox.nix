{ config, pkgs, lib, ... }:

let
  # 從你的 Hyprland 配置中繼承的程式（可直接沿用）
  terminal = "kitty";                # 你使用的終端
  launcher = "rofi -show drun";      # 你使用的應用啟動器
in
{
  # 啟用 Openbox 並提供極簡設定
  services.openbox = {
    enable = true;

    # 主設定檔：只保留最基本的浮動視窗行為，去除所有花俏功能
    configFile = pkgs.writeText "openbox-rc.xml" ''
      <?xml version="1.0"?>
      <openbox_config xmlns="http://openbox.org/3.4/rc">
        <!-- 穩定優先：關閉任何可能干擾的動畫或特效 -->
        <focus>
          <focusNew>yes</focusNew>
          <followMouse>no</followMouse>
          <focusLast>yes</focusLast>
          <raiseOnFocus>yes</raiseOnFocus>
        </focus>

        <!-- 滑鼠：Alt+左鍵移動視窗，Alt+右鍵縮放（與 Hyprland 預設一致） -->
        <mouse>
          <context name="Frame">
            <mousebind button="A-Left" action="Drag">
              <action name="Move"/>
            </mousebind>
            <mousebind button="A-Right" action="Drag">
              <action name="Resize"/>
            </mousebind>
          </context>
          <!-- 桌面右鍵選單 -->
          <context name="Root">
            <mousebind button="Right" action="Press">
              <action name="ShowMenu"><menu>root-menu</menu></action>
            </mousebind>
          </context>
        </mouse>

        <!-- 鍵盤：只保留最基本的關閉視窗與切換視窗，避免與 Hyprland 快捷鍵衝突 -->
        <keyboard>
          <keybind key="A-F4"><action name="Close"/></keybind>
          <keybind key="A-Tab"><action name="NextWindow"/></keybind>
        </keyboard>

        <!-- 應用程式特定規則（可自行加入有問題的程式） -->
        <applications>
          <!-- 範例：強制 Steam 永遠浮動且保有邊框
          <application class="Steam">
            <decor>yes</decor>
            <focus>yes</focus>
          </application>
          -->
        </applications>

        <!-- 主題：保持簡單乾淨 -->
        <theme>
          <name>Clearlooks</name>
          <titleLayout>NLIMC</titleLayout>
          <keepBorder>yes</keepBorder>
          <animateIconify>no</animateIconify>
        </theme>
      </openbox_config>
    '';

    # 右鍵選單：整合你常用的終端機與啟動器
    menuFile = pkgs.writeText "openbox-menu.xml" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <openbox_menu xmlns="http://openbox.org/">
        <menu id="root-menu" label="Openbox">
          <item label="Terminal (kitty)">
            <action name="Execute">
              <command>${terminal}</command>
            </action>
          </item>
          <item label="Application Launcher (rofi)">
            <action name="Execute">
              <command>${launcher}</command>
            </action>
          </item>
          <separator/>
          <item label="Reconfigure Openbox">
            <action name="Reconfigure"/>
          </item>
          <item label="Exit Openbox">
            <action name="Exit"/>
          </item>
        </menu>
      </openbox_menu>
    '';
  };

  # 確保必要的套件已安裝
  home.packages = with pkgs; [
    openbox       # 視窗管理器本體
    obconf        # 圖形化設定工具（選用）
    rofi          # 你的應用啟動器（如果尚未全域安裝）
    kitty         # 你的終端機（如果尚未全域安裝）
  ];

  # 提供一個方便執行的腳本：openbox-run <應用程式>
  # 用法範例：openbox-run firefox
  home.file.".local/bin/openbox-run" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      if [ -z "$1" ]; then
        echo "用法: openbox-run <應用程式指令>"
        echo "範例: openbox-run firefox"
        exit 1
      fi
      exec ${pkgs.openbox}/bin/openbox --startup "$@" \
        --config ${config.services.openbox.configFile}
    '';
    executable = true;
  };

  # 為顯示管理器（如 regreetd）建立 Desktop Entry，使 Openbox 出現在登入選單
  xdg.dataFile."xsessions/openbox-nix.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Openbox (Nix)
      Comment=Minimal floating Openbox session for problematic apps
      Exec=${pkgs.openbox}/bin/openbox-session
      Type=Application
    '';
  };

  # 清理環境：確保不會帶入任何 Hyprland 的殘留變數或服務
  home.sessionVariables = {
    # 可選：避免 Openbox 讀到不必要的 GTK 設定
    GTK_THEME = "Adwaita:dark";  # 僅供參考，可依喜好調整
  };
}
