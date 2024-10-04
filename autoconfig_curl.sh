#!/bin/bash
# autoconfig_curl.sh

# 提示用户选择语言
echo "Please select a language:"
echo "1) English"
echo "2) 简体中文"
echo "3) 日本語"
echo "Press Enter to use English by default."

# 读取用户输入
read -rp "Enter your choice: " language_choice

# GitHub仓库基础URL
GITHUB_BASE_URL="https://raw.githubusercontent.com/riverify/weztern-autoconfig/main/script"

# 根据用户选择设置语言
case "$language_choice" in
  1|'')
    SCRIPT_URL="$GITHUB_BASE_URL/autoconfig_en.sh"
    echo "Defaulting to English."
    ;;
  2)
    SCRIPT_URL="$GITHUB_BASE_URL/autoconfig_cn.sh"
    ;;
  3)
    SCRIPT_URL="$GITHUB_BASE_URL/autoconfig_jp.sh"
    ;;
  *)
    echo "Invalid choice. Defaulting to English."
    SCRIPT_URL="$GITHUB_BASE_URL/autoconfig_en.sh"
    ;;
esac

# 使用 curl 下载并执行对应的脚本
echo "Now executing $SCRIPT_URL..."
bash <(curl -s "$SCRIPT_URL")

# 检查 curl 是否成功
if [[ $? -ne 0 ]]; then
  echo "Failed to download or execute the script from $SCRIPT_URL"
  exit 1
fi