#!/usr/bin/env python3
"""Rebuild companion banter SQL: drop mill/retreads, assign unique replacements, trim keepers."""
from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

from banter_replacements import REPLACEMENTS, speaker_count as repl_speaker_count

ROOT = Path(__file__).resolve().parents[1]
SQL = ROOT / "data/sql/world.sql"
SQL_SECTION_START = "-- BEGIN SOURCE: data/sql/world/0003_companion_banter.sql"
SQL_SECTION_END = "-- END SOURCE: data/sql/world/0003_companion_banter.sql"

comment_re = re.compile(
    r"^-- (\d+)[,\s]*\((\d+),\s*(neutral|Alliance|Horde),\s*(\d+)\)\s*(.*)$"
)
line_re = re.compile(r"^\((\d+),(\d+),(\d+),'(.*)'\)[,;]?$")
index_re = re.compile(r"^\((\d+),(\d+),(\d+),(\d+)\)[,;]?$")

FACTION_FROM_NAME = {"neutral": 0, "Alliance": 1, "Horde": 2}
FACTION_TO_NAME = {0: "neutral", 1: "Alliance", 2: "Horde"}
KEEP_JOKE_IDS = {203, 204}
JOKE_OPENERS = ("what do you call", "why did the")
MONSTER_OPENERS = ("why are there so many",)
JOKE_CLOSERS = (
    "that's not funny",
    "it's a fact",
    "it's a bad fact",
    "it's still a fact",
    "it's still true",
    "you said that",
    "it's a little funny",
    "it's still not funny",
)


def unescape(text: str) -> str:
    return text.replace("''", "'")


def esc(text: str) -> str:
    return text.replace("\\", "\\\\").replace("'", "''")


def normalize(text: str) -> str:
    return " ".join(text.lower().replace("'", "").split())


def parse_sql(path: Path):
    index = {}
    scripts = {}
    in_index = False
    in_lines = False
    current = None
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
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
                "level": int(cm.group(2)),
                "faction": FACTION_FROM_NAME[cm.group(3)],
                "speakers": int(cm.group(4)),
                "title": cm.group(5).strip(),
                "lines": [],
            }
            scripts[sid] = current
            continue
        lm = line_re.match(line)
        if lm and current:
            current["lines"].append((int(lm.group(3)), unescape(lm.group(4))))
    return index, scripts


def classify(scripts):
    replacement_titles = {title.lower() for title, *_ in REPLACEMENTS}
    first_theme = {}
    reasons = {}
    for sid in sorted(scripts):
        s = scripts[sid]
        title = s["title"].lower()
        if title in replacement_titles:
            continue
        texts = [t.lower() for _, t in s["lines"]]
        opener = texts[0] if texts else ""
        joined = " ".join(texts)
        if sid in KEEP_JOKE_IDS:
            continue
        if any(opener.startswith(p) for p in JOKE_OPENERS) and any(c in joined for c in JOKE_CLOSERS):
            reasons[sid] = "joke-mill"
            continue
        if any(opener.startswith(p) for p in MONSTER_OPENERS):
            if sid > 100 or "monster talk" in title:
                reasons[sid] = "monster-opener"
                continue
        if "bad joke" in title:
            reasons[sid] = "joke-title"
            continue
        if title.endswith("again") or "yet again" in title:
            theme = title.replace(" yet again", "").replace(" again", "").strip()
            if theme in first_theme:
                reasons[sid] = f"retread:{theme}"
            else:
                first_theme[theme] = sid
    # Near-clone later scripts: share 2+ long normalized lines with an earlier keeper.
    seen_lines = {}
    for sid in sorted(scripts):
        if sid in reasons:
            continue
        norms = [normalize(t) for _, t in scripts[sid]["lines"] if len(t) >= 24]
        hits = defaultdict(int)
        for n in norms:
            if n in seen_lines:
                hits[seen_lines[n]] += 1
        if hits and max(hits.values()) >= 2:
            reasons[sid] = f"clone:{max(hits, key=hits.get)}"
        else:
            for n in norms:
                seen_lines.setdefault(n, sid)
    return reasons


def trim_lines(lines: list[tuple[int, str]]) -> list[tuple[int, str]]:
    """Drop circular restatements while keeping 3-10 unique lines and all speaker slots."""
    kept: list[tuple[int, str]] = []
    seen = set()
    for slot, text in lines:
        key = normalize(text)
        if key in seen:
            continue
        if kept:
            prev = normalize(kept[-1][1])
            if _restates(prev, key) and len(kept) >= 5:
                continue
        seen.add(key)
        kept.append((slot, text))
    while len(kept) > 8 and _is_filler(kept[-1][1]) and _speakers_ok(kept[:-1]):
        kept = kept[:-1]
    while len(kept) > 10 and _speakers_ok(kept[:-1]):
        kept = kept[:-1]
    if len(kept) > 10:
        # Last resort: drop from the end until 10, then restore any missing speaker
        # by keeping the earliest line for each slot.
        by_slot = {}
        others = []
        for slot, text in kept:
            if slot not in by_slot:
                by_slot[slot] = (slot, text)
            else:
                others.append((slot, text))
        kept = list(by_slot.values()) + others
        kept = kept[:10]
    if not _speakers_ok(kept) or len(kept) < 3:
        unique = _unique_lines(lines)[:10]
        kept = unique
    return _compact_speakers(kept)


def _compact_speakers(lines: list[tuple[int, str]]) -> list[tuple[int, str]]:
    remap = {}
    out = []
    for slot, text in lines:
        if slot not in remap:
            remap[slot] = len(remap)
        out.append((remap[slot], text))
    return out


def _unique_lines(lines):
    out = []
    seen = set()
    for slot, text in lines:
        key = normalize(text)
        if key in seen:
            continue
        seen.add(key)
        out.append((slot, text))
    return out


def _restates(a: str, b: str) -> bool:
    if a == b:
        return True
    short = {"fair", "good", "true", "both", "yes", "no", "fine", "exactly", "it is", "it isnt", "it isn't"}
    if b in short:
        return True
    for prefix in ("its ", "it's ", "thats ", "that's ", "then "):
        if b.startswith(prefix) and a.endswith(b[len(prefix):]):
            return True
    return False


def _is_filler(text: str) -> bool:
    n = normalize(text)
    return n in {
        "fair", "good", "true", "both", "yes", "no", "fine", "exactly", "it is",
        "thats true", "thats fair", "it is both", "same thing", "same thing usually",
    } or len(n.split()) <= 2


def _speakers_ok(lines: list[tuple[int, str]]) -> bool:
    if not lines:
        return False
    slots = {slot for slot, _ in lines}
    count = max(slots) + 1
    return slots == set(range(count)) and 1 <= count <= 4 and 3 <= len(lines) <= 10


def fix_904(script):
    script["title"] = "Tall tale, properly told"
    script["lines"] = [
        (0, "I once saw a man fight a bear with a frying pan."),
        (1, "Did he win?"),
        (0, "He won the fight."),
        (1, "And then?"),
        (0, "The bear's mother showed up."),
        (2, "That's not an end."),
        (0, "It is for him."),
    ]
    script["speakers"] = 3


def assign_replacements(scripts, reasons):
    replace_ids = sorted(reasons)
    pool = list(REPLACEMENTS)
    used = set()
    assigned = {}
    unmatched = []
    existing_titles = {
        scripts[sid]["title"] for sid in scripts if sid not in reasons
    }
    for i, repl in enumerate(pool):
        if repl[0] in existing_titles:
            used.add(i)

    def score(need_level, need_faction, repl):
        title, rlevel, rfaction, lines = repl
        if rfaction not in (0, need_faction) and need_faction != 0:
            return None
        if need_faction == 0 and rfaction != 0:
            # Faction-locked scene on a neutral slot is still playable, but prefer matching.
            penalty = 40
        elif need_faction != 0 and rfaction == 0:
            penalty = 25
        else:
            penalty = 0
        return penalty + abs(rlevel - need_level) * 2

    for sid in replace_ids:
        s = scripts[sid]
        best_i = None
        best_score = None
        for i, repl in enumerate(pool):
            if i in used:
                continue
            sc = score(s["level"], s["faction"], repl)
            if sc is None:
                continue
            if best_score is None or sc < best_score:
                best_score, best_i = sc, i
        if best_i is None:
            unmatched.append(sid)
            continue
        used.add(best_i)
        title, rlevel, rfaction, lines = pool[best_i]
        assigned[sid] = (title, lines)
        # Keep original min_level/faction; only dialogue and speaker_count change.
        _ = rlevel, rfaction
    return assigned, unmatched, used


def validate_script(sid, level, faction, lines):
    errors = []
    if not (1 <= level <= 60):
        errors.append(f"{sid}: bad level {level}")
    if faction not in (0, 1, 2):
        errors.append(f"{sid}: bad faction {faction}")
    if not (3 <= len(lines) <= 10):
        errors.append(f"{sid}: line count {len(lines)}")
    slots = {slot for slot, _ in lines}
    speakers = max(slots) + 1 if slots else 0
    if not (1 <= speakers <= 4) or slots != set(range(speakers)):
        errors.append(f"{sid}: speaker slots {sorted(slots)}")
    texts = [t for _, t in lines]
    if len(set(texts)) != len(texts):
        errors.append(f"{sid}: duplicate line text")
    if any(not t or len(t) > 255 for t in texts):
        errors.append(f"{sid}: empty or overlong line")
    return speakers, errors


def batched_insert(header, rows, batch_size):
    result = []
    for start in range(0, len(rows), batch_size):
        result.append(header)
        result.append(",\n".join(rows[start:start + batch_size]) + ";")
    return result


def write_sql(scripts):
    out = [
        "-- 1,000 original, level- and faction-gated companion party conversations.",
        "-- Hand-curated party banter; tools/generate_companion_banter.py validates and writes the docs.",
        "CREATE TABLE IF NOT EXISTS `companion_banter_script` (",
        "  `id` INT NOT NULL, `min_level` TINYINT UNSIGNED NOT NULL,",
        "  `faction` TINYINT UNSIGNED NOT NULL DEFAULT 0, `speaker_count` TINYINT UNSIGNED NOT NULL,",
        "  PRIMARY KEY (`id`)",
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;",
        "CREATE TABLE IF NOT EXISTS `companion_banter_line` (",
        "  `script_id` INT NOT NULL, `line_index` TINYINT UNSIGNED NOT NULL,",
        "  `speaker_slot` TINYINT UNSIGNED NOT NULL, `text` VARCHAR(255) NOT NULL,",
        "  PRIMARY KEY (`script_id`, `line_index`)",
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;",
        "DELETE FROM `companion_banter_line` WHERE `script_id` BETWEEN 1 AND 1000;",
        "DELETE FROM `companion_banter_script` WHERE `id` BETWEEN 1 AND 1000;",
    ]
    script_rows = []
    for sid in range(1, 1001):
        s = scripts[sid]
        script_rows.append(f"({sid},{s['level']},{s['faction']},{s['speakers']})")
    out += batched_insert(
        "INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES",
        script_rows,
        100,
    )
    out.append("")
    for start_id in range(1, 1001, 100):
        end_id = start_id + 99
        rows = []
        comment_lines = []
        for sid in range(start_id, end_id + 1):
            s = scripts[sid]
            comment_lines.append(
                (len(rows), f"-- {sid} ({s['level']}, {FACTION_TO_NAME[s['faction']]}, {s['speakers']}) {s['title']}")
            )
            for i, (slot, text) in enumerate(s["lines"]):
                rows.append(f"({sid},{i},{slot},'{esc(text)}')")
        out.append(
            "INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES"
        )
        pieces = []
        comment_map = {idx: text for idx, text in comment_lines}
        for i, row in enumerate(rows):
            prefix = ""
            if i in comment_map:
                if pieces:
                    prefix = "\n"
                prefix += comment_map[i] + "\n"
            suffix = "," if i != len(rows) - 1 else ";"
            pieces.append(prefix + row + suffix)
        out.append("\n".join(pieces))
        out.append("")
    source = SQL.read_text(encoding="utf-8")
    start = source.index(SQL_SECTION_START) + len(SQL_SECTION_START)
    end = source.index(SQL_SECTION_END, start)
    banter = "\n" + "\n".join(out).rstrip() + "\n"
    SQL.write_text(source[:start] + banter + source[end:], encoding="utf-8")


def main() -> int:
    index, scripts = parse_sql(SQL)
    if len(scripts) != 1000 or len(index) != 1000:
        print(f"parse mismatch index={len(index)} scripts={len(scripts)}", file=sys.stderr)
        return 1
    # Prefer header metadata for level/faction; comments should match.
    for sid, (level, faction, _speakers) in index.items():
        scripts[sid]["level"] = level
        scripts[sid]["faction"] = faction

    replacement_titles = {title for title, *_ in REPLACEMENTS}

    reasons = classify(scripts)
    assigned, unmatched, used = assign_replacements(scripts, reasons)
    if unmatched:
        print(f"unmatched replacements for {len(unmatched)} ids: {unmatched[:20]}", file=sys.stderr)
        return 1

    kept = trimmed = replaced = 0
    for sid in range(1, 1001):
        if sid == 904 and sid not in reasons:
            fix_904(scripts[sid])
            trimmed += 1
            continue
        if sid in assigned:
            title, lines = assigned[sid]
            scripts[sid]["title"] = title
            scripts[sid]["lines"] = lines
            scripts[sid]["speakers"] = repl_speaker_count(lines)
            replaced += 1
            continue
        if scripts[sid]["title"] in replacement_titles:
            kept += 1
            continue
        before = len(scripts[sid]["lines"])
        scripts[sid]["lines"] = trim_lines(scripts[sid]["lines"])
        scripts[sid]["speakers"] = max(slot for slot, _ in scripts[sid]["lines"]) + 1
        if len(scripts[sid]["lines"]) != before:
            trimmed += 1
        else:
            kept += 1

    all_errors = []
    for sid in range(1, 1001):
        s = scripts[sid]
        s["lines"] = _compact_speakers(_unique_lines(s["lines"]))
        speakers, errors = validate_script(sid, s["level"], s["faction"], s["lines"])
        s["speakers"] = speakers
        all_errors.extend(errors)
    if all_errors:
        raise SystemExit("validation failed:\n" + "\n".join(all_errors[:40]))

    write_sql(scripts)
    print(
        f"wrote {SQL}: replaced={replaced} trimmed={trimmed} kept={kept} "
        f"replacements_used={len(used)}/{len(REPLACEMENTS)} reasons={len(reasons)}"
    )
    from collections import Counter
    print("replace reasons:", Counter(reasons.values()).most_common(12))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
