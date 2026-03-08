{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."xdg-terminals.list".text = ''
    kitty.desktop
  '';
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    extraConfig = {
      modi = ["drun" "run" "window" "ssh"];
      icon-theme = "Papirus-Dark";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "  Apps";
      display-run = "  Run";
      display-window = "  Windows";
      display-ssh = "  SSH";

      max-history-size = 25;
      scroll-method = 0;
      normalize-match = true;

      location = 0;
      width = 680;
      window-format = "{c}";

      hide-scrollbar = true;
      sidebar-mode = true;
      kb-cancel = "Escape";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-main    = mkLiteral "#0f111a";
        bg-panel   = mkLiteral "#181926";
        bg-item    = mkLiteral "#1e2030";
        bg-select  = mkLiteral "#2a2d3e";
        fg-main    = mkLiteral "#cdd6f4";
        fg-dim     = mkLiteral "#6e738d";
        accent     = mkLiteral "#89b4fa";
        border-col = mkLiteral "#313244";

        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@fg-main";
      };

      "window" = {
        background-color = mkLiteral "@bg-main";
        border           = mkLiteral "1px solid";
        border-color     = mkLiteral "@border-col";
        border-radius    = mkLiteral "8px";
        width            = mkLiteral "680px";
        height           = mkLiteral "420px";
        padding          = mkLiteral "0px";
      };

      "mainbox" = {
        background-color = mkLiteral "@bg-main";
        children         = mkLiteral "[inputbar, listview, mode-switcher]";
        spacing          = mkLiteral "0px";
        padding          = mkLiteral "0px";
      };

      "inputbar" = {
        children         = mkLiteral "[prompt, entry]";
        background-color = mkLiteral "@bg-panel";
        border           = mkLiteral "0px 0px 1px 0px";
        border-color     = mkLiteral "@border-col";
        padding          = mkLiteral "8px 12px";
        spacing          = mkLiteral "8px";
      };

      "prompt" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@accent";
        padding          = mkLiteral "4px 0px";
        font             = "JetBrains Mono Bold 11";
      };

      "entry" = {
        background-color  = mkLiteral "transparent";
        text-color        = mkLiteral "@fg-main";
        padding           = mkLiteral "4px 0px";
        placeholder       = "Search...";
        placeholder-color = mkLiteral "@fg-dim";
        font              = "JetBrains Mono 11";
      };

      "listview" = {
        background-color = mkLiteral "@bg-main";
        columns          = 2;
        lines            = 6;
        scrollbar        = false;
        spacing          = mkLiteral "0px";
        padding          = mkLiteral "4px 0px";
        fixed-height     = true;
        fixed-columns    = true;
      };

      "element" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@fg-main";
        padding          = mkLiteral "8px 14px";
        spacing          = mkLiteral "0px";
        border-radius    = mkLiteral "0px";
        orientation      = mkLiteral "horizontal";
      };

      "element normal normal" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@fg-main";
      };

      "element normal urgent" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@fg-main";
      };

      "element normal active" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@accent";
      };

      "element selected normal" = {
        background-color = mkLiteral "@bg-select";
        text-color       = mkLiteral "@fg-main";
      };

      "element selected urgent" = {
        background-color = mkLiteral "@bg-select";
        text-color       = mkLiteral "@fg-main";
      };

      "element selected active" = {
        background-color = mkLiteral "@bg-select";
        text-color       = mkLiteral "@accent";
      };

      "element-icon" = {
        size             = mkLiteral "22px";
        margin           = mkLiteral "0px 10px 0px 0px";
        background-color = mkLiteral "transparent";
      };

      "element-text" = {
        vertical-align   = mkLiteral "0.5";
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "inherit";
        font             = "JetBrains Mono 11";
      };

      "mode-switcher" = {
        background-color = mkLiteral "@bg-panel";
        border           = mkLiteral "1px 0px 0px 0px";
        border-color     = mkLiteral "@border-col";
        spacing          = mkLiteral "0px";
        padding          = mkLiteral "6px 8px";
      };

      "button" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@fg-dim";
        padding          = mkLiteral "4px 12px";
        border-radius    = mkLiteral "4px";
        font             = "JetBrains Mono 10";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-select";
        text-color       = mkLiteral "@accent";
        border           = mkLiteral "1px solid";
        border-color     = mkLiteral "@border-col";
      };

      "scrollbar" = {
        background-color = mkLiteral "@bg-panel";
        handle-color     = mkLiteral "@fg-dim";
        handle-width     = mkLiteral "4px";
        border-radius    = mkLiteral "2px";
      };

      "message" = {
        background-color = mkLiteral "@bg-panel";
        border           = mkLiteral "1px solid";
        border-color     = mkLiteral "@border-col";
        padding          = mkLiteral "6px 12px";
      };

      "textbox" = {
        text-color = mkLiteral "@fg-main";
        font       = "JetBrains Mono 11";
      };
    };
  };
}
