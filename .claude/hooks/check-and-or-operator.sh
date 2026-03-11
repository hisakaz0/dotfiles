#!/bin/bash
set -euo pipefail

# && / || 演算子チェックフック

input=$(cat)

# Bash コマンドかチェック
tool_name=$(echo "$input" | jq -r '.tool_name // empty')
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# コマンドを取得
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# && または || を含むかチェック
if echo "$command" | grep -qE '&&|\|\|'; then
  cat >&2 <<'EOF'
{
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  },
  "systemMessage": "❌ `&&` や `||` を含むコマンドは禁止されています。\n\nコマンドを分割して個別に実行してください。\n\n例:\n❌ 禁止: command1 && command2\n❌ 禁止: command1 || command2\n✅ 推奨: Bash ツールを2回に分けて実行\n  1. command1\n  2. command2"
}
EOF
  exit 2
fi

exit 0
