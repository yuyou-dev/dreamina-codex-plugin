#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${DREAMINA_PLUGIN_TARGET:-$HOME/plugins/dreamina}"

mkdir -p "$TARGET"
rsync -a --delete \
  --exclude '.git/' \
  --exclude '__pycache__/' \
  --exclude '*.pyc' \
  "$ROOT/" "$TARGET/"

printf 'Dreamina Codex plugin installed to %s\n' "$TARGET"
printf 'Next: codex plugin add dreamina@<your-marketplace-name>\n'
