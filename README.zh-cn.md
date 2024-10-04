# WezTern 自动配置

![License](https://img.shields.io/github/license/riverify/weztern-autoconfig)

🌐 **语言**: [English](README.md) | [简体中文](README.zh-cn.md) | [日本語](README.ja.md)

本项目提供了一个全自动的脚本，用于配置和我一样的终端环境，其中包含各种工具和设置。
我提供了一种简单的方法，让你可以快速配置出像下图一样效果的终端。

<img src="https://github.com/riverify/weztern-autoconfig/blob/main/img/jetpack.png?raw=true">

## 功能

- **语言选择**: 选择英文、简体中文和日语中的一种来运行配置脚本。
- **Zsh 配置**: 自动配置 `.zshrc`，包括：
    - Starship 提示符
    - zsh-syntax-highlighting
    - zsh-autosuggestions
    - 代理设置
    - 实用的别名
    - 问候功能

## 准备工作

- **macOS**: 虽然这些脚本被设计用于在 macOS 上运行。但你仍然可以在其他Linux、Windows上使用它们，虽然这可能进行一些修改，你可以自行探索。
- **稳定的网络连接**: 脚本将下载并安装各种工具和包，因此需要良好的网络连接。

**完成上述简单的布置后，你便可以立即开始安装脚本。**

## 安装方法

有两种方法可以安装脚本：

### 方法一：使用 `curl`

1. 在终端中运行以下命令：
    ```sh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/riverify/weztern-autoconfig/main/autoconfig_curl.sh)"
    ```
2. 脚本将自动配置你的环境。
3. 如果遇到任何问题，请通过创建 issue 告诉我。

### 方法二：使用 `git`

1. 克隆仓库：
    ```sh
    git clone https://github.com/riverify/weztern-autoconfig.git
    cd weztern-autoconfig
    ```

2. 设置主脚本权限：
    ```sh
    chmod +x autoconfig.sh
    ```

3. 运行脚本：
    ```sh
    ./autoconfig.sh
    ```

## 使用

1. 当提示时，选择你偏好的语言：
    ```
    Please select a language:
    1) English
    2) 简体中文
    3) 日本語
    Press Enter to use English by default.
    ```

2. 脚本将根据你的选择自动配置你的环境。

## 许可证

本项目使用 GNU 通用公共许可证 v3.0 进行许可。详情请参阅 `LICENSE` 文件。

## 贡献

1. Fork 此仓库。
2. 创建一个新分支 (`git checkout -b feature-branch`)。
3. 进行你的更改。
4. 提交你的更改 (`git commit -am 'Add new feature'`)。
5. 推送到分支 (`git push origin feature-branch`)。
6. 创建一个新的 Pull Request。

## 鸣谢

- [Starship](https://starship.rs/)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Homebrew](https://brew.sh/)