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
  "systemMessage": "❌ `rm` コマンドは禁止されています。ファイルを削除する代わりに、ゴミ箱に移動してください。\n\n例:❌ 禁止: rm file.txt ✅\n推奨: mv trash file.txt \n\n❌ 禁止: rm -rf directory\n✅ 推奨: trash directory \n\n本当に削除が必要な場合は、permissions 設定で一時的に許可してください。"
}
EOF
  exit 2
fi

# 問題なし
exit 0
