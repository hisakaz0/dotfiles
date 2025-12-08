#!/bin/bash

set -e

# ログ行数のデフォルト値
LOG_LINES="${1:-100}"

# 現在のブランチ名を取得
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"
echo "Log lines: $LOG_LINES"

# PRを検索
PR_NUMBER=$(gh pr list --head "$CURRENT_BRANCH" --json number --jq '.[0].number')

if [ -z "$PR_NUMBER" ]; then
  echo "No PR found for branch: $CURRENT_BRANCH"
  exit 1
fi

echo "Found PR #$PR_NUMBER"
echo ""

# PRの最新コミットSHAを取得
LATEST_COMMIT=$(gh pr view "$PR_NUMBER" --json headRefOid --jq '.headRefOid')
echo "Latest commit: $LATEST_COMMIT"
echo ""

# 最新コミットに対するチェック状態を取得
echo "Checking latest commit checks..."
FAILED_CHECKS_FILE="/tmp/failed_checks_pr_${PR_NUMBER}.txt"

# 最新コミットに対するcheck-runsを取得（GitHub Actionsのチェック）
gh api "/repos/:owner/:repo/commits/$LATEST_COMMIT/check-runs" --jq '.check_runs[] | select(.conclusion == "failure" or .conclusion == "error" or .conclusion == "cancelled") | "\(.name)\t\(.conclusion)\t\(.html_url)"' > "$FAILED_CHECKS_FILE"

if [ ! -s "$FAILED_CHECKS_FILE" ]; then
  echo "No failed checks found!"
  rm -f "$FAILED_CHECKS_FILE"
  exit 0
fi

echo "Failed checks:"
cat "$FAILED_CHECKS_FILE"
echo ""

# 失敗したチェックのログを取得
cat "$FAILED_CHECKS_FILE" | while IFS=$'\t' read -r name state url; do
  echo "=================================================="
  echo "Check: $name"
  echo "State: $state"
  echo "URL: $url"
  echo "=================================================="

  # URLからrun IDを抽出（runs/の後の数字）
  RUN_ID=$(echo "$url" | egrep -o 'runs/[0-9]+' | egrep -o '[0-9]+')

  if [ -n "$RUN_ID" ]; then
    echo "Fetching jobs for run ID: $RUN_ID"

    # 失敗したJobを取得
    FAILED_JOBS=$(gh api "/repos/:owner/:repo/actions/runs/$RUN_ID/jobs" --jq '.jobs[] | select(.conclusion == "failure" or .conclusion == "cancelled") | "\(.id)\t\(.name)\t\(.conclusion)"')

    if [ -z "$FAILED_JOBS" ]; then
      echo "No failed jobs found in this run"
      echo ""
      continue
    fi

    echo "Failed jobs:"
    echo "$FAILED_JOBS"
    echo ""

    # 各失敗したJobのログを取得
    echo "$FAILED_JOBS" | while IFS=$'\t' read -r job_id job_name conclusion; do
      echo "--------------------------------------------------"
      echo "Job: $job_name (ID: $job_id)"
      echo "Conclusion: $conclusion"
      echo "--------------------------------------------------"

      # Jobの詳細なステップ情報を取得
      echo "Failed steps:"
      gh api "/repos/:owner/:repo/actions/jobs/$job_id" --jq '.steps[] | select(.conclusion == "failure") | "  - \(.name) (concluded: \(.conclusion))"'
      echo ""

      # Jobのログを取得
      echo "Job logs (last $LOG_LINES lines):"
      gh api "/repos/:owner/:repo/actions/jobs/$job_id/logs" --paginate 2>&1 | tail -n "$LOG_LINES"
      echo ""
      echo ""
    done

  else
    echo "Could not extract run ID from URL"
    echo ""
  fi
done

# クリーンアップ
rm -f "$FAILED_CHECKS_FILE"

echo "Done!"
