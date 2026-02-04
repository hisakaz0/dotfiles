#!/bin/bash
set -euo pipefail

# cd ... && パターンをチェックするフック

input=$(cat)

# Bashコマンドかチェック
tool_name=$(echo "$input" | jq -r '.tool_name // empty')
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# コマンドを取得
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# cd ... && パターンをチェック
if echo "$command" | grep -qE '\bcd\s+[^\s&|;]+\s*&&'; then
  cat >&2 <<EOF
{
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  },
  "systemMessage": "❌ \`cd ... &&\` パターンは禁止されています。\n\n\`cd\` コマンドは単体で実行してください。\n\n例:\n❌ 禁止: cd /path/to/directory && some_command\n✅ 推奨: 2つのBashツール呼び出しに分けて実行\n  1. cd /path/to/directory\n  2. some_command\n\nまたは、絶対パスやカレントディレクトリからの相対パスを使用してください。"
}
EOF
  exit 2
fi

# 問題なし
exit 0
