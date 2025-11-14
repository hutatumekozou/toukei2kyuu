#!/usr/bin/env python3
"""Utility helpers for maintaining Resources/questions/questions_ja3.json.

Usage examples:
  # Keep only the new 日本語検定3級カテゴリ（敬語/文法/語彙/意味/表記）
  python Scripts/manage_questions.py --keep-categories 敬語 文法 語彙 意味 表記

  # Drop legacy items whoseIDがKEI-で始まるものだけ削除
  python Scripts/manage_questions.py --drop-id-prefixes KEI-

The script always makes a timestamped backup next to the original JSON
before writing, unless --no-backup is set. No modifications occur if the
filters do not remove anything.
"""

from __future__ import annotations

import argparse
import datetime as _dt
import json
import pathlib
import shutil
import sys
from typing import Iterable, List

DEFAULT_PATH = pathlib.Path("Resources/questions/questions_ja3.json")


def _backup(source: pathlib.Path) -> pathlib.Path:
    timestamp = _dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    backup_path = source.with_suffix(source.suffix + f".bak-{timestamp}")
    shutil.copy2(source, backup_path)
    return backup_path


def _should_drop(question: dict, keep_categories: Iterable[str] | None,
                 drop_categories: Iterable[str] | None,
                 drop_prefixes: Iterable[str] | None) -> bool:
    category = question.get("category", "")
    qid = question.get("id", "")
    if keep_categories:
        if category not in keep_categories:
            return True
    if drop_categories and category in drop_categories:
        return True
    if drop_prefixes and any(qid.startswith(prefix) for prefix in drop_prefixes):
        return True
    return False


def main(argv: List[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Filter the 日本語検定3級 question bank in place.")
    parser.add_argument("--path", type=pathlib.Path, default=DEFAULT_PATH,
                        help="Path to the JSON question bank (default: %(default)s)")
    parser.add_argument("--keep-categories", nargs="*",
                        help="If provided, retain only questions whose category is in this list.")
    parser.add_argument("--drop-categories", nargs="*",
                        help="Remove any question whose category matches one of these values.")
    parser.add_argument("--drop-id-prefixes", nargs="*",
                        help="Remove any question whose id starts with one of these prefixes.")
    parser.add_argument("--no-backup", action="store_true",
                        help="Do not create a timestamped backup before writing.")
    args = parser.parse_args(argv)

    if not any([args.keep_categories, args.drop_categories, args.drop_id_prefixes]):
        parser.error("At least one filter (--keep-categories/--drop-categories/--drop-id-prefixes) is required.")

    path: pathlib.Path = args.path
    if not path.exists():
        parser.error(f"Question file not found: {path}")

    payload = json.loads(path.read_text(encoding="utf-8"))
    original_len = len(payload)

    filtered = [
        q for q in payload
        if not _should_drop(q, args.keep_categories, args.drop_categories, args.drop_id_prefixes)
    ]

    removed = original_len - len(filtered)
    if removed == 0:
        print("No questions matched the provided filters; nothing to do.")
        return 0

    if not args.no_backup:
        backup_path = _backup(path)
        print(f"Backup created: {backup_path}")

    path.write_text(json.dumps(filtered, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Removed {removed} questions (from {original_len} down to {len(filtered)}).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
