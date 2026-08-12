#!/bin/bash
# macOS の通知センターへ通知を発火する。
# 使い方: notify.sh <title> <body> [sound]
#   sound を省略すると "Ping" を鳴らす。"none" を渡すと無音にする。
# title / body は AppleScript の argv 経由で渡すため、引用符やバックスラッシュを含んでもエスケープ不要。
set -euo pipefail

usage() {
	gcat >&2 <<'USAGE'
使い方: notify.sh <title> <body> [sound]
  title  通知のタイトル（必須）
  body   通知の本文（必須）
  sound  サウンド名（省略時 Ping。"none" で無音）
         例: Ping / Glass / Hero / Submarine / Basso
USAGE
	exit 2
}

if [[ $# -lt 2 || $# -gt 3 ]]; then
	usage
fi

title="$1"
body="$2"
sound="${3:-Ping}"

if [[ -z "$title" ]]; then
	echo "ERROR: title が空です" >&2
	usage
fi

if [[ "$(uname)" != "Darwin" ]]; then
	echo "ERROR: macOS 以外では実行できません (uname=$(uname))" >&2
	exit 1
fi

if [[ "$sound" == "none" ]]; then
	osascript \
		-e 'on run argv' \
		-e 'display notification (item 2 of argv) with title (item 1 of argv)' \
		-e 'end run' \
		"$title" "$body"
else
	osascript \
		-e 'on run argv' \
		-e 'display notification (item 2 of argv) with title (item 1 of argv) sound name (item 3 of argv)' \
		-e 'end run' \
		"$title" "$body" "$sound"
fi
