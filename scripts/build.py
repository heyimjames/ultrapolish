#!/usr/bin/env python3
"""
Build per-tool variants of the ultrapolish skills from the canonical sources.

Canonical source: /skills/<name>/SKILL.md + /skills/<name>/references/*.md
(Claude Code loads references on demand; every other tool gets them inlined.)

Usage:
    python3 scripts/build.py [tool]

tool: cursor | codex | aider | windsurf | continue | zed | all (default)

No external dependencies. Python 3 stdlib only.
"""

import re
import shutil
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO_ROOT / "skills"
DIST_DIR = REPO_ROOT / "dist"

SKILLS = ["ultrapolish-ios", "ultrapolish-web"]

SKILL_LABELS = {
    "ultrapolish-ios": "ultrapolish-ios: universal polish for Swift / SwiftUI apps",
    "ultrapolish-web": "ultrapolish-web: universal polish for React / TypeScript / CSS apps",
}

FILE_PREFIX = ""  # skill names already carry the brand

SKILL_GLOBS = {
    "ultrapolish-ios": ["**/*.swift"],
    "ultrapolish-web": [
        "**/*.tsx", "**/*.ts", "**/*.jsx", "**/*.js",
        "**/*.css", "**/*.scss", "**/*.html", "**/*.mdx", "**/*.astro", "**/*.vue", "**/*.svelte",
    ],
}

# Order references are inlined. Anything not listed is appended alphabetically.
REFERENCE_ORDER = [
    "audit-checklist.md",
    "design-contract-template.md",
    "anti-patterns.md",
]


def parse_skill(skill_dir: Path):
    """Return (frontmatter_dict, body_text) for skill_dir/SKILL.md."""
    content = (skill_dir / "SKILL.md").read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---\n(.*)", content, re.DOTALL)
    if not match:
        return {}, content
    fm_text, body = match.groups()
    fm, key, lines = {}, None, []
    for line in fm_text.split("\n"):
        if re.match(r"^[a-zA-Z][a-zA-Z0-9_-]*:", line):
            if key:
                fm[key] = "\n".join(lines).strip().strip('"').strip("'")
            key, _, value = line.partition(":")
            key = key.strip()
            lines = [value.strip()] if value.strip() else []
        elif line.strip() and key:
            lines.append(line.strip())
    if key:
        fm[key] = "\n".join(lines).strip().strip('"').strip("'")
    return fm, body.lstrip()


def load_references(skill_dir: Path) -> str:
    """Concatenate references/*.md in a stable order, each under an H2."""
    ref_dir = skill_dir / "references"
    if not ref_dir.exists():
        return ""
    names = sorted(p.name for p in ref_dir.glob("*.md"))
    ordered = [n for n in REFERENCE_ORDER if n in names] + [n for n in names if n not in REFERENCE_ORDER]
    parts = ["\n\n---\n\n# References\n\n",
             "Claude Code loads these on demand. In this build they are inlined in full.\n\n"]
    for name in ordered:
        text = (ref_dir / name).read_text(encoding="utf-8").strip()
        # Demote headings one level so the reference's own H1 sits under "# References".
        text = re.sub(r"^(#{1,5}) ", lambda m: "#" * (len(m.group(1)) + 1) + " ", text, flags=re.MULTILINE)
        parts.append(f"<!-- references/{name} -->\n\n{text}\n\n")
    return "".join(parts)


def full_body(skill_name: str, body: str) -> str:
    """SKILL.md body with references inlined and reference links rewritten."""
    skill_dir = SKILLS_DIR / skill_name
    # Links like references/motion.md become plain text anchors in a flat file.
    body = re.sub(r"\(references/([a-z0-9-]+)\.md\)", r"(see: \1 in References below)", body)
    body = re.sub(r"`references/([a-z0-9-]+)\.md`", r"the \1 reference below", body)
    return body.rstrip() + load_references(skill_dir)


def reset_dist():
    if DIST_DIR.exists():
        shutil.rmtree(DIST_DIR)
    DIST_DIR.mkdir()


def one_line(text: str) -> str:
    return " ".join(text.split())


# -------- Cursor -------------------------------------------------------------

def build_cursor(skills):
    out = DIST_DIR / "cursor" / ".cursor" / "rules"
    out.mkdir(parents=True, exist_ok=True)
    for name, (fm, body) in skills.items():
        globs = ", ".join(f'"{g}"' for g in SKILL_GLOBS[name])
        frontmatter = (
            "---\n"
            f"description: {one_line(fm.get('description', ''))}\n"
            f"globs: [{globs}]\n"
            "alwaysApply: false\n"
            "---\n\n"
        )
        (out / f"{FILE_PREFIX}{name}.mdc").write_text(frontmatter + body, encoding="utf-8")
        print(f"  ok cursor/.cursor/rules/{FILE_PREFIX}{name}.mdc")


# -------- Codex --------------------------------------------------------------

def build_codex(skills):
    out = DIST_DIR / "codex"
    out.mkdir(parents=True, exist_ok=True)
    parts = [
        "# ultrapolish\n\n",
        "Two universal design-polish skills. They make an existing interface better within its own\n",
        "visual style. They never introduce a palette, a typeface, or a motion personality.\n",
        "Read the section that matches the platform you are working on.\n\n",
        "## Index\n\n",
    ]
    for name in SKILLS:
        parts.append(f"- **{SKILL_LABELS[name]}**\n")
    parts.append("\n---\n\n")
    for name in SKILLS:
        fm, body = skills[name]
        parts.append(f"## {SKILL_LABELS[name]}\n\n")
        parts.append(f"_When to use this section: {one_line(fm.get('description', ''))}_\n\n")
        parts.append(body)
        parts.append("\n\n---\n\n")
    (out / "AGENTS.md").write_text("".join(parts), encoding="utf-8")
    print("  ok codex/AGENTS.md")


def build_aider(skills):
    out = DIST_DIR / "aider"
    out.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(DIST_DIR / "codex" / "AGENTS.md", out / "CONVENTIONS.md")
    print("  ok aider/CONVENTIONS.md")


def build_windsurf(skills):
    out = DIST_DIR / "windsurf"
    out.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(DIST_DIR / "codex" / "AGENTS.md", out / ".windsurfrules")
    print("  ok windsurf/.windsurfrules")


def build_continue(skills):
    out = DIST_DIR / "continue" / ".continue" / "rules"
    out.mkdir(parents=True, exist_ok=True)
    for name, (fm, body) in skills.items():
        frontmatter = (
            "---\n"
            f"name: {fm.get('name', name)}\n"
            f"description: {one_line(fm.get('description', ''))}\n"
            "---\n\n"
        )
        (out / f"{FILE_PREFIX}{name}.md").write_text(frontmatter + body, encoding="utf-8")
        print(f"  ok continue/.continue/rules/{FILE_PREFIX}{name}.md")


def build_zed(skills):
    out = DIST_DIR / "zed" / ".rules"
    out.mkdir(parents=True, exist_ok=True)
    for name, (fm, body) in skills.items():
        header = f"# {SKILL_LABELS[name]}\n\n_{one_line(fm.get('description', ''))}_\n\n---\n\n"
        (out / f"{FILE_PREFIX}{name}.md").write_text(header + body, encoding="utf-8")
        print(f"  ok zed/.rules/{FILE_PREFIX}{name}.md")


BUILDERS = {
    "cursor": build_cursor,
    "codex": build_codex,
    "aider": build_aider,
    "windsurf": build_windsurf,
    "continue": build_continue,
    "zed": build_zed,
}
ORDER = ["cursor", "codex", "aider", "windsurf", "continue", "zed"]  # aider/windsurf reuse codex


def main():
    tool = sys.argv[1] if len(sys.argv) > 1 else "all"
    if tool != "all" and tool not in BUILDERS:
        print(f"Unknown tool: {tool}\nAvailable: {', '.join(BUILDERS)}, all")
        sys.exit(1)

    print("Loading canonical skills...")
    skills = {}
    for name in SKILLS:
        skill_dir = SKILLS_DIR / name
        if not (skill_dir / "SKILL.md").exists():
            print(f"  missing: {skill_dir / 'SKILL.md'}")
            sys.exit(1)
        fm, body = parse_skill(skill_dir)
        skills[name] = (fm, full_body(name, body))
        refs = len(list((skill_dir / "references").glob("*.md"))) if (skill_dir / "references").exists() else 0
        print(f"  ok {name} ({refs} references inlined)")

    if tool == "all":
        print("\nBuilding all variants (clean dist/)...")
        reset_dist()
        for t in ORDER:
            print(f"\n{t}")
            BUILDERS[t](skills)
    else:
        if tool in ("aider", "windsurf") and not (DIST_DIR / "codex" / "AGENTS.md").exists():
            build_codex(skills)
        print(f"\n{tool}")
        BUILDERS[tool](skills)
    print("\nDone.")


if __name__ == "__main__":
    main()
