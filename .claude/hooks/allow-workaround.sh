#!/bin/bash
set -euo pipefail

# プロジェクト外パスへの Read/Write/Edit を自動許可するフック
# Claude Code の既知バグ回避: プロジェクト外パスへの glob パターンが機能しない
# https://github.com/anthropics/claude-code/issues/40076
input=$(cat)

file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

if [ -z "$file_path" ]; then
  exit 0
fi

# 許可するパスのプレフィックス一覧
allowed_prefixes=(
  "/private/var/tmp/AgentsSandbox/"
  "/var/tmp/AgentsSandbox/"
  "/private/var/folders/"
  "/var/folders/"
  "/Users/hisakazu/Works/buildbystack/erp/"
  "/Users/hisakazu/Works/buildbystack/erp-1/"
  "/Users/hisakazu/Works/buildbystack/erp-2/"
)

for prefix in "${allowed_prefixes[@]}"; do
  if [[ "$file_path" == "${prefix}"* ]]; then
    jq -n '{
      "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "allow",
        "permissionDecisionReason": "Auto-approved by allow-workaround"
      }
    }'
    exit 0
  fi
done

exit 0
