#!/bin/bash
set -euo pipefail

# Notification hook: ログ書き込み + 通知判定を一体化
# - 通知発生時に stdin / 環境変数 / アクティブな background task をログに残す
# - notification_type == "idle_prompt" は background task が無く、かつ会話で Claude が
#   1 回でも応答済み (transcript の assistant 行が 1 件以上) の時だけ osascript で macOS 通知。
#   /clear 直後の空会話 (assistant 行 0 件) では通知しない
# - それ以外の notification_type は一旦そのまま通知 (傾向観察用)
# - 100,000 行を超えたら末尾を切り詰める

LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/notifications.jsonl"
MAX_LINES=100000
UID_NUM=$(id -u)

mkdir -p "$LOG_DIR"

input=$(cat)
timestamp=$(date "+%Y-%m-%dT%H:%M:%S%z")

# stdin が JSON でない場合は raw のままログだけ残して終了
if ! echo "$input" | jq -e . >/dev/null 2>&1; then
  raw=$(printf '%s' "$input" | jq -Rs .)
  printf '{"timestamp":"%s","parse_error":"stdin not json","stdin_raw":%s}\n' "$timestamp" "$raw" >> "$LOG_FILE"
  exit 0
fi

session_id=$(echo "$input" | jq -r '.session_id // ""')
cwd=$(echo "$input" | jq -r '.cwd // ""')
notification_type=$(echo "$input" | jq -r '.notification_type // ""')
message=$(echo "$input" | jq -r '.message // ""')
hook_event_name=$(echo "$input" | jq -r '.hook_event_name // ""')
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')

# 自セッションの tasks ディレクトリを特定
# 例: /private/tmp/claude-501/-Users-hisakazu-Works-buildbystack-erp/<session_id>/tasks
cwd_encoded=$(printf '%s' "$cwd" | gsed 's|/|-|g')
tasks_dir="/private/tmp/claude-${UID_NUM}/${cwd_encoded}/${session_id}/tasks"

tasks_json='[]'
active_tasks_json='[]'
if [ -n "$session_id" ] && [ -d "$tasks_dir" ]; then
  tasks=()
  active_tasks=()
  shopt -s nullglob
  for f in "$tasks_dir"/*.output; do
    [ -e "$f" ] || continue
    task_id=$(basename "$f" .output)
    tasks+=("$task_id")
    # lsof で誰かに open されていれば active と判定
    if lsof -- "$f" >/dev/null 2>&1; then
      active_tasks+=("$task_id")
    fi
  done
  shopt -u nullglob

  if [ ${#tasks[@]} -gt 0 ]; then
    tasks_json=$(printf '%s\n' "${tasks[@]}" | jq -R . | jq -cs .)
  fi
  if [ ${#active_tasks[@]} -gt 0 ]; then
    active_tasks_json=$(printf '%s\n' "${active_tasks[@]}" | jq -R . | jq -cs .)
  fi
fi

active_count=$(echo "$active_tasks_json" | jq 'length')

# transcript の assistant 応答数を数える (会話で Claude が 1 回でも応答したか判定する)
# /clear 直後の空会話は assistant 行が 0 件になるため、これで新規会話を識別する
assistant_count=0
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  assistant_count=$(jq -rs '[.[] | select(.type == "assistant")] | length' "$transcript_path" 2>/dev/null || echo 0)
fi

# 通知判定: idle_prompt は background が無く、かつ Claude が応答済みのときだけ通知。それ以外は一旦通知
if [ "$notification_type" = "idle_prompt" ]; then
  if [ "$active_count" -ne 0 ]; then
    notified=false
    notified_reason="idle_bg_active"
  elif [ "$assistant_count" -eq 0 ]; then
    # /clear 直後など Claude が未応答の新規会話では通知しない
    notified=false
    notified_reason="idle_fresh_conversation"
  else
    notified=true
    notified_reason="idle_no_bg"
  fi
else
  notified=true
  notified_reason="non_idle_event"
fi

if [ "$notified" = "true" ]; then
  osascript -e 'display notification "claude code" with title "Claude Code" subtitle "入力待ちです"' >/dev/null 2>&1 || true
fi

env_json=$(env | grep -E '^CLAUDE' | jq -cRn '[inputs | capture("^(?<k>[^=]+)=(?<v>.*)$") | {(.k):.v}] | add // {}')
stdin_json=$(echo "$input" | jq -c .)

jq -cn \
  --arg timestamp "$timestamp" \
  --arg session_id "$session_id" \
  --arg cwd "$cwd" \
  --arg notification_type "$notification_type" \
  --arg message "$message" \
  --arg hook_event_name "$hook_event_name" \
  --argjson tasks "$tasks_json" \
  --argjson active_tasks "$active_tasks_json" \
  --argjson assistant_count "$assistant_count" \
  --argjson notified "$notified" \
  --arg notified_reason "$notified_reason" \
  --argjson claude_env "$env_json" \
  --argjson stdin "$stdin_json" \
  '{timestamp:$timestamp, session_id:$session_id, cwd:$cwd, notification_type:$notification_type, message:$message, hook_event_name:$hook_event_name, tasks:$tasks, active_tasks:$active_tasks, assistant_count:$assistant_count, notified:$notified, notified_reason:$notified_reason, claude_env:$claude_env, stdin:$stdin}' \
  >> "$LOG_FILE"

# ローテーション
line_count=$(wc -l < "$LOG_FILE" | tr -d ' ')
if [ "$line_count" -gt "$MAX_LINES" ]; then
  tmp=$(mktemp)
  tail -n "$MAX_LINES" "$LOG_FILE" > "$tmp"
  mv "$tmp" "$LOG_FILE"
fi

exit 0
