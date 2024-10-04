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
    # use more accurate EOF to ensure correct writing
    cat > ~/.config/starship.toml <<'EOF'
# version: 1.0.0

add_newline = true
continuation_prompt = "[▸▹ ](dimmed white)"

format = """($nix_shell$container$fill$git_metrics\n)$cmd_duration\
$hostname\
$localip\
$shlvl\
$shell\
$env_var\
$jobs\
$sudo\
$username\
$character"""

right_format = """
$singularity\
$kubernetes\
$directory\
$vcsh\
$fossil_branch\
$git_branch\
$git_commit\
$git_state\
$git_status\
$hg_branch\
$pijul_channel\
$docker_context\
$package\
$c\
$cmake\
$cobol\
$daml\
$dart\
$deno\
$dotnet\
$elixir\
$elm\
$erlang\
$fennel\
$golang\
$guix_shell\
$haskell\
$haxe\
$helm\
$java\
$julia\
$kotlin\
$gradle\
$lua\
$nim\
$nodejs\
$ocaml\
$opa\
$perl\
$php\
$pulumi\
$purescript\
$python\
$raku\
$rlang\
$red\
$ruby\
$rust\
$scala\
$solidity\
$swift\
$terraform\
$vlang\
$vagrant\
$zig\
$buf\
$conda\
$meson\
$spack\
$memory_usage\
$aws\
$gcloud\
$openstack\
$azure\
$crystal\
$custom\
$status\
$os\
$battery\
$time"""

[fill]
symbol = ' '

[character]
format = "$symbol "
success_symbol = "[◎](bold italic bright-yellow)"
error_symbol = "[○](italic purple)"
vimcmd_symbol = "[■](italic dimmed green)"
# not supported in zsh
vimcmd_replace_one_symbol = "◌"
vimcmd_replace_symbol = "□"
vimcmd_visual_symbol = "▼"

[env_var.VIMSHELL]
format = "[$env_value]($style)"
style = 'green italic'

[sudo]
format = "[$symbol]($style)"
style = "bold italic bright-purple"
symbol = "⋈┈"
disabled = false

[username]
style_user = "bright-yellow bold italic"
style_root = "purple bold italic"
format = "[⭘ $user]($style) "
disabled = false
show_always = false

[directory]
home_symbol = "⌂"
truncation_length = 2
truncation_symbol = "□ "
read_only = " ◈"
use_os_path_sep = true
style = "italic blue"
format = '[$path]($style)[$read_only]($read_only_style)'
repo_root_style = 'bold blue'
repo_root_format = '[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)'

[cmd_duration]
format = "[◄ $duration ](italic white)"

[jobs]
format = "[$symbol$number]($style) "
style = "white"
symbol = "[▶](blue italic)"

[localip]
ssh_only = true
format = " ◯[$localipv4](bold magenta)"
disabled = false

[time]
disabled = false
format = "[ $time]($style)"
time_format = "%R"
utc_time_offset = "local"
style = "italic dimmed white"

[battery]
format = "[ $percentage $symbol]($style)"
full_symbol = "█"
charging_symbol = "[↑](italic bold green)"
discharging_symbol = "↓"
unknown_symbol = "░"
empty_symbol = "▃"

[[battery.display]]
threshold = 20
style = "italic bold red"

[[battery.display]]
threshold = 60
style = "italic dimmed bright-purple"

[[battery.display]]
threshold = 70
style = "italic dimmed yellow"

[git_branch]
format = " [$branch(:$remote_branch)]($style)"
symbol = "[△](bold italic bright-blue)"
style = "italic bright-blue"
truncation_symbol = "⋯"
truncation_length = 11
ignore_branches = ["main", "master"]
only_attached = true

[git_metrics]
format = '([▴$added]($added_style))([▿$deleted]($deleted_style))'
added_style = 'italic dimmed green'
deleted_style = 'italic dimmed red'
ignore_submodules = true
disabled = false

[git_status]
style = "bold italic bright-blue"
format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))"
conflicted = "[◪◦](italic bright-magenta)"
ahead = "[▴│[${count}](bold white)│](italic green)"
behind = "[▿│[${count}](bold white)│](italic red)"
diverged = "[◇ ▴┤[${ahead_count}](regular white)│▿┤[${behind_count}](regular white)│](italic bright-magenta)"
untracked = "[◌◦](italic bright-yellow)"
stashed = "[◃◈](italic white)"
modified = "[●◦](italic yellow)"
staged = "[▪┤[$count](bold white)│](italic bright-cyan)"
renamed = "[◎◦](italic bright-blue)"
deleted = "[✕](italic red)"

[deno]
format = " [deno](italic) [∫ $version](green bold)"
version_format = "${raw}"

[lua]
format = " [lua](italic) [${symbol}${version}]($style)"
version_format = "${raw}"
symbol = "⨀ "
style = "bold bright-yellow"

[nodejs]
format = " [node](italic) [◫ ($version)](bold bright-green)"
version_format = "${raw}"
detect_files = ["package-lock.json", "yarn.lock"]
detect_folders = ["node_modules"]
detect_extensions = []

[python]
format = " [py](italic) [${symbol}${version}]($style)"
symbol = "[⌉](bold bright-blue)⌊ "
version_format = "${raw}"
style = "bold bright-yellow"

[ruby]
format = " [rb](italic) [${symbol}${version}]($style)"
symbol = "◆ "
version_format = "${raw}"
style = "bold red"

[rust]
format = " [rs](italic) [$symbol$version]($style)"
symbol = "⊃ "
version_format = "${raw}"
style = "bold red"

[package]
format = " [pkg](italic dimmed) [$symbol$version]($style)"
version_format = "${raw}"
symbol = "◨ "
style = "dimmed yellow italic bold"

[swift]
format = " [sw](italic) [${symbol}${version}]($style)"
symbol = "◁ "
style = "bold bright-red"
version_format = "${raw}"

[aws]
disabled = true
format = " [aws](italic) [$symbol $profile $region]($style)"
style = "bold blue"
symbol = "▲ "

[buf]
symbol = "■ "
format = " [buf](italic) [$symbol $version $buf_version]($style)"

[c]
symbol = "ℂ "
format = " [$symbol($version(-$name))]($style)"

[conda]
symbol = "◯ "
format = " conda [$symbol$environment]($style)"

[dart]
symbol = "◁◅ "
format = " dart [$symbol($version )]($style)"

[docker_context]
symbol = "◧ "
format = " docker [$symbol$context]($style)"

[elixir]
symbol = "△ "
format = " exs [$symbol $version OTP $otp_version ]($style)"

[elm]
symbol = "◩ "
format = " elm [$symbol($version )]($style)"

[golang]
symbol = "∩ "
format = " go [$symbol($version )]($style)"

[haskell]
symbol = "❯λ "
format = " hs [$symbol($version )]($style)"

[java]
symbol = "∪ "
format = " java [${symbol}(${version} )]($style)"

[julia]
symbol = "◎ "
format = " jl [$symbol($version )]($style)"

[memory_usage]
symbol = "▪▫▪ "
format = " mem [${ram}( ${swap})]($style)"

[nim]
symbol = "▴▲▴ "
format = " nim [$symbol($version )]($style)"

[nix_shell]
style = 'bold italic dimmed blue'
symbol = '✶'
format = '[$symbol nix⎪$state⎪]($style) [$name](italic dimmed white)'
impure_msg = '[⌽](bold dimmed red)'
pure_msg = '[⌾](bold dimmed green)'
unknown_msg = '[◌](bold dimmed ellow)'

[spack]
symbol = "◇ "
format = " spack [$symbol$environment]($style)"
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