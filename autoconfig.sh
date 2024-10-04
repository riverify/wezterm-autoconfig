#!/bin/bash
# autoconfig.sh

# 提示用户选择语言
echo "Please select a language:"
echo "1) English"
echo "2) 简体中文"
echo "3) 日本語"
echo "Press Enter to use English by default."

# 读取用户输入
read -rp "Enter your choice: " language_choice

# 根据用户选择设置语言
case "$language_choice" in
  1|'')
    SCRIPT_PATH="./script/autoconfig_en.sh"
    echo "Defaulting to English."
    ;;
  2)
    SCRIPT_PATH="./script/autoconfig_cn.sh"
    ;;
  3)
    SCRIPT_PATH="./script/autoconfig_jp.sh"
    ;;
  *)
    echo "Invalid choice. Defaulting to English."
    SCRIPT_PATH="./script/autoconfig_en.sh"
    ;;
esac

# 执行相应语言的配置脚本
if [[ -f "$SCRIPT_PATH" ]]; then
  echo "Now executing $SCRIPT_PATH..."
  bash "$SCRIPT_PATH"
else
  echo "Script not found: $SCRIPT_PATH"
  exit 1
fi