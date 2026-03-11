#!/bin/bash

# デバッグ: 常にログに記録
echo "HOOK_CALLED: $(date)" >> /tmp/hook-test.log

# 標準入力からJSON入力を読み取る
input=$(cat)
echo "INPUT: $input" >> /tmp/hook-test.log

# tool_nameとcommandを抽出（jq失敗時は空文字列）
tool_name=$(echo "$input" | jq -r '.tool_name // ""' 2>/dev/null || true)
command=$(echo "$input" | jq -r '.tool_input.command // ""' 2>/dev/null || true)
echo "TOOL: $tool_name CMD: $command" >> /tmp/hook-test.log

# Bashツールの呼び出しのみをチェック
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

# コマンドに erp-server-prod または erp-server-staging が含まれているかチェック
if echo "$command" | grep -q 'erp-server-prod' || echo "$command" | grep -q 'erp-server-staging'; then
  message="⚠️ erp-server-prod または erp-server-staging を含むコマンドは実行できません"
  echo "BLOCKING: $command" >> /tmp/hook-test.log

  printf '{"continue": false, "suppressOutput": false, "systemMessage": "%s"}\n' "$message"
  exit 2
fi

exit 0
