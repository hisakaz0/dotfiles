#!/bin/bash
set -euo pipefail

# Bash ツールの timeout をコマンドに応じて動的に決める PreToolUse フック。
#
# difit はレビュー用サーバをユーザが閉じるまで起動し続けるため 1 時間を割り当てる。
# それ以外のコマンドは settings.json の BASH_DEFAULT_TIMEOUT_MS (10 分) に任せる。
#
# 1 時間を実際に適用するには BASH_MAX_TIMEOUT_MS が 3600000 以上である必要がある。
# Claude Code が BASH_MAX_TIMEOUT_MS で timeout の上限を切るため。

DIFIT_TIMEOUT_MS=3600000

input=$(cat)

tool_name=$(jq -r '.tool_name // ""' <<<"$input")
if [[ "$tool_name" != "Bash" ]]; then
	exit 0
fi

# モデルが timeout を明示したときは、その判断を尊重して上書きしない。
if [[ "$(jq -r '.tool_input.timeout // "null"' <<<"$input")" != "null" ]]; then
	exit 0
fi

command=$(jq -r '.tool_input.command // ""' <<<"$input")

# `difit` を単語として含むときだけ対象にする (`difitx` や `mydifit` は対象外)。
# `npx difit` や `cd foo && difit` のように前置きが付く形も拾う。
if ! grep -qE '(^|[^[:alnum:]_-])difit([^[:alnum:]_-]|$)' <<<"$command"; then
	exit 0
fi

# updatedInput が元の入力を置き換える場合に備え、tool_input 全体に timeout を足して返す。
jq -cn \
	--argjson toolInput "$(jq -c '.tool_input' <<<"$input")" \
	--argjson timeout "$DIFIT_TIMEOUT_MS" \
	'{
		hookSpecificOutput: {
			hookEventName: "PreToolUse",
			updatedInput: ($toolInput + {timeout: $timeout})
		}
	}'
