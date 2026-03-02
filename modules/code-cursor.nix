{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    code-cursor
    # jq 可以留著，但這次用不到
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

  # ✅ 使用純 shell 陣列，完全避開 jq 和 heredoc
  home.activation.installCursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v cursor >/dev/null 2>&1; then
      echo "Installing Cursor extensions..."
      
      # 直接在 shell 中定義陣列（注意 Nix 字串中的引號跳脫）
      extensions=(
        "ms-python.python"
        "rust-lang.rust-analyzer"
        "mkhl.direnv"
        "jnoortheen.nix-ide"
        "github.copilot"
        "eamodio.gitlens"
      )
      
      for extension in "''${extensions[@]}"; do
        echo "  Installing $extension"
        # 即使某個擴充功能失敗，也繼續安裝其他的
        cursor --install-extension "$extension" --force || echo "  ⚠️  Failed to install $extension (continuing)"
      done
      
      echo "✅ Cursor extensions installation completed."
    else
      echo "cursor command not found, skipping extension installation."
    fi
  '';
}
