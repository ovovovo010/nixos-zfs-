{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    code-cursor
    jq
  ];

  xdg.configFile = {
    "Cursor/User/settings.json".text = builtins.toJSON {
      editor.fontSize = 14;
      editor.fontFamily = "'Fira Code', 'Droid Sans Mono', monospace";
      editor.minimap.enabled = false;
      telemetry.telemetryLevel = "off";
    };
    "Cursor/User/keybindings.json".text = builtins.toJSON [];
  };

  # ✅ 修正後的 activation 腳本
  home.activation.installCursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Checking for cursor command..."
    if command -v cursor >/dev/null 2>&1; then
      echo "Installing Cursor extensions..."

      # 使用 jq 的 -r 參數輸出純文字，並用 .[] 展開陣列
      ${pkgs.jq}/bin/jq -r '.[]' <<EOF | while read extension; do
      [
        "ms-python.python",
        "rust-lang.rust-analyzer",
        "mkhl.direnv",
        "jnoortheen.nix-ide",
        "github.copilot",
        "eamodio.gitlens"
      ]
      EOF
        echo "  Installing $extension"
        cursor --install-extension "$extension" --force || echo "  ⚠️  Failed to install $extension (continuing)"
      done
    else
      echo "cursor command not found, skipping extension installation."
    fi
  '';
}
