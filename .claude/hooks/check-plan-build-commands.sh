#!/bin/bash
set -euo pipefail

# 標準入力からJSON入力を読み取る
input=$(cat)

# ツール名とファイルパスを抽出
tool_name=$(echo "$input" | jq -r '.tool_name // ""')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Writeツールのプランファイルへの呼び出しのみをチェック
if [[ "$tool_name" != "Write" ]]; then
  exit 0
fi

# プランファイル(.claude/plansディレクトリ内)かどうかをチェック
if [[ ! "$file_path" =~ \.claude/plans/ ]]; then
  exit 0
fi

# tool_inputから書き込まれた内容を取得
content=$(echo "$input" | jq -r '.tool_input.content // ""')

# 内容に go build または go tool gqlgen コマンドが含まれているかチェック
if echo "$content" | grep -qE '(go build|go tool gqlgen)'; then
  # 適切にエスケープされたJSONでClaudeにシステムメッセージを出力
  message="⚠️ プランファイルに \`go build\` または \`go tool gqlgen\` コマンドが含まれています。\\n\\nMakefileを確認して、適切な make target を実行してください。\\n\\n例:\\n- \`make gen\` - コード生成\\n- \`make build\` - ビルド\\n- \`make gen_server\` - サーバーコード生成\\n\\n直接 \`go build\` や \`go tool gqlgen\` を実行するのではなく、Makefileで定義されたターゲットを使用してください。"

  jq -n --arg msg "$message" '{
    continue: true,
    suppressOutput: false,
    systemMessage: $msg
  }'
  exit 2  # exit 2でstderrをClaudeにフィードバック
fi

# 問題が見つからない場合は続行を許可
exit 0
