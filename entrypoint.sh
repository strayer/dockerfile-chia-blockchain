#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f "$KEYFILE" ]]; then
	echo "$KEYFILE not found/mounted!" >&2
  exit -1
fi

chia keys add -f "$KEYFILE" >/dev/null

exec "$@"
