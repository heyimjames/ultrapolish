#!/usr/bin/env python3
"""Sanity-check the canonical skills before building or publishing."""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ["ultrapolish-ios", "ultrapolish-web"]
MAX_DESC = 1024
MAX_SKILL_LINES = 900
MAX_REF_LINES = 400
problems = []


def check_skill(name: str):
    d = ROOT / "skills" / name
    skill = d / "SKILL.md"
    if not skill.exists():
        problems.append(f"{name}: SKILL.md missing"); return
    text = skill.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    if not m:
        problems.append(f"{name}: no frontmatter"); return
    fm = m.group(1)
    nm = re.search(r"^name:\s*(.+)$", fm, re.M)
    if not nm or nm.group(1).strip() != name:
        problems.append(f"{name}: frontmatter name must be exactly '{name}'")
    desc = re.search(r"^description:\s*(.+?)(?=^\w+:|\Z)", fm, re.M | re.S)
    if not desc:
        problems.append(f"{name}: description missing")
    else:
        d_len = len(" ".join(desc.group(1).split()))
        if d_len > MAX_DESC:
            problems.append(f"{name}: description is {d_len} chars (max {MAX_DESC})")

    lines = text.count("\n") + 1
    if lines > MAX_SKILL_LINES:
        problems.append(f"{name}: SKILL.md is {lines} lines (soft max {MAX_SKILL_LINES})")

    # Every references/x.md link resolves, and every reference file is linked.
    linked = set(re.findall(r"references/([a-z0-9-]+\.md)", text))
    present = {p.name for p in (d / "references").glob("*.md")} if (d / "references").exists() else set()
    for ref in sorted(linked - present):
        problems.append(f"{name}: SKILL.md links references/{ref} which does not exist")
    for ref in sorted(present - linked):
        problems.append(f"{name}: references/{ref} is never linked from SKILL.md")
    for ref in sorted(present):
        n = (d / "references" / ref).read_text(encoding="utf-8").count("\n") + 1
        if n > MAX_REF_LINES:
            problems.append(f"{name}: references/{ref} is {n} lines (soft max {MAX_REF_LINES})")

    # Every assets/x link resolves.
    for a in set(re.findall(r"assets/([A-Za-z0-9_.-]+)", text + "".join(
            (d / "references" / r).read_text(encoding="utf-8") for r in present))):
        a = a.rstrip(".")
        if not (d / "assets" / a).exists():
            problems.append(f"{name}: assets/{a} is referenced but missing")

    # House rule: no em-dashes inside the skills themselves.
    for p in [skill, *(d / "references").glob("*.md"), *(d / "assets").glob("*")]:
        if "—" in p.read_text(encoding="utf-8", errors="ignore"):
            problems.append(f"{name}: em-dash found in {p.relative_to(ROOT)}")


for s in SKILLS:
    check_skill(s)

for mf in [".claude-plugin/marketplace.json", ".claude-plugin/plugin.json"]:
    p = ROOT / mf
    if not p.exists():
        problems.append(f"{mf} missing")
    else:
        import json
        try:
            json.loads(p.read_text())
        except json.JSONDecodeError as e:
            problems.append(f"{mf}: invalid JSON ({e})")

if problems:
    print("validate: FAIL")
    for p in problems:
        print("  -", p)
    sys.exit(1)
print("validate: ok")
