#!/bin/bash
# Notification フックが渡す JSON を読み、権限プロンプト (ask) のときだけ macOS の通知を出す。
# さらに Claude Code のペインをユーザが見ていないときに限って通知する。
#
# 「見ている」= tmux が次をすべて満たす状態と定義する。
#   1. Claude Code のセッションにクライアントがアタッチしている
#   2. Claude Code のウィンドウ・ペインを tmux が選択している
#   3. 外側ターミナル (VS Code の統合ターミナル) にフォーカスがある
# 3 は tmux の client_flags の focused で判定する。VS Code が最前面でない場合と、
# VS Code が最前面でもエディタ側へフォーカスが移った場合の両方で focused が落ちる。
# focus-events を on にし、クライアントを再アタッチした環境でだけ 3 が機能する。
# 判定できない場合 (tmux 外など) は見ていない扱いにし、通知を落とさない。
set -euo pipefail

# ユーザが Claude Code のペインを見ているかを判定する。
is_user_watching() {
	if [[ -z "${TMUX_PANE:-}" ]] || ! command -v tmux >/dev/null 2>&1; then
		return 1
	fi

	local state
	state=$(tmux display-message -p -t "$TMUX_PANE" '#{session_id} #{session_attached} #{window_active} #{pane_active}' 2>/dev/null) || return 1
	[[ -n "$state" ]] || return 1

	local session attached window_active pane_active
	read -r session attached window_active pane_active <<<"$state"
	[[ -n "$session" && -n "$attached" && -n "$window_active" && -n "$pane_active" ]] || return 1

	# 条件 1・2: セッションがアタッチ済みで、ウィンドウとペインを選択している。
	[[ "$attached" != 0 && "$window_active" == 1 && "$pane_active" == 1 ]] || return 1

	# 条件 3: セッションのクライアントのいずれかが外側ターミナルのフォーカスを持つ。
	tmux list-clients -t "$session" -F '#{client_flags}' 2>/dev/null | grep -qw 'focused'
}

if [[ "$(uname)" != "Darwin" ]]; then
	exit 0
fi

input=$(gcat)

# 権限プロンプト以外 (アイドル入力待ちなど) は通知しない。
notification_type=$(jq -r '.notification_type // ""' <<<"$input")
case "$notification_type" in
	permission_prompt | worker_permission_prompt) ;;
	*) exit 0 ;;
esac

if is_user_watching; then
	exit 0
fi

message=$(jq -r '.message // "入力を待っています"' <<<"$input")
cwd=$(jq -r '.cwd // ""' <<<"$input")
project=$(basename "${cwd:-$PWD}")

"$HOME/.claude/skills/mac-notify/notify.sh" "Claude Code: $project" "$message" || exit 0
