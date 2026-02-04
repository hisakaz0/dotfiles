#!/bin/bash

# stdinからJSON入力を読み取る
input=$(cat)

# stop_hook_activeとtranscript_pathを取得
stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active // false')
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')

# stop_hook_activeがtrueの場合は無限ループ防止のためexit 0
if [ "$stop_hook_active" = "true" ]; then
    exit 0
fi

# transcript_pathが空の場合はexit 0
if [ -z "$transcript_path" ] || [ "$transcript_path" = "null" ]; then
    exit 0
fi

# transcript_pathが存在しない場合はexit 0
if [ ! -f "$transcript_path" ]; then
    exit 0
fi

# jsonlファイルから最後のassistant発言を取得
# role="assistant"のメッセージを抽出し、最後のものを取得
last_assistant_message=$(grep '"role":"assistant"' "$transcript_path" | tail -n 1)

# メッセージが存在しない場合はexit 0
if [ -z "$last_assistant_message" ]; then
    exit 0
fi

# メッセージに「完了しました」が含まれているかチェック
if echo "$last_assistant_message" | grep -q "完了しました"; then
    echo "本当に残り作業はありませんか？" >&2
    exit 2
fi

exit 0
