#!/bin/bash
set -euo pipefail

# rm コマンドをチェックして ~/.Trash/ への移動を提案するフック

input=$(cat)

# Bashコマンドかチェック
tool_name=$(echo "$input" | jq -r '.tool_name // empty')
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# コマンドを取得
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# rm コマンドパターンをチェック
if echo "$command" | grep -qE '\brm\s+'; then
  cat >&2 <<'EOF'
{
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  },
  "systemMessage": "❌ `rm` コマンドは禁止されています。\n\nファイルを削除する代わりに、エージェント用ゴミ箱に移動してください。\n\n例:\n❌ 禁止: rm file.txt\n✅ 推奨: mkdir -p ~/.Trash/ForAgents && mv file.txt ~/.Trash/ForAgents/\n\n❌ 禁止: rm -rf directory\n✅ 推奨: mkdir -p ~/.Trash/ForAgents && mv directory ~/.Trash/ForAgents/\n\n複数ファイルの場合:\n❌ 禁止: rm file1.txt file2.txt\n✅ 推奨: 個別に移動\n  mkdir -p ~/.Trash/ForAgents\n  mv file1.txt ~/.Trash/ForAgents/\n  mv file2.txt ~/.Trash/ForAgents/\n\nまたは、本当に削除が必要な場合は、permissions 設定で一時的に許可してください。"
}
EOF
  exit 2
fi

# 問題なし
exit 0
