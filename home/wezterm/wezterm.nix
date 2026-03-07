# home/wezterm/wezterm.nix
{ pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local config  = wezterm.config_builder()

      -- ── 字型 ────────────────────────────────────────────────
      config.font = wezterm.font_with_fallback {
        { family = 'JetBrainsMono Nerd Font', weight = 'Regular' },
        { family = 'Noto Sans CJK TC' },
      }
      config.font_size            = 13.0
      config.line_height          = 1.2
      config.cell_width           = 1.0
      config.freetype_load_target = 'HorizontalLcd'

      -- ── Catppuccin Mocha ─────────────────────────────────────
      config.colors = {
        foreground    = '#cdd6f4',
        background    = '#1e1e2e',
        cursor_bg     = '#f5e0dc',
        cursor_border = '#f5e0dc',
        cursor_fg     = '#1e1e2e',
        selection_bg  = '#585b70',
        selection_fg  = '#cdd6f4',

        ansi = {
          '#45475a', -- black
          '#f38ba8', -- red
          '#a6e3a1', -- green
          '#f9e2af', -- yellow
          '#89b4fa', -- blue
          '#cba6f7', -- magenta
          '#89dceb', -- cyan
          '#bac2de', -- white
        },
        brights = {
          '#585b70', -- bright black
          '#f38ba8', -- bright red
          '#a6e3a1', -- bright green
          '#f9e2af', -- bright yellow
          '#89b4fa', -- bright blue
          '#cba6f7', -- bright magenta
          '#89dceb', -- bright cyan
          '#a6adc8', -- bright white
        },

        tab_bar = {
          background         = '#181825',
          active_tab = {
            bg_color  = '#b4befe',
            fg_color  = '#1e1e2e',
            intensity = 'Bold',
          },
          inactive_tab = {
            bg_color  = '#313244',
            fg_color  = '#6c7086',
          },
          inactive_tab_hover = {
            bg_color  = '#45475a',
            fg_color  = '#cdd6f4',
          },
          new_tab = {
            bg_color = '#181825',
            fg_color = '#6c7086',
          },
          new_tab_hover = {
            bg_color = '#313244',
            fg_color = '#cdd6f4',
          },
        },
      }

      -- ── 視窗外觀 ─────────────────────────────────────────────
      config.window_background_opacity    = 0.92
      config.macos_window_background_blur = 20
      config.window_decorations           = 'RESIZE'
      config.window_padding = {
        left   = 12,
        right  = 12,
        top    = 8,
        bottom = 8,
      }
      config.initial_cols = 120
      config.initial_rows = 36

      -- ── Tab Bar ──────────────────────────────────────────────
      config.enable_tab_bar          = true
      config.use_fancy_tab_bar       = false
      config.tab_bar_at_bottom       = true
      config.show_new_tab_button_in_tab_bar = false
      config.tab_max_width            = 24
      config.hide_tab_bar_if_only_one_tab = true

      -- ── 游標 ─────────────────────────────────────────────────
      config.default_cursor_style      = 'BlinkingBar'
      config.cursor_blink_rate         = 500
      config.cursor_blink_ease_in      = 'Constant'
      config.cursor_blink_ease_out     = 'Constant'

      -- ── 捲動 ─────────────────────────────────────────────────
      config.scrollback_lines          = 10000
      config.enable_scroll_bar         = false

      -- ── 效能 ─────────────────────────────────────────────────
      config.front_end                 = 'WebGpu'
      config.webgpu_power_preference   = 'HighPerformance'
      config.animation_fps             = 60
      config.max_fps                   = 144

      -- ── 快捷鍵 ───────────────────────────────────────────────
      local act = wezterm.action
      config.keys = {
        -- Tab
        { key = 't';          mods = 'CTRL|SHIFT'; action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'w';          mods = 'CTRL|SHIFT'; action = act.CloseCurrentTab { confirm = false } },
        { key = 'RightArrow'; mods = 'CTRL|SHIFT'; action = act.ActivateTabRelative(1) },
        { key = 'LeftArrow';  mods = 'CTRL|SHIFT'; action = act.ActivateTabRelative(-1) },
        -- Pane 分割
        { key = 'd';          mods = 'CTRL|SHIFT'; action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'e';          mods = 'CTRL|SHIFT'; action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
        { key = 'h';          mods = 'CTRL|SHIFT'; action = act.ActivatePaneDirection 'Left' },
        { key = 'l';          mods = 'CTRL|SHIFT'; action = act.ActivatePaneDirection 'Right' },
        { key = 'k';          mods = 'CTRL|SHIFT'; action = act.ActivatePaneDirection 'Up' },
        { key = 'j';          mods = 'CTRL|SHIFT'; action = act.ActivatePaneDirection 'Down' },
        -- 字型大小
        { key = '=';          mods = 'CTRL';       action = act.IncreaseFontSize },
        { key = '-';          mods = 'CTRL';       action = act.DecreaseFontSize },
        { key = '0';          mods = 'CTRL';       action = act.ResetFontSize },
        -- 複製貼上
        { key = 'c';          mods = 'CTRL|SHIFT'; action = act.CopyTo 'Clipboard' },
        { key = 'v';          mods = 'CTRL|SHIFT'; action = act.PasteFrom 'Clipboard' },
        -- 搜尋
        { key = 'f';          mods = 'CTRL|SHIFT'; action = act.Search { CaseInSensitiveString = ''''; } },  -- 修正：四个单引号
      }

      -- ── 滑鼠 ─────────────────────────────────────────────────
      config.mouse_bindings = {
        {
          event  = { Up = { streak = 1; button = 'Left' } };
          mods   = 'NONE';
          action = act.OpenLinkAtMouseCursor;
        },
      }

      return config
    '';
  };
}