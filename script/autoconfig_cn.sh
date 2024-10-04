#!/bin/bash

# version: 1.1.0

# 检查是否已配置网络代理
check_proxy() {
  # env | grep -i proxy
  if [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
    echo "检测到已有代理配置。"
    return 0
  else
    # 询问是否需要配置网络代理
    echo "未检测到zsh代理，是否需要配置网络代理（通常只发生在中国大陆地区）？(yes/no)"
    read -r self_config
    case "$self_config" in
      [Yy]* ) return 1 ;;  # 用户选择设置代理
      [Nn]* ) echo "将在不使用代理的情况下继续执行。"
              return 0 ;;  # 用户选择不设置代理
      * ) echo "无效输入，请输入 yes 或 no。"
          check_proxy ;;   # 递归调用直到获得有效输入
    esac
  fi
}

# 配置代理
set_proxy() {
  echo "是否需要此脚本协助配置网络代理？(yes/no)"
  read -r self_config
  case "$self_config" in
    [Yy]* )
      echo "请输入 HTTP 代理地址 (默认: http://127.0.0.1:7890):"
      read -r http_proxy_input
      echo "请输入 HTTPS 代理地址 (默认: http://127.0.0.1:7890):"
      read -r https_proxy_input
      http_proxy=${http_proxy_input:-http://127.0.0.1:7890}
      https_proxy=${https_proxy_input:-http://127.0.0.1:7890}

      export http_proxy
      export https_proxy

      echo "已设置临时代理。"
      ;;
    [Nn]* )
      echo "请自行配置网络代理后再执行此脚本。"
      exit 0 ;;
    * )
      echo "无效输入，请输入 yes 或 no。"
      set_proxy ;;  # 递归调用直到获得有效输入
  esac
}

# 检查并安装brew
check_brew() {
  if ! command -v brew &> /dev/null; then
    echo "未检测到 Homebrew，是否安装？(yes/no)"
    read -r install_brew
    case "$install_brew" in
      [Yy]* ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ;;
      [Nn]* ) echo "请自行安装 Homebrew 后再执行此脚本。"
              exit 0 ;;
      * ) echo "无效输入，请输入 yes 或 no。"
          check_brew ;;  # 递归调用直到获得有效输入
    esac
  else
    echo "Homebrew 已安装。"
  fi
}

# 安装 wezterm
install_wezterm() {
  if brew list --cask | grep -q "wezterm"; then
      echo "WezTerm 已安装。"
    else
      brew install --cask wezterm
      echo "WezTerm 已安装。"
    fi
}

# 配置 wezterm
setup_wezterm() {
  # 如果 wezterm.lua 已存在，则不再覆盖
  if [ -f ~/.config/wezterm/wezterm.lua ]; then
    echo "WezTerm 配置已存在，跳过配置。"
  else
    mkdir -p ~/.config/wezterm
    cat <<EOF > ~/.config/wezterm/wezterm.lua
-- Path: ~/.config/wezterm/wezterm.lua
-- github.com/riverify
-- This is a configuration file for wezterm, a GPU-accelerated terminal emulator for modern workflows.

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
    echo "WezTerm 配置完成。"
  fi
}

# 检查是否已安装 Starship
install_starship() {
  if brew list | grep -q "starship"; then
    echo "Starship 已安装。"
  else
    echo "正在检测并安装 Starship..."
    brew install starship
    echo "Starship 已安装。"
  fi
}

# 配置 starship
setup_starship() {
  if [ -f ~/.config/starship.toml ]; then
    echo "Starship 配置已存在，跳过配置。"
  else
    mkdir -p ~/.config
    cat <<EOF > ~/.config/starship.toml
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
    echo "Starship 样式配置完成。"
  fi
}

# 安装并配置 zsh 插件
setup_zsh() {

  echo "正在检测并安装 zsh 插件。"

  if ! brew list | grep -q "zsh-syntax-highlighting"; then
    brew install zsh-syntax-highlighting
  fi

  if ! brew list | grep -q "zsh-autosuggestions"; then
    brew install zsh-autosuggestions
  fi

  echo "安装完成，正在检查 .zshrc 配置。"

  # 插入 Starship 配置，并添加空行
  if ! grep -q "starship init zsh" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Starship
eval "\$(starship init zsh)"
EOF
  fi

  # 插入 zsh-syntax-highlighting 配置，并添加空行
  if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Activate the syntax highlighting
source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
EOF
  fi

  # 插入 zsh-autosuggestions 配置，并添加空行
  if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Activate the autosuggestions
source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF
  fi

  # 插入代理配置，并添加空行
  if ! grep -q "export http_proxy" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Proxy (Only for China Mainland)
export http_proxy="$http_proxy"
export https_proxy="$https_proxy"
EOF
  fi

  # 插入 alias 配置，并添加空行
  if ! grep -q "alias ll" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Aliases
alias ll='ls -al'
alias shutdown='sudo shutdown -h now'
EOF
  fi

  # 插入问候函数
  if ! grep -q "greet_user" ~/.zshrc; then
    cat <<'EOF' >> ~/.zshrc

# 每次进入终端时显示问候信息和电脑状态
greet_user() {
    # 获取当前时间
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    echo "欢迎回来, $USER"
    echo "现在时间: $current_time"
}

# 调用问候函数
greet_user
EOF
  fi

  echo ".zshrc 配置完成。"
}




# 主脚本流程
main() {
  check_proxy || set_proxy
  check_brew
  install_wezterm
  setup_wezterm
  install_starship
  setup_starship
  setup_zsh

  echo "所有配置完成，即刻体验WezTerm吧！"
}

main