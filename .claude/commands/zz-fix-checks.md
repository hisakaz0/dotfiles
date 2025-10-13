
GitHub の Pull Request の失敗しているチェックのログを次のコマンドを使って取得してください。


```sh
#!/bin/bash

set -e

# 現在のブランチ名を取得
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# PRを検索
PR_NUMBER=$(gh pr list --head "$CURRENT_BRANCH" --json number --jq '.[0].number')

if [ -z "$PR_NUMBER" ]; then
  echo "No PR found for branch: $CURRENT_BRANCH"
  exit 1
fi

echo "Found PR #$PR_NUMBER"
echo ""

# PRのチェック状態を取得
echo "Checking PR checks..."
FAILED_CHECKS_FILE="/tmp/failed_checks_pr_${PR_NUMBER}.txt"
gh pr checks "$PR_NUMBER" --json name,state,link --jq '.[] | select(.state == "FAILURE" or .state == "ERROR") | "\(.name)\t\(.state)\t\(.link)"' > "$FAILED_CHECKS_FILE"

if [ ! -s "$FAILED_CHECKS_FILE" ]; then
  echo "No failed checks found!"
  rm -f "$FAILED_CHECKS_FILE"
  exit 0
fi

echo "Failed checks:"
cat "$FAILED_CHECKS_FILE"
echo ""

# 失敗したチェックのログを取得
while IFS=$'\t' read -r name state url; do
  echo "=================================================="
  echo "Check: $name"
  echo "State: $state"
  echo "URL: $url"
  echo "=================================================="

  # URLからrun IDを抽出（runs/の後の数字）
  RUN_ID=$(echo "$url" | egrep -o 'runs/[0-9]+' | egrep -o '[0-9]+')

  if [ -n "$RUN_ID" ]; then
    echo "Fetching logs for run ID: $RUN_ID"
    gh run view "$RUN_ID" --log-failed
    echo ""
  else
    echo "Could not extract run ID from URL"
    echo ""
  fi
done < "$FAILED_CHECKS_FILE"

# クリーンアップ
rm -f "$FAILED_CHECKS_FILE"

echo "Done!"
```

ログからコードをどのように修正すればいいかどうか、ultrathink で考えてください。
修正方針が決まったらリスト形式にまとめたあと、そのまま処理を進めてください。

議論中の場合は一度確認を挟んでください。
