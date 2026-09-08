# Design contract template (iOS)

Use this when the project has no written design system, or when the intake table has empty rows. Fill it in with the project owner, commit it as `DESIGN.md` (or a section of `AGENTS.md`), and polish inside it. Fifteen lines is the target. If it needs more, the project has more than one style.

## Why a contract before polish

Polish applied without a contract produces a second style that competes with the first. Every later contributor (human or agent) will guess again. Fifteen lines stop the guessing.

## The template

```
# Design contract

1. Purpose: <one sentence: who this is for and the feeling it should leave>
2. Type: <faces by role; e.g. "SF Pro only. Rounded for glanceable numerals. No serif."> Spine: <e.g. 17 / 22 / 28>. Heaviest weight: <e.g. semibold>.
3. Colour: <base pair light/dark, ink pair, ONE accent and what it means>. Pick in OKLCH, ship in Display P3. Muted text = ink at <0.62 / 0.45 / 0.28>.
4. Dark mode: <"lower L, hold C and H" or "hand-tuned pairs in Assets">. True black: <yes for media chrome only / no>.
5. Grid: 4pt. Screen margin <20>. Card padding <16>. Hero air <24>.
6. Radii: <e.g. 8 / 14 / 24>, all .continuous. Pills are Capsule. Nested = outer minus padding.
7. Depth: <"no shadows; hairline 0.5pt at ink 10%" or "shadow 0.06/8/4 light, 1pt white 6% stroke dark">.
8. Motion: named presets in <Motion.swift>: press <0.16/0>, state <.snappy 0.24>, arrive <0.42/0.16>, calm <.smooth 0.3>, follow-finger <.linear>. Exits at 0.65x. Stagger <40ms>, first appearance only. Reduce Motion = 180ms crossfade.
9. Haptics: press-down .light; one .success per commit; .selection at detents; nothing on scroll. Signature moment: <one, or none>.
10. Sound: <none / 3-5 cues under 200ms, .ambient, toggle in Settings>.
11. Sheets: radius <28>, detents <.medium/.large by job>, drag indicator <visible unless Close exists>, inherit tint and scheme.
12. Icons: <SF Symbols, one weight matched to text> or <custom family, stroke 1.7 at 24>. Never both in one row. Fill = selected.
13. Copy: sentence case. Verb-first buttons naming the noun. Emoji in chrome: <no>. Em-dashes: <no>. Voice: <two adjectives>.
14. States: every list has empty, loading, error. Spinner after 500ms, where the result lands. Errors inline; toasts only for reversible global outcomes.
15. Not allowed: <three things this project will never do, e.g. "breathing icons, confetti on save, purple gradients">.
```

## A filled example (a fictional habit tracker, to show the density expected)

```
# Design contract

1. Purpose: a quiet daily companion for people who want to keep one habit. It should feel like a well-made notebook, not a dashboard.
2. Type: SF Pro only. Rounded for the streak numeral. Spine 17 / 22 / 28. Heaviest weight semibold.
3. Colour: base #FFFFFF / #141414 (P3), ink #1A1A1A / #EDEDED, one accent: moss (OKLCH 0.62 0.11 145) meaning "done". Muted = ink at 0.62 / 0.45 / 0.28.
4. Dark mode: lower L, hold C and H. True black: no.
5. Grid: 4pt. Screen margin 20. Card padding 16. Hero air 24.
6. Radii: 10 / 16 / 24, all .continuous. Pills are Capsule. Nested = outer minus padding.
7. Depth: no shadows. Hairline 0.5pt at ink 10%. Dark elevation = 1pt white 6% stroke.
8. Motion: Motion.swift presets: press 0.16/0, state .snappy(0.24), arrive 0.42/0.14, calm .smooth(0.3), follow-finger .linear. Exits 0.65x. Stagger 40ms on first appearance. Reduce Motion = 180ms crossfade.
9. Haptics: press-down .light; .success once when the day is marked; .selection crossing week boundaries. Signature: a soft two-tap when the streak rolls over.
10. Sound: none.
11. Sheets: radius 24, .medium for the picker, .large for edit, drag indicator visible, inherit tint.
12. Icons: SF Symbols, regular weight beside body, semibold beside headlines. Fill = selected.
13. Copy: sentence case. Verb-first ("Mark today", "Edit habit"). Emoji: no. Em-dashes: no. Voice: calm, plain.
14. States: empty invites ("Start with one habit"), loading is a matching skeleton after 500ms, errors inline under the field.
15. Not allowed: breathing icons, confetti, streak-loss guilt copy, any second accent.
```

## Checks

- Every row has a value, not a question.
- Row 3 has exactly one accent with a stated meaning.
- Row 8 names a file. If the file does not exist, create it from `assets/Motion.swift`.
- Row 15 lists things the project is actually tempted by, not generic sins.
- The contract is committed before the first polish change lands.

## Do not

- Write a contract longer than a screen. Split styles, do not merge them.
- Fill rows with "TBD". An empty row is a finding; a TBD row is a lie.
- Let the contract restate this skill. It records the project's choices, not the skill's defaults.
