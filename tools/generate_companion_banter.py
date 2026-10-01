#!/usr/bin/env python3
"""Validate companion banter SQL and export docs/COMPANION_BANTER.md.

Does not invent or overwrite conversations. The banter section in
data/sql/world.sql is the source of truth.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL = ROOT / "data/sql/world.sql"
OUT_MD = ROOT / "docs/COMPANION_BANTER.md"

comment_re = re.compile(
    r"^-- (\d+)[,\s]*\((\d+),\s*(neutral|Alliance|Horde),\s*(\d+)\)\s*(.*)$"
)
line_re = re.compile(r"^\((\d+),(\d+),(\d+),'(.*)'\)[,;]?$")
index_re = re.compile(r"^\((\d+),(\d+),(\d+),(\d+)\)[,;]?$")
FACTION_FROM_NAME = {"neutral": 0, "Alliance": 1, "Horde": 2}
FACTION_TO_NAME = {0: "Either faction", 1: "Alliance", 2: "Horde"}


def unescape(text: str) -> str:
    return text.replace("''", "'")


def parse_sql(path: Path):
    index = {}
    scripts = {}
    in_index = False
    in_lines = False
    current = None
    mid_deletes = []
    for lineno, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if line.startswith("DELETE FROM `companion_banter") and "BETWEEN 1 AND 1000" not in line:
            mid_deletes.append((lineno, line))
        if line.startswith("INSERT INTO `companion_banter_script`"):
            in_index, in_lines = True, False
            continue
        if line.startswith("INSERT INTO `companion_banter_line`"):
            in_index, in_lines = False, True
            continue
        if line.startswith("DELETE FROM") or line.startswith("CREATE TABLE"):
            in_index = False
            continue
        if in_index:
            m = index_re.match(line.rstrip(",;"))
            if m:
                sid, level, faction, speakers = map(int, m.groups())
                index[sid] = (level, faction, speakers)
            continue
        if not in_lines:
            continue
        cm = comment_re.match(line)
        if cm:
            sid = int(cm.group(1))
            current = {
                "id": sid,
                "comment_level": int(cm.group(2)),
                "comment_faction": FACTION_FROM_NAME[cm.group(3)],
                "comment_speakers": int(cm.group(4)),
                "title": cm.group(5).strip(),
                "lines": [],
            }
            scripts[sid] = current
            continue
        lm = line_re.match(line)
        if lm and current:
            current["lines"].append(
                (int(lm.group(2)), int(lm.group(3)), unescape(lm.group(4)))
            )
    return index, scripts, mid_deletes


def validate(index, scripts, mid_deletes) -> list[str]:
    errors = []
    if mid_deletes:
        errors.append(f"mid-file DELETE leftovers: {mid_deletes[:5]}")
    if set(index) != set(range(1, 1001)):
        missing = [i for i in range(1, 1001) if i not in index]
        extra = [i for i in index if i not in range(1, 1001)]
        errors.append(f"index ids not 1-1000 (missing {missing[:8]} extra {extra[:8]})")
    if set(scripts) != set(range(1, 1001)):
        missing = [i for i in range(1, 1001) if i not in scripts]
        errors.append(f"line scripts not 1-1000 (missing {missing[:8]})")
    if len(index) != 1000 or len(scripts) != 1000:
        errors.append(f"counts index={len(index)} scripts={len(scripts)} (need 1000)")

    for sid in range(1, 1001):
        if sid not in index or sid not in scripts:
            continue
        level, faction, speakers = index[sid]
        s = scripts[sid]
        lines = s["lines"]
        if not (1 <= level <= 60):
            errors.append(f"{sid}: min_level {level}")
        if faction not in (0, 1, 2):
            errors.append(f"{sid}: faction {faction}")
        if not (1 <= speakers <= 4):
            errors.append(f"{sid}: speaker_count {speakers}")
        if s["comment_level"] != level or s["comment_faction"] != faction or s["comment_speakers"] != speakers:
            errors.append(
                f"{sid}: comment ({s['comment_level']}, {s['comment_faction']}, {s['comment_speakers']}) "
                f"!= index ({level}, {faction}, {speakers})"
            )
        if not (3 <= len(lines) <= 10):
            errors.append(f"{sid}: line count {len(lines)}")
        indexes = [i for i, _, _ in lines]
        if indexes != list(range(len(lines))):
            errors.append(f"{sid}: line_index not sequential: {indexes}")
        slots = {slot for _, slot, _ in lines}
        if slots != set(range(speakers)):
            errors.append(f"{sid}: speaker slots {sorted(slots)} != 0..{speakers - 1}")
        texts = [t for _, _, t in lines]
        if any(not t or len(t) > 255 for t in texts):
            errors.append(f"{sid}: empty or overlong line")
        if len(set(texts)) != len(texts):
            errors.append(f"{sid}: duplicate line text")
    return errors


def write_markdown(index, scripts) -> None:
    ordered = []
    for sid in range(1, 1001):
        level, faction, speakers = index[sid]
        ordered.append((sid, level, faction, speakers, scripts[sid]))
    tiers = [("Levels 1–19", 1, 19), ("Levels 20–39", 20, 39),
             ("Levels 40–59", 40, 59), ("Level 60", 60, 60)]
    total_lines = sum(len(s["lines"]) for s in scripts.values())
    md = [
        "# Companion banter conversations",
        "",
        "All 1,000 conversations from the recruiter world data are collected here. "
        "The conversation ID matches `companion_banter_script.id` in the SQL migration. "
        "Minimum level applies to every speaking companion. Faction eligibility "
        "uses the recruiter's owner. Speaker numbers are roles assigned to distinct "
        "eligible companions when a conversation plays. A script may use a single speaker.",
        "",
        f"**Total:** {len(scripts)} conversations · {total_lines} spoken lines",
        "",
        "## Browse by minimum level",
        "",
    ]
    for heading, low, high in tiers:
        count = sum(low <= level <= high for _, level, _, _, _ in ordered)
        anchor = heading.lower().replace(" ", "-").replace("–", "")
        md.append(f"- [{heading}](#{anchor}) — {count} conversations")
    md.append("")

    for heading, low, high in tiers:
        md.extend([f"## {heading}", ""])
        tier = sorted(
            (row for row in ordered if low <= row[1] <= high),
            key=lambda row: (row[1], row[4]["title"].lower(), row[0]),
        )
        for sid, level, faction, speakers, script in tier:
            md.extend([
                f"### Conversation {sid:04d} — {script['title']}",
                "",
                f"**Minimum level:** {level}  ",
                f"**Faction:** {FACTION_TO_NAME[faction]}  ",
                f"**Speakers:** {speakers}  ",
                f"**Lines:** {len(script['lines'])}",
                "",
            ])
            for number, (_, slot, text) in enumerate(script["lines"], 1):
                md.append(f"{number}. **Companion {slot + 1}:** {text}")
            md.append("")

    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def main() -> int:
    index, scripts, mid_deletes = parse_sql(SQL)
    errors = validate(index, scripts, mid_deletes)
    if errors:
        print("companion banter validation failed:", file=sys.stderr)
        for err in errors[:50]:
            print(f"  {err}", file=sys.stderr)
        if len(errors) > 50:
            print(f"  ... {len(errors) - 50} more", file=sys.stderr)
        return 1
    write_markdown(index, scripts)
    speakers = sorted({index[s][2] for s in index})
    lengths = sorted({len(scripts[s]["lines"]) for s in scripts})
    print(
        f"validated {len(scripts)} scripts, "
        f"{sum(len(scripts[s]['lines']) for s in scripts)} lines; "
        f"speakers={speakers} lengths={lengths}; wrote {OUT_MD}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
