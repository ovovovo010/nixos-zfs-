{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;

    # ── 語言伺服器 ────────────────────────────────────────────────────────────
    extraPackages = with pkgs; [
      nil # Nix LSP
      nixpkgs-fmt # Nix formatter
      alejandra # 備用 Nix formatter
      nushell # Nu LSP（nu --lsp）
      taplo # TOML LSP + formatter
      marksman # Markdown LSP
      nodePackages.bash-language-server
      shellcheck # Shell 靜態分析
      yaml-language-server
      vscode-langservers-extracted # HTML / CSS / JSON / ESLint LSP
    ];

    editor = {
      # ── 外觀 ───────────────────────────────────────────────────────────
      line-number = "relative"; # vim 使用者必備
      cursorline = true;
      cursorcolumn = false;
      color-modes = true; # 不同模式游標不同顏色
      true-color = true;
      undercurl = true;

      # ── 操作 ───────────────────────────────────────────────────────────
      scrolloff = 8;
      mouse = true;
      middle-click-paste = false;
      auto-save = true;
      auto-format = true;
      idle-timeout = 200; # LSP hint 觸發延遲（ms）

      # ── 縮排 ───────────────────────────────────────────────────────────
      indent-guides = {
        render = true;
        character = "╎";
        skip-levels = 1;
      };

      # ── 游標 ───────────────────────────────────────────────────────────
      cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };

      # ── 狀態列 ─────────────────────────────────────────────────────────
      statusline = {
        left = ["mode" "spinner" "file-name" "file-modification-indicator"];
        center = ["version-control"];
        right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
        separator = "│";
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };

      # ── 補全 ───────────────────────────────────────────────────────────
      completion-trigger-len = 1;
      completion-replace = false;

      # ── 搜尋 ───────────────────────────────────────────────────────────
      search = {
        smart-case = true;
        wrap-around = true;
      };

      # ── Whitespace ─────────────────────────────────────────────────────
      whitespace = {
        render = {
          space = "none";
          tab = "all";
          newline = "none";
        };
        characters = {
          tab = "→";
          tabpad = "·";
        };
      };

      # ── 檔案選取器 ─────────────────────────────────────────────────────
      file-picker = {
        hidden = false;
        follow-symlinks = true;
        git-ignore = true;
        git-global = true;
        git-exclude = true;
      };

      # ── LSP ────────────────────────────────────────────────────────────
      lsp = {
        enable = true;
        display-messages = true;
        display-inlay-hints = true;
        snippets = true;
      };

      # ── 彩虹括號 ───────────────────────────────────────────────────────
      rainbow-brackets = true;

      # ── 終端機 ─────────────────────────────────────────────────────────
      shell = ["nu" "-c"];
    };

    # ── 按鍵（Normal mode 補充） ────────────────────────────────────────────
    keys = {
      normal = {
        # 快速視窗切換
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";
        # 快速診斷跳轉
        "]d" = "goto_next_diag";
        "[d" = "goto_prev_diag";
        # 空白鍵前綴（類 leader key）
        space = {
          "f" = "file_picker";
          "b" = "buffer_picker";
          "s" = "symbol_picker";
          "d" = "diagnostics_picker";
          "r" = "rename_symbol";
          "a" = "code_action";
          "/" = "global_search";
          "w" = ":write";
          "q" = ":quit";
          "Q" = ":quit!";
        };
      };
      insert = {
        # 跳出 insert 不用按 Esc
        "j" = {"k" = "normal_mode";};
      };
    };
  };

  # ── 語言設定 ─────────────────────────────────────────────────────────────
  languages = {
    language-server = {
      nil = {
        command = "nil";
        config.nil = {
          formatting.command = ["nixpkgs-fmt"];
          nix.flake = {
            autoArchive = true;
            autoEvalInputs = false;
          };
        };
      };
      nu = {
        command = "nu";
        args = ["--lsp"];
      };
      taplo = {
        command = "taplo";
        args = ["lsp" "stdio"];
      };
      marksman = {
        command = "marksman";
        args = ["server"];
      };
      bash-language-server = {
        command = "bash-language-server";
        args = ["start"];
      };
      yaml-language-server = {
        command = "yaml-language-server";
        args = ["--stdio"];
      };
    };

    language = [
      {
        name = "nix";
        formatter = {command = "nixpkgs-fmt";};
        language-servers = ["nil"];
        auto-format = true;
      }
      {
        name = "nu";
        language-servers = ["nu"];
        auto-format = true;
      }
      {
        name = "toml";
        formatter = {
          command = "taplo";
          args = ["fmt" "-"];
        };
        language-servers = ["taplo"];
        auto-format = true;
      }
      {
        name = "markdown";
        language-servers = ["marksman"];
        auto-format = false;
        soft-wrap.enable = true;
      }
      {
        name = "bash";
        language-servers = ["bash-language-server"];
        formatter = {command = "shfmt";};
        auto-format = true;
      }
      {
        name = "yaml";
        language-servers = ["yaml-language-server"];
        auto-format = true;
      }
      {
        name = "json";
        language-servers = ["vscode-json-language-server"];
        formatter = {
          command = "prettier";
          args = ["--parser" "json"];
        };
        auto-format = true;
      }
    ];
  };
}
