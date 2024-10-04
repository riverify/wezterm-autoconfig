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
    cat <<EOF > ~/.config/starship.toml
# Don't print a new line at the start of the prompt
add_newline = false

# Prompt to show when opening a new line
[character]
success_symbol = "[→](bold green)" # The symbol to use when the command succeeds
error_symbol = "[→](bold red)"    # The symbol to use when the command fails
vicmd_symbol = "[→](bold yellow)" # The symbol to use in vi mode (optional)

# Customize the time format to display only the current time
[time]
format = "[$time]($style) "
time_format = "%H:%M:%S"

# Customize the directory display
[directory]
truncation_length = 3
truncation_symbol = "…/"
home_symbol = "~"
read_only = "🔒"

# Git branch configuration
[git_branch]
symbol = "🌿 "   # The symbol to display for git branches

# Git status configuration
[git_status]
staged = "[+] "         # The symbol to show for staged changes
modified = "[✎] "       # The symbol to show for modified changes
deleted = "[-] "        # The symbol to show for deleted files
ahead = "⇡ "            # The symbol to show if the branch is ahead of the remote
behind = "⇣ "           # The symbol to show if the branch is behind the remote
untracked = "[?] "      # The symbol to show for untracked files

# Disable package module
[package]
disabled = true
EOF
    echo "Starship style configuration completed."
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