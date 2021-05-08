#!/usr/bin/env bash
set -euo pipefail

chia start $1

while true; do sleep 30; done;
