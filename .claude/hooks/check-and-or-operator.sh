#!/bin/bash
set -euo pipefail

# && / || / ; 演算子チェック & 複数行の行継続チェックフック

input=$(cat)

# Bash コマンドかチェック
tool_name=$(echo "$input" | jq -r '.tool_name // empty')
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# コマンドを取得
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# && または || または ; を含むかチェック
if echo "$command" | grep -qE '&&|\|\||;'; then
  cat >&2 <<'EOF'
{
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  },
  "systemMessage": "❌ `&&` や `||` や `;` を含むコマンドは禁止されています。コマンドを分割して個別に実行してください。\\n例: ❌ 禁止: command1 && command2 \\n❌ 禁止: command1 || command2\\n❌ 禁止: command1; command2\\n✅ 推奨: Bash ツールを2回に分けて実行"
}
EOF
  exit 2
fi

# 複数行の場合、最後の行以外の末尾が \ でなければエラー
line_count=$(echo "$command" | wc -l | tr -d ' ')
if [ "$line_count" -gt 1 ]; then
  # 最後の行を除いた各行で、末尾が \ でない非空行を検出
  bad_lines=$(echo "$command" | ghead -n -1 | grep -v '\\$' | grep -v '^$' || true)
  if [ -n "$bad_lines" ]; then
    cat >&2 <<'EOF'
{
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  },
  "systemMessage": "❌ 複数行コマンドでは、最後の行以外の末尾に `\\` が必要です。行継続なしの改行は禁止されています。\\n例: ✅ OK: command \\\n  --option value\\n❌ NG: command\\n  --option value"
}
EOF
    exit 2
  fi
fi

exit 0
