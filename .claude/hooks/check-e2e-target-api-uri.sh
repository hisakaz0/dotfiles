#!/bin/bash
set -euo pipefail

# 標準入力からJSON入力を読み取る
input=$(cat)

# tool_nameとcommandを抽出
tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Bashツールの呼び出しのみをチェック
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

# コマンドに E2E_TARGET_API_URI が含まれているかチェック
if echo "$command" | grep -q 'E2E_TARGET_API_URI'; then
  # 適切にエスケープされたJSONでClaudeにシステムメッセージを出力
  message="⚠️ E2E_TARGET_API_URIは自動で設定されるため、指定不要です"

  jq -n --arg msg "$message" '{
    continue: false,
    suppressOutput: false,
    systemMessage: $msg
  }'
  exit 2  # exit 2でstderrをClaudeにフィードバック
fi

# 問題が見つからない場合は続行を許可
exit 0
