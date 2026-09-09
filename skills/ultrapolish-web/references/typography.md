# Typography

Use this when you are setting a type scale, styling text in components, truncating or wrapping, tuning line-height and tracking, loading fonts, or auditing text for hierarchy and legibility.
Pair with `references/layout-and-spacing.md` for measure and rhythm and `references/accessibility.md` for zoom and reflow.

## Rules

1. **Never introduce a typeface during polish.** Polish works inside the project's faces. A review checklist is not a reason to license or add a font. A face introduced by the polish pass (Inter or any other) is a tell, not an improvement. Check: the font stack after your changes equals the font stack before.
2. **Roles carry hierarchy; three sizes do most of the work.** Display, title, heading, body, caption. Most screens use three of them. If a screen needs a sixth size, the hierarchy is the problem, not the scale.
3. **Emphasis within a role is one weight step.** 400 to 500, or 500 to 600. Never a size change, never bold-plus-colour-plus-italic. Check: no element uses two emphasis devices at once.
4. **Line-height by role, always unitless.** Headings about 1.1; body 1.5–1.6; anything that wraps to three or more lines needs at least 1.4, even inside a tight row. A unit value stops scaling when the user zooms the text.
5. **Letter-spacing by size.** Large headings slightly negative (−0.02em at 28px+), small uppercase labels positive (+0.05em), body untouched. One value for all sizes is wrong at both ends.
6. **Measure 60–75 characters.** `max-width: 65ch` on prose. At 16px that is roughly 560–680px, Tailwind `max-w-xl` or `max-w-2xl`. Wider reads as a wall; narrower reads as a column of fragments.
7. **Wrap by length.** `text-wrap: balance` on headings, and know it is silently ignored past 6 lines in Chromium and 10 in Firefox. `text-wrap: pretty` on paragraphs, descriptions, captions, card text. Neither on long-form; the cost is paid on every reflow.
8. **Break what must not overflow.** `overflow-wrap: break-word` (or `anywhere`) on IDs, URLs, and user strings. `white-space: nowrap` on labels, badges, and buttons. Truncate with `text-overflow: ellipsis` only when the full value is reachable elsewhere (tooltip, detail view).
9. **Weight floors.** Below 18px stay at 400 or above. Weights 100–300 are display-only, 28px and up. Thin text at small sizes disappears on non-Retina screens and in dark mode.
10. **Size floors.** Long-form body about 16px; UI text 14px; captions 13px; 12px rarely and never for anything the user must read to act.
11. **Inputs are at least 16px on mobile.** Below 16px iOS Safari zooms the page on focus. Use `font-size: max(16px, 1rem)` or Tailwind `text-base sm:text-sm`. Never `maximum-scale=1` or `user-scalable=no`: Safari ignores it for pinch, every other browser honours it, and it fails WCAG 1.4.4.
12. **Properties over raw OpenType tags.** `font-weight: 650`, not `font-variation-settings: "wght" 650`. `font-variant-numeric: tabular-nums`, not `font-feature-settings: "tnum"`. `font-optical-sizing: auto`, not `"opsz"`. Raw tags only for custom axes (`"GRAD" 80`) and stylistic sets (`ss01` to `ss20`, `cv01` to `cv99`).
13. **Tabular numbers on anything that changes.** Counters, timers, live prices, table number columns, animated values, scores. Not on static display numbers, decorative large numerals, phone numbers, postcodes, or version strings; tabular figures widen the 1 and look spaced-out at rest.
14. **Formats and loading.** `.woff2` only; `.woff` as a legacy fallback if the project supports old browsers; `.ttf` and `.otf` never on the web. `font-display: swap` for body faces, `optional` for decorative ones. Preload the one body face used above the fold. Use `size-adjust` on the fallback to stop the swap from shifting layout.
15. **Font smoothing once, on the root.** `-webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;` (Tailwind `antialiased`). Not per component.
16. **Underlines come from the font.** `text-underline-position: from-font; text-decoration-thickness: from-font;` or manual `text-decoration-thickness: 1px; text-underline-offset: 3px; text-decoration-skip-ink: auto;`. Only `text-decoration-color` animates reliably; if the underline must grow or slide, build it as a separate element.
17. **Trim the leading box in badges and buttons.** `text-box: trim-both cap alphabetic` (Chromium 133+, Safari 18.2+, no Firefox) as a progressive enhancement. Without it, centre text optically with 1px asymmetric padding rather than pretending the box is centred.
18. **Smart punctuation.** Curly quotes, en dash for ranges, ellipsis as one character, `&nbsp;` between a number and its unit, `&shy;` for long compound words. Em-dashes in interface copy are a house decision recorded in the design contract; the default is none.
19. **Bidi and script.** Never reverse digits. Paragraphs of three or more lines align to their own script's direction with `text-align: start` and a correct `lang`/`dir`. Wrap mixed-direction values (usernames, file names) in `<bdi>`.
20. **Text stays selectable.** Including application chrome. `user-select: none` only on an element with a verified drag or gesture conflict.
21. **`font-synthesis` only after verifying.** Turn synthesis off only when every bold, italic, small-cap, superscript, and subscript form exists across the full fallback stack. Prefer the longhands (`font-synthesis-weight: none`).
22. **Variable-font axis honesty.** A face's weight axis may run 350–900 or 425–625, not 100–900. Map named weights (regular, medium, semibold, bold) to real axis values in exactly one place, and let every renderer (DOM, canvas, export) read that map. A "semibold" that resolves to the same number as "bold" is a bug you find at 2am.
23. **Pair for contrast, not similarity.** Rarely more than three faces. A serif with a sans, a mono for data. "Display" in a font's name does not make it a display face; pick by size, and if the family ships Text and Display cuts, switch at about 20px.
24. **X-height explains size mismatch.** Two faces at the same `font-size` look different sizes because their x-heights differ. Retune size and line-height per face; never swap faces at a fixed size.
25. **Ligatures on in prose, off wherever a character must be read on its own.** `font-variant-ligatures: common-ligatures` is the default and should stay. Set `none` on anything a person has to transcribe, compare, or read aloud: codes, licence keys, serial numbers, IDs, passwords, filenames. An `fi` ligature in a booking reference is a character somebody cannot type back. Check: set a code field to a string containing `fi`, `fl` and `ffi` and confirm the glyphs stay separate.
26. **Zeros that cannot be an O, wherever it matters.** `font-variant-numeric: slashed-zero` on codes, keys, IDs, and anything read over a phone. Not in prose, where a slashed zero reads as technical for no reason. Check: render `O0` in every code field; the two are unmistakable.
27. **Figures have two jobs and one screen should not mix them.** Lining figures (the default) sit at cap height and belong in UI, tables, and anything aligned. Oldstyle figures (`font-variant-numeric: oldstyle-nums`) have ascenders and descenders and belong in running prose set in a serif, where lining figures shout. Pick per context and never both in one view. `diagonal-fractions` for real fractions, `ordinal` for `1st`, rather than superscript markup.
28. **Real small caps, never faked ones.** `font-variant-caps: small-caps` uses drawn glyphs with the correct stroke weight. `text-transform: uppercase` at a smaller size produces letters that are too light for their neighbours, which is visible even to people who cannot name what is wrong. If the face has no small caps, do not use small caps. Check: set both next to each other at 14px and compare stroke weight.
29. **Stylistic sets are a house choice, applied once at the root.** `font-feature-settings: "ss01"` for an alternate single-storey `a`, a straight-tailed `l`, a different `g`. Decide once, record it in the design contract, and set it on `:root` so the whole product agrees. A stylistic set applied to one component is how a product ends up with two typefaces that are the same typeface. Check: grep `font-feature-settings`; every stylistic set is declared in one place.

## Cheat sheet

| Role | Size | Line-height | Weight | Tracking |
|---|---|---|---|---|
| Display | 2.25rem / 36px | 1.1 | 600 | −0.02em |
| Title | 1.5rem / 24px | 1.2 | 600 | −0.01em |
| Heading | 1.125rem / 18px | 1.3 | 600 | 0 |
| Body | 1rem / 16px | 1.5 | 400 | 0 |
| Caption | 0.8125rem / 13px | 1.4 | 400 | 0 |
| Uppercase label | 0.75rem / 12px | 1 | 500 | +0.05em |

| Tabular numbers | Use | Do not use |
|---|---|---|
| | counters, timers, updating prices, table number columns, animated transitions, scores | static display numbers, decorative large numerals, phone numbers, postcodes, version strings |

| Wrapping | Property |
|---|---|
| Headings up to 6 lines | `text-wrap: balance` |
| Paragraphs, cards, captions | `text-wrap: pretty` |
| Long-form (10+ lines) | neither |
| IDs, URLs, user strings | `overflow-wrap: anywhere` |
| Labels, badges, buttons | `white-space: nowrap` |

| Punctuation | Use |
|---|---|
| Quotes | “ ” ‘ ’ |
| Range | 2010–2020 (en dash) |
| Ellipsis | … (one character) |
| Number and unit | `16&nbsp;px` |
| Long compound | `super&shy;calif…` |

## Code

Root and roles (example scale; the project's values win):

```css
html {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
}
h1, h2, h3 { text-wrap: balance; }
p, li, figcaption { text-wrap: pretty; }
input, select, textarea { font-size: max(16px, 1rem); }
.prose { max-width: 65ch; line-height: 1.55; }
.display { font-size: 2.25rem; line-height: 1.1; font-weight: 600; letter-spacing: -0.02em; }
.tnum { font-variant-numeric: tabular-nums; }
.eyebrow { font-size: 0.75rem; line-height: 1; font-weight: 500; letter-spacing: 0.05em; text-transform: uppercase; }
a { text-decoration-thickness: from-font; text-underline-position: from-font; text-underline-offset: 3px; transition: text-decoration-color 200ms ease-out; }
.badge { text-box: trim-both cap alphabetic; } /* progressive enhancement */
```

Font loading with a size-adjusted fallback (example):

```css
@font-face {
  font-family: "Body";
  src: url("/fonts/body.woff2") format("woff2");
  font-weight: 300 800;
  font-display: swap;
}
@font-face {
  font-family: "Body Fallback";
  src: local("Arial");
  size-adjust: 97%;
  ascent-override: 92%;
}
:root { --font-body: "Body", "Body Fallback", system-ui, sans-serif; }
```

Axis map in one place (example):

```ts
export const FONTS = {
  brand: { family: "Brand Sans", axis: [425, 625] as const, weights: { regular: 425, medium: 525, semibold: 575, bold: 625 } },
  mono:  { family: "Brand Mono", axis: [400, 700] as const, weights: { regular: 400, medium: 500, semibold: 600, bold: 700 } },
} as const;
// Every renderer (DOM class, canvas ctx.font, export) reads FONTS.brand.weights.semibold, never a literal 600.
```

Tailwind mapping: `text-base sm:text-sm` for inputs, `tabular-nums`, `text-balance`, `text-pretty`, `antialiased`, `tracking-tight` (−0.025em) on display, `tracking-wide` (+0.025em) on uppercase labels, `max-w-prose` (65ch).

## Checks

- Font stack unchanged after polish.
- Every text element maps to one of five roles; no ad-hoc sizes.
- Zoom to 200%: nothing clips, nothing overlaps.
- Width 320px: headings balance, prose wraps, labels do not break mid-word.
- Grep for `font-feature-settings: "tnum"` and `"wght"`: replaced with properties.
- Inputs measure ≥ 16px on a phone; no `maximum-scale` in the viewport meta.
- Every changing number has `tabular-nums`; every static display number does not.
- Long German and Finnish strings in labels do not overflow.
- Selection works on every text element; `user-select: none` only where a gesture conflicts.

## Do not

- Add a typeface, or swap one, as part of a polish pass.
- Use size to emphasise inside a role.
- Set line-height in `px`.
- Apply one letter-spacing to every size.
- Use `balance` on long-form or on anything that can exceed six lines.
- Ship `.ttf`, `.otf`, or an icon font.
- Turn off `font-synthesis` without testing every form.
- Rely on the browser to centre text vertically in a small box.
