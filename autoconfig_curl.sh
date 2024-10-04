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

# 创建临时文件
TMP_SCRIPT=$(mktemp)

# 下载脚本到临时文件
echo "Downloading script from $SCRIPT_URL..."
curl -s "$SCRIPT_URL" -o "$TMP_SCRIPT"

# 检查 curl 是否成功
if [[ $? -ne 0 ]]; then
  echo "Failed to download the script from $SCRIPT_URL"
  exit 1
fi

# 给临时文件添加执行权限并运行
chmod +x "$TMP_SCRIPT"
bash "$TMP_SCRIPT"

# 删除临时文件
rm "$TMP_SCRIPT"