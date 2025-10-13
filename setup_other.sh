#!/usr/bin/env bash

set -eu

: "other tools" && {
	echo
	echo ">>> install other tools..."
	# On macOS and Linux.
	curl -LsSf https://astral.sh/uv/install.sh | sh
}

