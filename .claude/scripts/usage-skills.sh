#!/bin/bash
# 過去N日間のスキル利用状況を集計する
# Usage: usage-skills.sh [days] (default: 30)
DAYS="${1:-30}"
find ~/.claude/projects/-Users-hisakazu-Works-buildbystack-erp* -name "*.jsonl" -mtime -"${DAYS}" -print0 | xargs -0 rg -oNI '"name":"Skill","input":\{"skill":"[^"]*"' -- 2>/dev/null | rg -o '"skill":"[^"]*"' | sort | uniq -c | sort -rn
