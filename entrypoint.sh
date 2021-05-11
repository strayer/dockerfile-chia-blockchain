#!/usr/bin/env bash
set -eo pipefail

if [[ ! -f "$KEYFILE" ]]; then
  echo "Warning: $KEYFILE not found/mounted! No wallet keys configured." >&2
else
  chia keys add -f "$KEYFILE" >/dev/null
fi

exec "$@"
