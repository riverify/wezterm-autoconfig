# WezTerm Autoconfig

![License](https://img.shields.io/github/license/riverify/weztern-autoconfig)

🌐 **Languages**: [English](README.md) | [简体中文](doc/README.zh-cn.md) | [日本語](doc/README.jp.md)


This project provides a script to configure my development environment with various tools and settings.
I provide a easy way for you to configure your environment with the same tools and settings just like the picture below.

<img src="https://github.com/riverify/weztern-autoconfig/blob/main/img/jetpack.png?raw=true">

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

- **macOS**: The scripts are designed to run on macOS. But you can still use it on other systems with some modifications. Try it at your own risk.
- **Remove Existing Configurations**: Before running the script, better to remove existing _Starship_ and _WezTerm_ configurations, it is okay if you don't, you will have to see what you want to keep.
- **Smooth Internet**: The script will download and install various tools and packages, so a good internet connection is a must.

**Once you have done the little things above, you can start to install the script immediately.**

## Installation

There are two ways to install the script:

### Method 1: Using `curl` (Recommended)

1. Run the following command in your terminal:
    ```sh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/riverify/weztern-autoconfig/main/autoconfig_curl.sh)"
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