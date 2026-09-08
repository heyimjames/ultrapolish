# Colour

Use this when you are choosing, converting, checking, or auditing colour on the web: tokens, palettes, contrast, dark pairs, gamut, and how colour carries meaning.
Pair with `references/theming-and-dark-mode.md` for the switching mechanism and `references/surfaces-and-depth.md` for shadows and outlines.

## Rules

1. **Work in OKLCH.** It is perceptually uniform, so equal steps in L look equal and hue does not drift as you lighten. Format: `oklch(L C H / alpha)`, three decimals for L and C, integer or one decimal for H, `0` never `-0`. Check: no new colour is authored in hex or HSL; hex appears only as a legacy fallback.
2. **Do not convert notation because this skill loaded.** A project in hex that is consistent is not a finding. Convert only when the project asks, or when you are adding a token and the token file is already OKLCH.
3. **L above 0.73 wants dark text.** Below it, light text. The boundary is soft, so verify the pair with a contrast measurement rather than the rule. Check: every background token has a paired foreground that passes below.
4. **Measure contrast with APCA first, WCAG second.** APCA |Lc| targets: body 75 minimum and 90 preferred, non-body text 60 (75 preferred), large text at 36px+ 45 (60 preferred), UI components and icons 30, absolute floor 15. WCAG 2: 4.5:1 normal text, 3:1 large text (24px, or 18.5px bold) and UI. Report both when a client or regulator cares about WCAG.
5. **Mid-lightness backgrounds cap contrast.** On a background at L 0.75, even pure black text only reaches about Lc 60. If a surface sits between L 0.35 and 0.75, expect to move the surface, not the text.
6. **Fix contrast by adjusting L.** Hold C and H, move L until the pair passes, remeasure. Changing hue or chroma to fix contrast produces a colour that no longer matches its siblings.
7. **Report, do not repaint.** When auditing, list the failing pairs with measured values. Repaint only when asked; polish does not own the palette.
8. **Build scales by lightness, clamp chroma per step.** For a base colour, set `delta = 0.4`, `minL = max(0.05, baseL - 0.4)`, `maxL = min(0.95, baseL + 0.4)`, distribute L evenly across 50 to 950, then clamp each step's chroma to `(chroma% / 100) × maxChroma(L, H, space)`. Without the clamp, light and dark steps fall out of gamut and get silently pulled toward grey.
9. **Multi-hue palettes share L and chroma percentage, not absolute chroma.** At L 0.5 in sRGB, purple near H 285 can reach C 0.29 while cyan near H 195 peaks near 0.09. Same absolute C makes some hues look more vivid than others; same percentage of each hue's maximum keeps them siblings.
10. **One colour, one meaning.** A hue within ±15° of the accent on something non-interactive tells users to click it. Reserve the accent for the primary action and selected state; give status its own hues (success, warning, danger) and use each for exactly one thing.
11. **One filled primary per view, colour on the background.** `bg-accent text-on-accent` reads as the primary. Accent-coloured text on a neutral background reads as a link. A selected state may tint a glyph or label; that is state, not emphasis.
12. **Disabled uses a muted token, not opacity.** Opacity-based disabled states pass or fail contrast depending on what is behind them. A named token is predictable and testable.
13. **Semantic tokens in components, base tokens in one file.** Base tokens say what a value is (`--base-neutral-300`); semantic tokens say what it does (`--color-text-muted`, `--color-bg-raised`). Components reference semantic tokens only. Enforce it with a lint rule (a Stylelint `declaration-property-value-disallowed-list` on `var(--base-`, or a grep in CI) so nobody reaches past the semantic layer.
14. **Provide an increased-contrast variant.** Under `@media (prefers-contrast: more)`, widen the foreground/background lightness gap by at least 0.15 L, then re-verify at Lc 90 for body and 75 for non-body.
15. **Test colour on translucency over the extremes.** A colour on a `backdrop-filter` surface shifts with what scrolls behind it. Verify the pair over the lightest and darkest content the page can produce.
16. **Ship P3 as an enhancement.** sRGB value first, then the wider value inside `@supports (color: oklch(0 0 0))` nested in `@media (color-gamut: p3)`. Never let the P3 value be the only value.
17. **Make gain and loss per-locale tokens.** Red means gains in Chinese financial interfaces and losses in most Western ones; white carries mourning in parts of East Asia. Colour that encodes money or status must be a token the locale can swap.
18. **Dark mode is not a mirror.** Do not reverse the scale mechanically. See `references/theming-and-dark-mode.md`.

## Cheat sheet

| Measure | Body text | Non-body | Large (36px+) | UI / icons | Floor |
|---|---|---|---|---|---|
| APCA |Lc| | 75 min, 90 preferred | 60 min, 75 preferred | 45 min, 60 preferred | 30 | 15 |
| WCAG 2 | 4.5:1 (7:1 AAA) | 4.5:1 | 3:1 (4.5:1 AAA) | 3:1 | n/a |

| Situation | Move |
|---|---|
| Pair fails contrast | Adjust L only; remeasure |
| Surface at L 0.35–0.75 | Move the surface; text cannot fix it |
| Two hues look unequal in vividness | Match chroma percentage, not absolute C |
| Same hue as accent on a non-link | Change the hue or make it interactive |
| `opacity: .4` on disabled | Replace with a muted token |
| Hex in a project already on OKLCH | Convert on touch, not in bulk |

Hue drift proof, why HSL fails: `hsl(240 80% 20%)` converts to roughly OKLCH H 269; `hsl(240 80% 90%)` converts to roughly H 285. Same HSL hue, 16° of visible drift across one ramp. Anything beyond 10° across a scale is visible.

Culture table (example, extend per product):

| Meaning | Default (Western) | Chinese financial UIs | Note |
|---|---|---|---|
| Gain | green | red | token: `--color-gain` |
| Loss | red | green | token: `--color-loss` |
| Mourning | black | white (parts of East Asia) | avoid as a "clean" empty-state wash in those locales |

## Code

Token layers with a P3 enhancement (values are examples):

```css
/* tokens/base.css: private. Nothing outside tokens/ may reference --base-*. */
:root {
  --base-neutral-950: oklch(0.180 0.006 260);
  --base-neutral-050: oklch(0.985 0.003 260);
  --base-brand-600: oklch(0.560 0.160 262);
}

/* tokens/semantic.css: public. Components use only these. */
:root {
  --color-bg: var(--base-neutral-050);
  --color-text: var(--base-neutral-950);
  --color-text-muted: oklch(from var(--color-text) l c h / 0.62);
  --color-accent: var(--base-brand-600);
  --color-on-accent: var(--base-neutral-050);
  --color-text-disabled: oklch(from var(--color-text) l c h / 0.38); /* a token, not opacity on the element */
}

@media (color-gamut: p3) {
  @supports (color: oklch(0 0 0)) {
    :root { --base-brand-600: oklch(0.560 0.190 262); } /* example: more chroma, same L and H */
  }
}

@media (prefers-contrast: more) {
  :root {
    --color-text-muted: oklch(from var(--color-text) l c h / 0.80);
  }
}
```

Tailwind v4 scale in `@theme` (example values):

```css
@theme {
  --color-brand-50: oklch(0.970 0.020 262);
  --color-brand-500: oklch(0.623 0.141 262);
  --color-brand-900: oklch(0.300 0.090 262);
}
/* bg-brand-500/50 compiles to oklch(0.623 0.141 262 / 0.5) */
```

Multi-hue siblings, same L and same percentage of each hue's max chroma (example): `--blue-500: oklch(0.623 0.141 250)` (80% of 0.176), `--green-500: oklch(0.623 0.157 145)`, `--red-500: oklch(0.623 0.202 25)`.

Scale generation, in words, for a script: for each step L in the even distribution between `minL` and `maxL`, compute the maximum in-gamut chroma at that L and H for the target space, multiply by the base colour's chroma percentage, and emit `oklch(L C H)`. Libraries such as culori expose `clampChroma` for the gamut step.

Lint guard, Stylelint (example):

```json
{
  "rules": {
    "declaration-property-value-disallowed-list": {
      "/.*/": ["/var\\(--base-/"]
    }
  },
  "overrides": [{ "files": ["src/tokens/**/*.css"], "rules": { "declaration-property-value-disallowed-list": null } }]
}
```

## Checks

- Every background/foreground pair measured in both themes; values recorded in the findings table.
- Grep for `var(--base-` outside the token directory returns nothing.
- Grep for `opacity: 0.4` and `opacity-40` on disabled controls returns nothing.
- Only one filled accent element per view in the primary path.
- A screenshot of the page in greyscale still shows the primary action first.
- `@media (color-gamut: p3)` blocks all have an sRGB sibling outside them.
- Any hue used within ±15° of the accent is interactive.

## Do not

- Convert a consistent hex palette to OKLCH because this skill loaded.
- Fix contrast by darkening chroma or nudging hue.
- Put the accent on link text and on a button in the same view.
- Use `opacity` for disabled, muted, or placeholder states.
- Reverse a light palette to make the dark one.
- Ship a P3-only value.
- Introduce a second accent during polish. If the project needs one, it goes in the design contract first.
