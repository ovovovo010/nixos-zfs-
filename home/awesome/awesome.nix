# home/awesome/awesome.nix
{ pkgs, ... }:
let
  bling-src = pkgs.fetchFromGitHub {
    owner  = "blingcorp";
    repo   = "bling";
    rev    = "master";
    sha256 = "sha256-wlkMjNLloJfJkNpbL5K/3bYoZQmNRUKxQSdJXS6FQzw=";
  };
in
{
  # 套件統一在 packages.nix 管理

  # rc.lua 主設定
  xdg.configFile."awesome/rc.lua".source = ./rc.lua;

  # bling 套件（nixpkgs 沒有，從 GitHub 抓）
  xdg.configFile."awesome/bling".source = bling-src;

  # picom compositor
  xdg.configFile."picom/picom.conf".text = ''
    # ── 圓角 ─────────────────────────────────────────────────
    corner-radius = 12;
    rounded-corners-exclude = [
      "class_g = 'awesome'"
    ];

    # ── 陰影 ─────────────────────────────────────────────────
    shadow = true;
    shadow-radius = 15;
    shadow-opacity = 0.6;
    shadow-offset-x = -15;
    shadow-offset-y = -15;
    shadow-exclude = [
      "class_g = 'awesome'"
    ];

    # ── 模糊 ─────────────────────────────────────────────────
    blur-method = "dual_kawase";
    blur-strength = 8;
    blur-background = true;
    blur-background-frame = true;

    # ── 透明度 ───────────────────────────────────────────────
    inactive-opacity = 0.85;
    active-opacity   = 1.0;
    frame-opacity    = 1.0;
    opacity-rule = [
      "95:class_g = 'kitty'"
    ];

    # ── 效能 ─────────────────────────────────────────────────
    vsync = true;
    backend = "glx";
    glx-no-stencil = true;
    use-damage = true;
  '';

  # xinitrc
  home.file.".xinitrc".text = ''
    picom -b
    feh --bg-fill ~/wallpaper.png &
    exec awesome
  '';
}
