#!/bin/bash

# バージョン: 1.1.0

# ネットワークプロキシが設定されているか確認
check_proxy() {
  if [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
    echo "プロキシ設定が検出されました。"
    return 0
  else
    echo "プロキシが検出されませんでした。ネットワークプロキシを設定しますか？（通常、中国本土のみ必要です） (yes/no)"
    read -r self_config
    case "$self_config" in
      [Yy]* ) return 1 ;;  # ユーザーがプロキシを設定することを選択
      [Nn]* ) echo "プロキシなしで続行します。"
              return 0 ;;  # ユーザーがプロキシを設定しないことを選択
      * ) echo "無効な入力です。yes または no を入力してください。"
          check_proxy ;;   # 有効な入力が得られるまで再帰呼び出し
    esac
  fi
}

# プロキシを設定
set_proxy() {
  echo "このスクリプトでネットワークプロキシを設定しますか？ (yes/no)"
  read -r self_config
  case "$self_config" in
    [Yy]* )
      echo "HTTP プロキシアドレスを入力してください（デフォルト: http://127.0.0.1:7890）："
      read -r http_proxy_input
      echo "HTTPS プロキシアドレスを入力してください（デフォルト: http://127.0.0.1:7890）："
      read -r https_proxy_input
      http_proxy=${http_proxy_input:-http://127.0.0.1:7890}
      https_proxy=${https_proxy_input:-http://127.0.0.1:7890}

      export http_proxy
      export https_proxy

      echo "一時的なプロキシが設定されました。"
      ;;
    [Nn]* )
      echo "このスクリプトを実行する前にネットワークプロキシを手動で設定してください。"
      exit 0 ;;
    * )
      echo "無効な入力です。yes または no を入力してください。"
      set_proxy ;;  # 有効な入力が得られるまで再帰呼び出し
  esac
}

# brew を確認してインストール
check_brew() {
  if ! command -v brew &> /dev/null; then
    echo "Homebrew が検出されませんでした。インストールしますか？ (yes/no)"
    read -r install_brew
    case "$install_brew" in
      [Yy]* ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ;;
      [Nn]* ) echo "このスクリプトを実行する前に Homebrew を手動でインストールしてください。"
              exit 0 ;;
      * ) echo "無効な入力です。yes または no を入力してください。"
          check_brew ;;  # 有効な入力が得られるまで再帰呼び出し
    esac
  else
    echo "Homebrew はインストールされています。"
  fi
}

# wezterm をインストール
install_wezterm() {
  if brew list --cask | grep -q "wezterm"; then
      echo "WezTerm は既にインストールされています。"
    else
      brew install --cask wezterm
      echo "WezTerm がインストールされました。"
    fi
}

# wezterm を設定
setup_wezterm() {
  # wezterm.lua が存在する場合、上書きしない
  if [ -f ~/.config/wezterm/wezterm.lua ]; then
    echo "WezTerm の設定ファイルは既に存在します。スキップします。"
  else
    mkdir -p ~/.config/wezterm
    cat <<EOF > ~/.config/wezterm/wezterm.lua
-- Path: ~/.config/wezterm/wezterm.lua
-- github.com/riverify
-- これは wezterm の設定ファイルです。wezterm はモダンなワークフローのための GPU 加速ターミナルエミュレータです。

local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,    -- Hide the tab bar when there is only one tab
    window_close_confirmation = "NeverPrompt",
    window_decorations = "TITLE | RESIZE", -- disable the title bar but enable the resizable border
    font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
    font_size = 13,
    color_scheme = "Nord (Gogh)",
    default_cursor_style = 'BlinkingBlock',
    macos_window_background_blur = 25, -- Enable window background blur on macOS
    background = {
        {
            source = {
                Color = "#301934", -- dark purple
            },
            width = "100%",
            height = "100%",
            opacity = 0.85,
        },
    },
    window_padding = {
        left = 3,
        right = 3,
        top = 0,
        bottom = 0,
    },
    initial_rows = 50,
    initial_cols = 100,
}

return config
EOF
    echo "WezTerm の設定が完了しました。"
  fi
}

# Starship がインストールされているか確認
install_starship() {
  if brew list | grep -q "starship"; then
    echo "Starship は既にインストールされています。"
  else
    echo "Starship を検出してインストールしています..."
    brew install starship
    echo "Starship がインストールされました。"
  fi
}

# Starship を設定
setup_starship() {
  if [ -f ~/.config/starship.toml ]; then
    echo "Starship の設定ファイルは既に存在します。スキップします。"
  else
    mkdir -p ~/.config
    cat <<EOF > ~/.config/starship.toml
# プロンプトの先頭に新しい行を表示しない
add_newline = false

# 新しい行を開くときに表示するプロンプト
[character]
success_symbol = "[→](bold green)" # コマンドが成功したときに使用するシンボル
error_symbol = "[→](bold red)"    # コマンドが失敗したときに使用するシンボル
vicmd_symbol = "[→](bold yellow)" # vi モードで使用するシンボル（オプション）

# 現在の時刻のみを表���するように時間フォーマットをカスタマイズ
[time]
format = "[$time]($style) "
time_format = "%H:%M:%S"

# ディレクトリ表示をカスタマイズ
[directory]
truncation_length = 3
truncation_symbol = "…/"
home_symbol = "~"
read_only = "🔒"

# Git ブランチの設定
[git_branch]
symbol = "🌿 "   # Git ブランチを表示するためのシンボル

# Git ステータスの設定
[git_status]
staged = "[+] "         # ステージされた変更を表示するためのシンボル
modified = "[✎] "       # 変更されたファイルを表示するためのシンボル
deleted = "[-] "        # 削除されたファイルを表示するためのシンボル
ahead = "⇡ "            # リモートより先行している場合に表示するシンボル
behind = "⇣ "           # リモートより遅れている場合に表示するシンボル
untracked = "[?] "      # 未追跡ファイルを表示するためのシンボル

# パッケージモジュールを無効にする
[package]
disabled = true
EOF
    echo "Starshipのスタイル設定が完了しました。"
  fi
}

# zsh プラグインをインストールして設定
setup_zsh() {

  echo "zshプラグインを検出してインストールしています。"

  if ! brew list | grep -q "zsh-syntax-highlighting"; then
    brew install zsh-syntax-highlighting
  fi

  if ! brew list | grep -q "zsh-autosuggestions"; then
    brew install zsh-autosuggestions
  fi

  echo "インストールが完了しました。.zshrc の設定を確��しています。"

  # Starship の設定を挿入し、空行を追加
  if ! grep -q "starship init zsh" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Starship
eval "\$(starship init zsh)"
EOF
  fi

  # zsh-syntax-highlighting の設定を挿入し、空行を追加
  if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# シンタックスハイライトを有効にする
source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
EOF
  fi

  # zsh-autosuggestions の設定を挿入し、空行を追加
  if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# 自動補完を有効にする
source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF
  fi

  # プロキシ設定を挿入し、空行を追加
  if ! grep -q "export http_proxy" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# プロキシ（中国本土のみ）
export http_proxy="\$http_proxy"
export https_proxy="\$https_proxy"
EOF
  fi

  # エイリアス設定を挿入し、空行を追加
  if ! grep -q "alias ll" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# エイリアス
alias ll='ls -al'
alias shutdown='sudo shutdown -h now'
EOF
  fi

  # 挨拶関数を挿入
  if ! grep -q "greet_user" ~/.zshrc; then
    cat <<'EOF' >> ~/.zshrc

# ターミナルに入るたびに挨拶メッセージとコンピュータの状態を表示
greet_user() {
    # 現在の時刻を取得
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    echo "お帰りなさい, $USER さん"
    echo "現在の時刻: $current_time"
}

# 挨拶関数を呼び出す
greet_user
EOF
  fi

  echo ".zshrcの設定が完了しました。"
}

# メインスクリプトのフロー
main() {
  check_proxy || set_proxy
  check_brew
  install_wezterm
  setup_wezterm
  install_starship
  setup_starship
  setup_zsh

  echo "すべての設定が完了しました。WezTermをお楽しみください！"
}

main