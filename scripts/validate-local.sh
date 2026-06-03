#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PYTHONPYCACHEPREFIX="${PYTHONPYCACHEPREFIX:-/tmp/dreamina-codex-plugin-pycache}"

python3 -m py_compile "$ROOT"/skills/dreamina-cli/scripts/*.py
ROOT="$ROOT" python3 - <<'PY'
import json
import os
from pathlib import Path
root = Path(os.environ['ROOT'])
manifest = json.loads((root / '.codex-plugin' / 'plugin.json').read_text())
required = ['name', 'version', 'description', 'skills', 'interface']
missing = [key for key in required if key not in manifest]
if missing:
    raise SystemExit(f'Missing manifest keys: {missing}')
interface = manifest['interface']
for key in ['displayName', 'shortDescription', 'longDescription', 'composerIcon', 'logo']:
    if key not in interface:
        raise SystemExit(f'Missing interface.{key}')
for rel in [interface['composerIcon'], interface['logo']]:
    path = root / rel
    if not path.exists():
        raise SystemExit(f'Missing asset: {rel}')
for rel in ['agents/openai.yaml', 'skills/dreamina-cli/SKILL.md', 'skills/dreamina-cli/agents/openai.yaml']:
    if not (root / rel).exists():
        raise SystemExit(f'Missing required file: {rel}')
print('Manifest and plugin files OK')
PY

if command -v dreamina >/dev/null 2>&1; then
  dreamina -h >/dev/null
else
  echo 'warning: dreamina CLI not found; plugin structure checks passed.' >&2
fi
