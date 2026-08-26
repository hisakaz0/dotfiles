#!/bin/bash
set -euo pipefail

# GitHub のコメント書き込みを検査する PreToolUse フック。
#
# 判定は 2 段階:
#   1. PR / Issue 全体へのコメント・レビュー投稿は無条件で deny する。
#      宛先が PR 全体のため、フックが bot 宛か人間宛かを判定できない。
#   2. 特定コメントへの返信・編集・削除は、投稿先の作者を GitHub API で引き、
#      bot なら通し、人間なら deny する。
#
# read 系の gh コマンドは素通りする。

input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // empty')
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

command=$(echo "$input" | jq -r '.tool_input.command // empty')

deny() {
  jq -n --arg reason "$1" --arg msg "$2" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    },
    systemMessage: $msg
  }'
  exit 0
}

# --- 0. Gemini へのレビュー依頼コマンドの例外 ---

# `/gemini review` は Gemini bot へレビューを依頼する指示コマンドで、人間宛の発言ではない。
# gemini-review スキルがこの投稿を前提にフローを組むため、この本文だけの投稿を通す。
# 本文が `/gemini review` と完全一致する呼び出しだけを対象にし、前後に他の文字が付く本文は通さない。
# PR 番号にはリテラルの数字に加えて `$PR_NUMBER` / `${PR_NUMBER}` 形式の変数も許可する。
# 宛先の PR を問わず本文が bot への指示コマンドに限る以上、番号の形は安全性に影響しない。
#
# 例外はコマンド全体の一致では判定しない。`REQUEST_AT=$(date -u ...) && gh pr comment ... --body "/gemini review"`
# のように、スキルの手順が基準時刻の取得やポーリングと 1 つの複合コマンドにまとめるためである。
# 代わりにレビュー依頼の呼び出しだけをコマンドから取り除き、残りに以降の判定をかける。
# こうすると複合コマンドの一部に紛れた他のコメント投稿を引き続き止められる。
gemini_review_pr='([0-9]+|"?\$\{?[A-Za-z_][A-Za-z0-9_]*\}?"?)'
gemini_review_body="(\"/gemini review\"|'/gemini review')"
gemini_review_call="gh pr comment[[:space:]]+${gemini_review_pr}[[:space:]]+--body[[:space:]]+${gemini_review_body}"

command_rest=$(printf '%s' "$command" | gsed -E "s#${gemini_review_call}##g" 2>/dev/null || printf '%s' "$command")

# --- 1. PR / Issue 全体へのコメント・レビュー投稿 ---

if echo "$command_rest" | grep -qE '\bgh (pr|issue) comment\b' \
  || echo "$command_rest" | grep -qE '\bgh pr review\b' \
  || echo "$command_rest" | grep -qE '\bgh api\b.*repos/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/issues/[0-9]+/comments' \
  || echo "$command_rest" | grep -qE '\bgh api\b.*repos/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pulls/[0-9]+/reviews' \
  || echo "$command_rest" | grep -qE '\bgh api\b.*graphql.*(addComment|addPullRequestReview)'; then
  deny \
    "PR / Issue 全体へのコメント・レビュー投稿を禁止する。CLAUDE.local.md が、人間のコメントへの返信を実行せずユーザへ提案するよう定めている。宛先が PR 全体のため、このフックは bot 宛か人間宛かを判定できない。" \
    "🚫 PR / Issue 全体へのコメント投稿を止めた。投稿する内容をユーザへ提案し、指示を待つこと。"
fi

# --- 2. 特定コメントへの返信・編集・削除 ---

# 書き込み操作かどうかを判定する。read 系は素通りする。
if ! echo "$command" | grep -qE '(--method|[[:space:]]-X)[[:space:]]+(POST|PATCH|PUT|DELETE)|[[:space:]](-f|-F|--field|--raw-field)[[:space:]]|/replies'; then
  exit 0
fi

target=$(echo "$command" | grep -oE 'repos/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/(pulls|issues)/comments/[0-9]+' | head -1)
if [ -z "$target" ]; then
  exit 0
fi

login=$(gh api "$target" --jq '.user.login' 2>/dev/null || true)

if [ -z "$login" ]; then
  deny \
    "投稿先コメント $target の作者を取得できなかった。bot のコメントか確認できないため止める。" \
    "🚫 投稿先コメントの作者を取得できなかったため止めた。"
fi

case "$login" in
*'[bot]')
  exit 0
  ;;
esac

deny \
  "投稿先コメント $target の作者 $login は人間である。CLAUDE.local.md が、人間のコメントへの返信・resolve・編集・削除を実行せずユーザへ提案するよう定めている。" \
  "🚫 人間（${login}）のコメントへの操作を止めた。内容をユーザへ提案し、指示を待つこと。"
