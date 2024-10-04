# WezTern 自動設定

![License](https://img.shields.io/github/license/riverify/weztern-autoconfig)

🌐 **言語**: [English](../README.md) | [简体中文](README.zh-cn.md) | [日本語](README.ja.md)

このプロジェクトは、私と同じターミナル環境を自動的に構成するスクリプトを提供します。以下のようなターミナルの見た目と設定を簡単に再現することができます。

<img src="https://github.com/riverify/weztern-autoconfig/blob/main/img/jetpack.png?raw=true">

## 機能

- **言語選択**: 英語、簡体字中国語、日本語のいずれかでスクリプトを実行可能。
- **Zsh設定**: `.zshrc` の自動設定、以下を含む:
    - Starship プロンプト
    - zsh-syntax-highlighting
    - zsh-autosuggestions
    - プロキシ設定
    - 便利なエイリアス
    - 挨拶機能

## 事前準備

- **macOS**: このスクリプトはmacOS向けに設計されていますが、LinuxやWindowsでもいくつかの修正を加えれば動作します。ぜひご自身で試してみてください。
- **安定したインターネット接続**: スクリプトはさまざまなツールやパッケージをダウンロードしてインストールするため、インターネット接続が必要です。

**上記の準備が整えば、すぐにスクリプトのインストールを開始できます。**

## インストール方法

スクリプトのインストールには2つの方法があります：

### 方法1：`curl` を使用する (推奨)

1. ターミナルで以下のコマンドを実行します：
    ```sh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/riverify/weztern-autoconfig/main/autoconfig_curl.sh)"
    ```
2. スクリプトは自動的に環境を設定します。
3. 問題が発生した場合は、Issueを作成して報告してください。

### 方法2：`git` を使用する

1. リポジトリをクローンします：
    ```sh
    git clone https://github.com/riverify/weztern-autoconfig.git
    cd weztern-autoconfig
    ```

2. メインスクリプトに実行権限を付与します：
    ```sh
    chmod +x autoconfig.sh
    ```

3. スクリプトを実行します：
    ```sh
    ./autoconfig.sh
    ```

## 使い方

1. プロンプトが表示されたら、希望する言語を選択します：
    ```
    Please select a language:
    1) English
    2) 简体中文
    3) 日本語
    Press Enter to use English by default.
    ```

2. 選択に応じて、環境が自動的に構成されます。

## ライセンス

本プロジェクトはGNU General Public License v3.0の下でライセンスされています。詳細は `LICENSE` ファイルをご覧ください。

## コントリビューション

1. このリポジトリをForkします。
2. 新しいブランチを作成します (`git checkout -b feature-branch`)。
3. 変更を加えます。
4. 変更をコミットします (`git commit -am 'Add new feature'`)。
5. ブランチにプッシュします (`git push origin feature-branch`)。
6. 新しいPull Requestを作成します。

## 謝辞

- [Starship](https://starship.rs/)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Homebrew](https://brew.sh/)