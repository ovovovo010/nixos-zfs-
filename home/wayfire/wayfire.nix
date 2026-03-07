# home/wayfire/wayfire.nix
{pkgs, ...}: let
  # Catppuccin Mocha 颜色（字符串形式，避免 Nix 数字解析）
  # 格式：0xAARRGGBB  (Alpha 在前，Wayfire 常用)
  # 若想用 RRGGBBAA，请自行交换 alpha 位置，例如 base = "0x1e1e2eff"; 需改为 "0xff1e1e2e";
  mocha = {
    rosewater = "0xf5e0dcee";
    flamingo  = "0xf2cdcdee";
    pink      = "0xf5c2e7ee";
    mauve     = "0xcba6f7ee";
    red       = "0xf38ba8ee";
    maroon    = "0xeba0acee";
    peach     = "0xfab387ee";
    yellow    = "0xf9e2afee";
    green     = "0xa6e3a1ee";
    teal      = "0x94e2d5ee";
    sky       = "0x89dcebee";
    sapphire  = "0x74c7ecee";
    blue      = "0x89b4faee";
    lavender  = "0xb4befe";
    text      = "0xcdd6f4ff";
    subtext1  = "0xbac2deff";
    subtext0  = "0xa6adc8ff";
    overlay2  = "0x9399b2ff";
    overlay1  = "0x7f849cff";
    overlay0  = "0x6c7086ff";
    surface2  = "0x585b70ff";
    surface1  = "0x45475aff";
    surface0  = "0x313244ff";
    base      = "0x1e1e2eff";   # ← 注意：这里直接写字符串，无空格问题
    mantle    = "0x181825ff";
    crust     = "0x11111bff";
  };
in {
  home.packages = with pkgs; [ /* 同上，省略 */ ];

  home.sessionVariables = {
    WLR_RENDERER = "vulkan";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    XCURSOR_THEME = "catppuccin-mocha-lavender-cursors";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";
  };

  xdg.configFile."wayfire.ini".text = ''
    [core]
    plugins = \
      animate \
      autostart \
      command \
      decoration \
      move \
      place \
      resize \
      wm-actions \
      wobbly \
      blur \
      window-rules

    xwayland = true
    close_top_view = <super> KEY_C | <alt> KEY_F4

    [animate]
    open_animation  = zoom
    close_animation = zoom
    duration        = 250
    zoom_factor     = 0.87

    [decoration]
    title_height   = 32
    border_size    = 2
    corner_radius  = 20
    font           = JetBrainsMono Nerd Font Bold 10
    active_color   = ${mocha.surface0}   # 直接使用字符串，无需 toString
    inactive_color = ${mocha.surface2}
    text_color     = ${mocha.text}

    [blur]
    method    = kawase
    iterations = 2
    offset    = 5

    [move]
    activate = <super> BTN_LEFT

    [resize]
    activate = <super> BTN_RIGHT

    [place]
    mode = center

    [command]
    binding_terminal     = <super> KEY_Q
    command_terminal     = kitty

    binding_filemanager  = <super> KEY_E
    command_filemanager  = kitty -e yazi

    binding_launcher     = <super> KEY_R
    command_launcher     = rofi -show drun

    binding_lock         = <super> KEY_L
    command_lock         = hyprlock

    binding_logout       = <super> <shift> KEY_E
    command_logout       = wlogout

    binding_screenshot        = KEY_PRINT
    command_screenshot        = hyprshot -m output --clipboard-only

    binding_screenshot_region = <super> KEY_PRINT
    command_screenshot_region = hyprshot -m region -o ~/Pictures/Screenshots

    binding_screenshot_clip   = <super> <shift> KEY_S
    command_screenshot_clip   = hyprshot -m region --clipboard-only

    binding_vol_up   = KEY_VOLUMEUP
    command_vol_up   = wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

    binding_vol_down = KEY_VOLUMEDOWN
    command_vol_down = wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

    binding_mute     = KEY_MUTE
    command_mute     = wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    binding_bright_up   = KEY_BRIGHTNESSUP
    command_bright_up   = brightnessctl set +5%

    binding_bright_down = KEY_BRIGHTNESSDOWN
    command_bright_down = brightnessctl set 5%-

    binding_play_pause = KEY_PLAYPAUSE
    command_play_pause = playerctl play-pause

    binding_next       = KEY_NEXTSONG
    command_next       = playerctl next

    binding_prev       = KEY_PREVIOUSSONG
    command_prev       = playerctl previous

    [autostart]
    autostart_wf_shell = false
    fcitx5    = fcitx5 -d
    wallpaper = swww-daemon --daemonize && swww img /etc/nixos/root/wallpaper.png
    mako      = mako
    bar       = waybar

    [window-rules]
    rule_claude = on created if app_id is "Claude" \
      then set floating true; set geometry 100 100 1000 750

    rule_opacity_kitty = on created if app_id is "kitty" \
      then set opacity 0.90

    rule_dialogs_float = on created if window_type is "dialog" \
      then set floating true

    [wobbly]
    spring_k = 8.0
    friction = 3.0
    mass     = 30.0
  '';
}