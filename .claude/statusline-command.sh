#!/bin/bash

# stdinからJSONを読み込む
input=$(cat)

# 現在のディレクトリをJSONから取得
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# ホームディレクトリを ~ に省略
home_dir="$HOME"
display_cwd="${cwd/#$home_dir/~}"

# gitブランチを取得（gitリポジトリの場合）
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" describe --tags --exact-match 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_branch="$branch"
  fi
fi

# モデル表示名を取得
model_name=$(echo "$input" | jq -r '.model.display_name // "unknown"')

# context利用率を取得
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# compaction閾値（CLAUDE_AUTOCOMPACT_PCT_OVERRIDE で変更可能、デフォルト 83%）
# デフォルト83 = 200kウィンドウでの観測値（buffer 16.5% を除いた実効容量）
compact_threshold="${CLAUDE_AUTOCOMPACT_PCT_OVERRIDE:-83}"

# compaction閾値基準で計算（context が閾値に達したら 100% 表示）
adjusted_pct=$(awk "BEGIN { v=$used_pct*100/$compact_threshold; print (v>100?100:v) }")
used_int=$(printf "%.0f" "$adjusted_pct")

# コンテキストバー（20文字）を生成
bar_length=20
filled=$(( used_int * bar_length / 100 ))
empty=$(( bar_length - filled ))

bar=""
for i in $(gseq 1 $filled); do
  bar="${bar}█"
done
for i in $(gseq 1 $empty); do
  bar="${bar}░"
done

# バーの色（50%超: 黄色、80%超: 赤色）
if [ "$used_int" -ge 80 ]; then
  bar_color="\033[31m"  # 赤
elif [ "$used_int" -ge 50 ]; then
  bar_color="\033[33m"  # 黄
else
  bar_color="\033[32m"  # 緑
fi

# ANSIカラーコード
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

# 5時間ウィンドウのsession usageを取得（キャッシュ付き）
# APIのrate limitが厳しいため、180秒キャッシュで回数を抑制する
USAGE_CACHE="/tmp/claude-usage-cache.json"
session_usage=""
week_usage=""

# キャッシュファイルの経過秒数を計算（ファイルがなければ999秒=古い扱い）
cache_age=999
if [ -f "$USAGE_CACHE" ]; then
  cache_age=$(( $(date +%s) - $(stat -f %m "$USAGE_CACHE" 2>/dev/null || echo 0) ))
fi

# キャッシュが180秒以上古い場合はAPIから取得してキャッシュを更新する
if [ "$cache_age" -gt 180 ]; then
  # macOS KeychainからOAuthトークンを取得（JSON内の accessToken フィールドを抽出）
  token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
  if [ -n "$token" ]; then
    # バックグラウンドでAPI呼び出し（ブロッキング回避）、tmp経由で原子的書き込み
    ( curl -sf --max-time 5 \
      -H "Authorization: Bearer $token" \
      -H "anthropic-beta: oauth-2025-04-20" \
      "https://api.anthropic.com/api/oauth/usage" > "${USAGE_CACHE}.tmp" 2>/dev/null
      if [ -f "${USAGE_CACHE}.tmp" ]; then
        mv "${USAGE_CACHE}.tmp" "$USAGE_CACHE"
      fi ) &
    disown
  fi
fi

# resets_at（ISO 8601 UTC）から残り時間ラベルを計算する共通関数
# 引数: $1 = resets_at 文字列 (例: "2026-03-11T13:00:00.366359+00:00")
# 出力: 残り時間ラベル (例: "2h", "45m", "1d8h")
remaining_label() {
  local resets_at="$1"
  local dt_part="${resets_at%%.*}"  # sub-seconds を除去
  local reset_epoch
  reset_epoch=$(TZ=UTC date -j -u -f "%Y-%m-%dT%H:%M:%S" "$dt_part" "+%s" 2>/dev/null)
  local now diff d h m
  now=$(date +%s)
  diff=$(( reset_epoch - now ))
  if [ "$diff" -le 0 ]; then
    echo "0m"
    return
  fi
  d=$(( diff / 86400 ))
  h=$(( (diff % 86400) / 3600 ))
  m=$(( (diff % 3600) / 60 ))
  if [ "$d" -ge 1 ] && [ "$h" -gt 0 ]; then echo "${d}d${h}h"
  elif [ "$d" -ge 1 ]; then echo "${d}d"
  elif [ "$h" -gt 0 ]; then echo "${h}h"
  else echo "${m}m"
  fi
}

# キャッシュから resets_at と utilization を取得して表示文字列を生成
if [ -f "$USAGE_CACHE" ]; then
  # --- 5時間ウィンドウ ---
  five_hour_resets=$(jq -r '.five_hour.resets_at // empty' "$USAGE_CACHE" 2>/dev/null)
  five_hour_util=$(jq -r '.five_hour.utilization // empty' "$USAGE_CACHE" 2>/dev/null)
  if [ -n "$five_hour_resets" ]; then
    five_remaining=$(remaining_label "$five_hour_resets")
    five_hour_int=$(printf "%.0f" "${five_hour_util:-0}")
    # 使用率に応じて色分け: 80%以上=赤、50%以上=黄、未満=緑
    if [ "$five_hour_int" -ge 80 ]; then
      usage_color="\033[31m"
    elif [ "$five_hour_int" -ge 50 ]; then
      usage_color="\033[33m"
    else
      usage_color="\033[32m"
    fi
    session_usage="  ${usage_color}🕔️ ${five_remaining} ${five_hour_int}%%${RESET}"
  fi

  # --- 7日ウィンドウ ---
  seven_day_resets=$(jq -r '.seven_day.resets_at // empty' "$USAGE_CACHE" 2>/dev/null)
  seven_day_util=$(jq -r '.seven_day.utilization // empty' "$USAGE_CACHE" 2>/dev/null)
  if [ -n "$seven_day_resets" ]; then
    seven_remaining=$(remaining_label "$seven_day_resets")
    seven_day_int=$(printf "%.0f" "${seven_day_util:-0}")
    # 使用率に応じて色分け: 80%以上=赤、50%以上=黄、未満=緑
    if [ "$seven_day_int" -ge 80 ]; then
      week_color="\033[31m"
    elif [ "$seven_day_int" -ge 50 ]; then
      week_color="\033[33m"
    else
      week_color="\033[32m"
    fi
    week_usage="  ${week_color}📅 ${seven_remaining} ${seven_day_int}%%${RESET}"
  fi
fi

# 1行表示: ディレクトリ | ブランチ | モデル | コンテキストバー | セッション使用率
if [ -n "$git_branch" ]; then
  printf "${CYAN}📁 %s${RESET}  ${GREEN}🌿 %s${RESET}  ${YELLOW}💪 %s${RESET}  🧠 ${bar_color}[%s]${RESET} %d%%${session_usage}${week_usage}\n" \
    "$display_cwd" "$git_branch" "$model_name" "$bar" "$used_int"
else
  printf "${CYAN}📁 %s${RESET}  ${YELLOW}💪 %s${RESET}  🧠 ${bar_color}[%s]${RESET} %d%%${session_usage}${week_usage}\n" \
    "$display_cwd" "$model_name" "$bar" "$used_int"
fi
