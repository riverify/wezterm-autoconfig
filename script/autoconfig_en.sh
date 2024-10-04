#!/bin/bash

# version: 1.1.0

# Check if network proxy is configured
check_proxy() {
  if [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
    echo "Proxy configuration detected."
    return 0
  else
    echo "No proxy detected. Do you need to configure a network proxy (usually only in mainland China, if you are not in China, you are mostly not required to do so)? (yes/no)"
    read -r self_config
    case "$self_config" in
      [Yy]* ) return 1 ;;  # User chooses to set proxy
      [Nn]* ) echo "Continuing without proxy."
              return 0 ;;  # User chooses not to set proxy
      * ) echo "Invalid input, please enter yes or no."
          check_proxy ;;   # Recursive call until valid input is received
    esac
  fi
}

# Configure proxy
set_proxy() {
  echo "Do you need this script to help configure the network proxy? (yes/no)"
  read -r self_config
  case "$self_config" in
    [Yy]* )
      echo "Enter HTTP proxy address (default: http://127.0.0.1:7890):"
      read -r http_proxy_input
      echo "Enter HTTPS proxy address (default: http://127.0.0.1:7890):"
      read -r https_proxy_input
      http_proxy=${http_proxy_input:-http://127.0.0.1:7890}
      https_proxy=${https_proxy_input:-http://127.0.0.1:7890}

      export http_proxy
      export https_proxy

      echo "Temporary proxy set."
      ;;
    [Nn]* )
      echo "Please configure the network proxy manually before running this script."
      exit 0 ;;
    * )
      echo "Invalid input, please enter yes or no."
      set_proxy ;;  # Recursive call until valid input is received
  esac
}

# Check and install brew
check_brew() {
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not detected, install it? (yes/no)"
    read -r install_brew
    case "$install_brew" in
      [Yy]* ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ;;
      [Nn]* ) echo "Please install Homebrew manually before running this script."
              exit 0 ;;
      * ) echo "Invalid input, please enter yes or no."
          check_brew ;;  # Recursive call until valid input is received
    esac
  else
    echo "Homebrew is installed."
  fi
}

# Install wezterm
install_wezterm() {
  if brew list --cask | grep -q "wezterm"; then
      echo "WezTerm is already installed."
    else
      brew install --cask wezterm
      echo "WezTerm installed."
    fi
}

# Configure wezterm
setup_wezterm() {
  # If wezterm.lua exists, do not overwrite
  if [ -f ~/.config/wezterm/wezterm.lua ]; then
    echo "WezTerm configuration already exists, skipping."
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
    echo "WezTerm configuration completed."
  fi
}

# Check if Starship is installed
install_starship() {
  if brew list | grep -q "starship"; then
    echo "Starship is already installed."
  else
    echo "Detecting and installing Starship..."
    brew install starship
    echo "Starship installed."
  fi
}

# Configure starship
setup_starship() {
  if [ -f ~/.config/starship.toml ]; then
    echo "Starship configuration already exists, skipping."
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
EOF
    echo "Starship configuration completed."
  fi
}

# Install and configure zsh plugins
setup_zsh() {

  echo "Detecting and installing zsh plugins."

  if ! brew list | grep -q "zsh-syntax-highlighting"; then
    brew install zsh-syntax-highlighting
  fi

  if ! brew list | grep -q "zsh-autosuggestions"; then
    brew install zsh-autosuggestions
  fi

  echo "Installation completed, checking .zshrc configuration."

  # Insert Starship configuration and add a blank line
  if ! grep -q "starship init zsh" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Starship
eval "\$(starship init zsh)"
EOF
  fi

  # Insert zsh-syntax-highlighting configuration and add a blank line
  if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Activate the syntax highlighting
source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
EOF
  fi

  # Insert zsh-autosuggestions configuration and add a blank line
  if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Activate the autosuggestions
source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF
  fi

  # Insert proxy configuration and add a blank line
  if ! grep -q "export http_proxy" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Proxy (Only for China Mainland)
export http_proxy="\$http_proxy"
export https_proxy="\$https_proxy"
EOF
  fi

  # Insert alias configuration and add a blank line
  if ! grep -q "alias ll" ~/.zshrc; then
    cat <<EOF >> ~/.zshrc

# Aliases
alias ll='ls -al'
alias shutdown='sudo shutdown -h now'
EOF
  fi

  # Insert greeting function
  if ! grep -q "greet_user" ~/.zshrc; then
    cat <<'EOF' >> ~/.zshrc

# Display greeting message and computer status each time the terminal is opened
greet_user() {
    # Get the current time
    current_time=$(date +"%m/%d/%Y %H:%M:%S")
    echo "Welcome back, $USER"
    echo "Current time: $current_time"
}

# Call the greeting function
greet_user
EOF
  fi

  echo ".zshrc configuration completed."
}

# Main script flow
main() {
  check_proxy || set_proxy
  check_brew
  install_wezterm
  setup_wezterm
  install_starship
  setup_starship
  setup_zsh

  echo "All configurations are complete. Enjoy WezTerm!"
}

main