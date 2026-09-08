# Design contract template (web)

Use this when the project has no written design system, or when the intake table has empty rows. Fill it in with the project owner, commit it as `DESIGN.md` (or a section of `AGENTS.md`), and polish inside it. Fifteen lines is the target. If it needs more, the project has more than one style.

## Why a contract before polish

Polish applied without a contract produces a second style that competes with the first. Every later contributor (human or agent) will guess again. Fifteen lines stop the guessing.

## The template

```
# Design contract

1. Purpose: <one sentence: who this is for and the feeling it should leave>
2. Type: <faces by role; e.g. "System stack only" or "Brand Sans for everything, weight 400 to 600">. Roles: display <36/1.1/600>, title <24/1.2/600>, heading <18/1.3/600>, body <16/1.5/400>, caption <13/1.4/400>. Measure <65ch>.
3. Colour: <canvas light/dark, ink light/dark, ONE accent and what it means>. Tokens in OKLCH. Muted = ink at <0.62 / 0.45 / 0.28>. Semantic tokens only in components.
4. Dark mode: <mechanism: data-theme attribute flipping CSS variables>. Not a mirror: every pair re-checked. True black: <no>.
5. Grid: 4px. Container padding <16 mobile / 24 up>. Section rhythm <48 / 64>.
6. Radii: <e.g. 6 / 10 / 16>. Nested = outer minus padding. Pills <999px> for <chips only / buttons too>.
7. Depth: <"hairline box-shadow ring at ink 8%, no drop shadows" or "3-layer shadow-as-border light, single white ring dark">. Images outlined at 10%.
8. Motion: tokens in <motion.css / motion.ts>: micro <120ms ease>, enter <220ms quart-out>, exit <150ms accelerate>, spring <snappy 0.3/0.18> for gestures only. Named properties only. Stagger <40ms>, first appearance only. Reduced motion = crossfade.
9. Hover: <colour change only / colour plus 1px lift on links to pages>. Press: <0.97>. Focus: <browser ring + 2px offset / custom ring colour>.
10. Overlays: <library>. z-scale <100/200/300/400>. Sheets dismiss on velocity. Toasts <only for reversible global outcomes / never>.
11. Forms: inputs <40px / 44px> tall, ≥16px text, errors on the label row, submit always enabled, autocomplete set.
12. Icons: <family, stroke 1.5 at 20px> beside body; fill = active. Never a second family.
13. Copy: sentence case. Verb-first buttons naming the noun. Emoji in chrome: <no>. Em-dashes: <no>. Voice: <two adjectives>.
14. States: every list and fetch has empty, loading, error. Skeletons match structure. Nothing spins before 300ms.
15. Not allowed: <three things this project will never do, e.g. "scroll-triggered fade-ups, hover lift on cards, ALL-CAPS eyebrows">.
```

## A filled example (a fictional reading app, to show the density expected)

```
# Design contract

1. Purpose: a calm place to read saved articles. It should feel like paper, not a feed.
2. Type: system stack only (-apple-system, system-ui). Roles: display 32/1.15/600, title 22/1.25/600, heading 17/1.3/600, body 17/1.55/400 (reading), caption 13/1.4/400. Measure 68ch.
3. Colour: canvas #FFFFFF / #161616, ink #1A1A1A / #ECECEC, one accent: ochre oklch(0.72 0.12 75) meaning "saved". Muted = ink at 0.62 / 0.45 / 0.28. Components use --color-* semantic tokens only.
4. Dark mode: data-theme="dark" flips the variables. Every pair re-checked. True black: no.
5. Grid: 4px. Container 16 / 24. Section rhythm 48.
6. Radii: 6 / 10 / 16. Nested = outer minus padding. Pills 999px for chips only.
7. Depth: hairline ring at ink 8%, no drop shadows anywhere. Images outlined at 10%.
8. Motion: motion.css tokens: --ease 120ms, --ease-enter 220ms, --ease-exit 150ms; springs only on the reader sheet drag. Named properties. Stagger 40ms on first paint of the list. Reduced motion = crossfade.
9. Hover: colour only. Press 0.97. Focus: browser ring, 2px offset.
10. Overlays: native <dialog> and one Vaul sheet. z-scale 100/200/300/400. Toasts never; state shows inline.
11. Forms: inputs 44px, 16px text, errors on the label row, submit always enabled, autocomplete set.
12. Icons: Lucide at 1.5 stroke, 20px, fill = active.
13. Copy: sentence case, verb-first ("Save article", "Archive"). Emoji: no. Em-dashes: no. Voice: quiet, exact.
14. States: empty invites ("Save your first article from the share sheet"), skeletons match rows, nothing spins before 300ms.
15. Not allowed: scroll-triggered fades, hover lift, ALL-CAPS eyebrows, a second accent.
```

## Checks

- Every row has a value, not a question.
- Row 3 has exactly one accent with a stated meaning.
- Row 8 names a file. If the file does not exist, create it from `assets/motion.css`.
- Row 15 lists things the project is actually tempted by, not generic sins.
- The contract is committed before the first polish change lands.

## Do not

- Write a contract longer than a screen. Split styles, do not merge them.
- Fill rows with "TBD". An empty row is a finding; a TBD row is a lie.
- Let the contract restate this skill. It records the project's choices, not the skill's defaults.
