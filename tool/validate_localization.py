#!/usr/bin/env python3
"""Checks ARB locale parity, empty messages, duplicate keys, and placeholders."""
import json
import re
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1] / "lib" / "l10n"
files = sorted(root.glob("app_*.arb"))
if not files:
    print("No ARB files found", file=sys.stderr)
    sys.exit(1)

messages = {}
failed = False

def reject_duplicate_keys(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate key: {key}")
        result[key] = value
    return result

for path in files:
    try:
        data = json.loads(
            path.read_text(encoding="utf-8"), object_pairs_hook=reject_duplicate_keys
        )
    except (OSError, json.JSONDecodeError, ValueError) as error:
        print(f"{path.name}: {error}", file=sys.stderr)
        failed = True
        continue
    messages[path.stem] = {
        k: v for k, v in data.items()
        if not k.startswith("@@") and not k.startswith("@")
    }
    for key, value in messages[path.stem].items():
        if not isinstance(value, str) or not value.strip():
            print(f"{path.name}: {key} is empty or not a string")
            failed = True

if messages:
    base_name = next((name for name in messages if name.endswith("_en")), next(iter(messages)))
    base = messages[base_name]
    for name, data in messages.items():
        for key in sorted(base.keys() - data.keys()):
            print(f"{name}: missing {key}")
            failed = True
        for key in sorted(data.keys() - base.keys()):
            print(f"{name}: extra {key}")
            failed = True
        for key in base.keys() & data.keys():
            expected = set(re.findall(r"\{([A-Za-z][A-Za-z0-9_]*)\s*(?:,|})", str(base[key])))
            actual = set(re.findall(r"\{([A-Za-z][A-Za-z0-9_]*)\s*(?:,|})", str(data[key])))
            if expected != actual:
                print(f"{name}: placeholder mismatch for {key}: {actual} != {expected}")
                failed = True

sys.exit(1 if failed else 0)
