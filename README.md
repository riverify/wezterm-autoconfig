# WezTern Autoconfig

![License](https://img.shields.io/github/license/riverify/weztern-autoconfig)

This project provides a script to configure my development environment with various tools and settings.

## Features

- **Language Selection**: Choose between English, Simplified Chinese, and Japanese for the configuration script.
- **Zsh Configuration**: Automatically configures `.zshrc` with:
  - Starship prompt
  - zsh-syntax-highlighting
  - zsh-autosuggestions
  - Proxy settings
  - Useful aliases
  - Greeting function

## Prerequisites

- **macOS**: The scripts are designed to run on macOS.
- **Homebrew**: Ensure Homebrew is installed on your system.

## Installation

There are two ways to install the script:

### Method 1: Using `curl`

1. Run the following command in your terminal:
    ```sh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/riverify/weztern-autoconfig/main/autoconfig.sh)"
    ```
2. The script will automatically configure your environment.
3. If you encounter any issues, please let me know by creating an issue.


### Method 2: Using `git`

1. Clone the repository:
    ```sh
    git clone https://github.com/riverify/weztern-autoconfig.git
    cd weztern-autoconfig
    ```

2. Make the main script executable:
    ```sh
    chmod +x autoconfig.sh
    ```

3. Run the script:
    ```sh
    ./autoconfig.sh
    ```

## Usage

1. When prompted, select your preferred language:
    ```
    Please select a language:
    1) English
    2) 简体中文
    3) 日本語
    Press Enter to use English by default.
    ```

2. The script will automatically configure your environment based on your selection.

## License

This project is licensed under the GNU General Public License v3.0. See the `LICENSE` file for details.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

## Acknowledgements

- [Starship](https://starship.rs/)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Homebrew](https://brew.sh/)