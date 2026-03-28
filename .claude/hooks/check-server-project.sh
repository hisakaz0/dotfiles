#!/bin/bash

# 意味ないので使わない。
exit 0

# 標準入力からJSON入力を読み取る
input=$(cat)

# tool_nameとcommandを抽出（jq失敗時は空文字列）
tool_name=$(echo "$input" | jq -r '.tool_name // ""' 2>/dev/null || true)
command=$(echo "$input" | jq -r '.tool_input.command // ""' 2>/dev/null || true)

# Bashツールの呼び出しのみをチェック
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

# コマンドに erp-server-prod または erp-server-staging が含まれているかチェック
if echo "$command" | grep -q 'erp-server-prod' ; then
  message="⚠️ erp-server-prod を含むコマンドは実行できません"

  printf '{"continue": false, "suppressOutput": false, "systemMessage": "%s"}\n' "$message"
  exit 2
fi

exit 0
