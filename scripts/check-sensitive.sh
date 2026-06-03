#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ROOT="$ROOT" python3 - <<'PY'
import os
import re
from pathlib import Path

root = Path(os.environ['ROOT'])
skip_dirs = {'.git', '__pycache__', '.pytest_cache', '.mypy_cache', '.ruff_cache'}
skip_suffixes = {'.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico'}
skip_files = {Path('scripts/check-sensitive.sh')}

patterns = [
    ('GitHub classic token', re.compile(r'gho_[A-Za-z0-9_]{20,}')),
    ('GitHub fine-grained token', re.compile(r'github_pat_[A-Za-z0-9_]{20,}')),
    ('OpenAI-style API key', re.compile(r'sk-[A-Za-z0-9]{20,}')),
    ('Bearer token', re.compile(r'Authorization:\s*Bearer\s+[A-Za-z0-9._~+/-]{20,}', re.I)),
    ('Assigned secret-like value', re.compile(r'(?i)(api[_-]?key|token|secret|password)\s*[:=]\s*[\"\']?[A-Za-z0-9_./+~=-]{16,}')),
    ('Local absolute user path', re.compile(r'/(Users|home)/[^\s\"\']+/(Data|Projects|Desktop|Documents|Downloads)/[^\s\"\']+')),
]

findings = []
for path in root.rglob('*'):
    rel = path.relative_to(root)
    if any(part in skip_dirs for part in rel.parts):
        continue
    if rel in skip_files or path.suffix.lower() in skip_suffixes:
        continue
    if not path.is_file():
        continue
    try:
        text = path.read_text(errors='ignore')
    except Exception as exc:
        findings.append((str(rel), 0, 'Unreadable file', str(exc)))
        continue
    for idx, line in enumerate(text.splitlines(), 1):
        for label, pattern in patterns:
            if pattern.search(line):
                findings.append((str(rel), idx, label, line.strip()))

if findings:
    for rel, line, label, content in findings:
        print(f'{rel}:{line}: {label}: {content}')
    raise SystemExit(1)
print('Sensitive scan passed.')
PY
