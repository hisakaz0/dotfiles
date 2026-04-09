#!/bin/bash
set -euo pipefail

# cd コマンドを自動許可するフック
# Claude Code の既知バグ回避: working directory 変更後に cd が許可を求められる
input=$(cat)

command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [ -z "$command" ]; then
  exit 0
fi

# cd 単体のコマンドのみ許可（&& や ; 等で結合されていないもの）
if echo "$command" | grep -qE '^[[:space:]]*cd[[:space:]]+[^[:space:]]+[[:space:]]*$'; then
  jq -n '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "allow",
      "permissionDecisionReason": "Auto-approved cd command by allow-cd hook"
    }
  }'
  exit 0
fi

exit 0
