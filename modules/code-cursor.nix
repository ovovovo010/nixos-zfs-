# code-cursor.nix
{ config, pkgs, ... }:

let
  cursorConfigDir =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/Cursor/User"
    else
      ".config/Cursor/User";
in
{
  nixpkgs.config.allowUnfree = true;

  # ✅ 合併所有套件到同一個 home.packages
  home.packages = with pkgs; [
    code-cursor
    nixgl.auto.nixGLDefault          # nixGL 套件
    (writeShellScriptBin "cursor" ''  # 包裝腳本
      exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGLDefault ${pkgs.code-cursor}/bin/cursor "$@"
    '')
  ];

  # 其他設定不變
  xdg.configFile = {
    "Cursor/User/settings.json".text = builtins.toJSON {
      editor.fontSize = 14;
      # ... 其餘設定
    };
    "Cursor/User/keybindings.json".text = builtins.toJSON [];
  };

  home.activation.installCursorExtensions = pkgs.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v cursor > /dev/null 2>&1; then
      ${pkgs.lib.getExe pkgs.jq} -n '[
        "ms-python.python",
        "rust-lang.rust-analyzer"
      ]' | while read extension; do
        cursor --install-extension "$extension" --force
      done
    fi
  '';
}
