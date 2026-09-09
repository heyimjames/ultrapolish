# Surfaces and depth

Use this when you are styling cards, panels, overlays, images, borders, shadows, blur, or radii, or auditing why a page feels flat, muddy, or like a template.
Pair with `references/theming-and-dark-mode.md` for what depth becomes in the dark and `references/overlays.md` for modal and sheet motion.

## Rules

1. **A card needs a reason.** A card separates something that could be moved, selected, or acted on as a unit. Content that is simply a section gets space and a heading, not a box. The identical-rounded-card kit with the same grey shadow under each is the most recognisable template tell.
2. **Elevation is a step in value, not a shadow and not a line.** Surfaces separate because they are different tones of the same ground. Name the ladder as tokens and let every component pick a rung; nobody types a shadow and nobody draws a border to make a card visible. In the light the ground is the darkest rung and each layer above it is lighter; in the dark the ground is darkest and each layer is lighter too, so the direction of "up" never changes.

   | Rung | Light | Dark |
   |---|---|---|
   | `--ground` | `oklch(96.5% C H)` | `oklch(12% C H)` |
   | `--surface` | `oklch(98.5% C H)` | `oklch(16% C H)` |
   | `--raised` | `oklch(100% 0 0)` | `oklch(20% C H)` |
   | `--overlay` | `oklch(100% 0 0)` | `oklch(24% C H)` |

   Steps run about 2 to 3 points of L in the light and 3 to 4 in the dark, where flare and low screen brightness eat the difference. `C` and `H` are the palette's own, at a chroma of roughly 0.004 to 0.016, so the greys are never dead and light and dark read as one palette at two lightnesses. Check: screenshot two adjacent rungs, sample both, and confirm the L difference; if you cannot see the separation, increase the step rather than reaching for a border.
3. **Where a value step cannot work, and what to do instead.** Three cases. Over photography or video the ground is not a known value, so use a scrim or a material and set the text against that. Where two surfaces on the same rung must be told apart, such as rows inside one card, a hairline is correct because there is no step available; keep it to one place. Where the surface is transparent, the rung underneath is whatever scrolled behind it, so pick colours against the lightest and darkest content that can pass. Everywhere else, if two things are not separating, the step is too small. Check: grep for `border` and `box-shadow` on non-overlay components; each remaining one names which of these three cases it is.
4. **When a hairline is genuinely needed it is 1px, 0.5px on dense screens.** `--hairline: 1px`, overridden to `0.5px` at `min-resolution: 2dppx`. Anything thinner disappears; anything thicker reads as a rule, not a hairline. A grid of cards each drawn with its own outline is the template tell; the value step should be doing that work.
5. **Outline every user image.** `outline: 1px solid oklch(0 0 0 / 0.1)` in the light, `oklch(1 0 0 / 0.1)` in the dark, `outline-offset: -1px`. Pure black or white at 10%, never a tinted grey; a tinted outline reads as dirt on the image edge. Without it a white product shot floats loose on a white canvas.
6. **Hover moves a component up a rung.** Not a lift, not a new shadow: the background steps to the next tone over 150ms and nothing on the page moves. A card that translates upward is promising a click, so if the whole card is not a link it must not move. Check: hover a card and diff the two frames; only the background differs.
7. **Only true floating overlays get a drop shadow, and the scrim carries most of the meaning.** Popovers, menus, toasts, dragged items: `0 12px 32px oklch(0 0 0 / 0.18)`, tinted toward the canvas hue rather than neutral black. Cards, rows, and sections do not float and do not get one. When surfaces are separated by value rather than shadow, a shadow becomes a word with exactly one meaning, "this is above the page and can be dismissed", and it should never be spent on anything else. A modal says the same thing far more loudly with a scrim and the page pushed back; the shadow is a supporting detail there, not the mechanism.
8. **Bigger surfaces read thicker.** A full sheet gets a stronger blur and a deeper shadow than a tooltip. Depth cues scale with the size of the thing that is supposedly above the page.
9. **Never stack two translucent surfaces.** Legibility collapses; text on the upper one is fighting two backgrounds. The second layer becomes solid.
10. **Backdrop blur needs saturation and a budget.** `backdrop-filter: blur(20px) saturate(180%)`; without `saturate` it is grey mush. Two or three per screen, on static chrome (headers, bars, sheet frames) only. Never on a scrolling or animating element; it is the number-one frame killer.
11. **Never animate blur above 20px.** Static blur up to 50px is fine. Animating it is expensive, especially in Safari.
12. **Materialise, do not just fade.** When a translucent surface enters or leaves, animate blur and scale together with opacity (blur 4px to 0, scale 0.96 to 1). Opacity alone reads as a ghost appearing.
13. **Dim to focus, separate to keep flow.** A modal is surface plus scrim plus the page pushed back (scale 0.98, radius 12px). A side panel is translucency plus offset with no scrim, so the user stays in the flow.
14. **Vibrancy over translucency for text on materials.** Flat grey text on blur is unreadable. Use higher contrast, one weight step up, and a small tracking bump (+0.01em). Put colour on a solid layer, not on the material.
15. **Radii are concentric and few.** At most three values. Nested = outer − padding. Above 24px of padding, stop calculating; the layers are separate surfaces. See `references/layout-and-spacing.md`.
16. **Squircles only where the shape is load-bearing.** `corner-shape: superellipse(4)` (Chromium 139+) as a progressive enhancement for radii above 20px on hero surfaces. At small radii nobody can tell.
17. **Borders on media, shadows on surfaces.** Media (images, video, embeds) get the inset outline. Surfaces get the ring or the ladder. Mixing produces double edges.
18. **`isolation: isolate` on components with layered children.** It creates a stacking context so internal z-index never leaks into the page's scale. Prefer it over adding to the global z-scale.

## Cheat sheet

| Rung | Light | Dark |
|---|---|---|
| `--surface` (rest) | canvas, no shadow | canvas, no shadow |
| `--raised` (card, row group) | ring 0.06 + 2 soft layers | ring 0.08 |
| `--raised` hover | 0.08 / 0.08 / 0.06 | ring 0.13 |
| `--overlay` (popover, menu, toast) | ring + `0 12px 32px` at 0.18, tinted | slightly lighter surface + ring 0.10 |
| Image edge | `outline 1px oklch(0 0 0 / .1)` inset | `outline 1px oklch(1 0 0 / .1)` inset |
| Hairline | 1px, 0.5px at 2dppx | same, alpha 0.12 |

| Blur | Value | Where |
|---|---|---|
| Thin chrome | `blur(20px) saturate(180%)` at 30–50% alpha | headers, tab bars |
| Sheet frame | `blur(40px) saturate(180%)` at 65–80% alpha | sheets, side panels |
| Budget | 2–3 per screen | static only |
| Animated | never above 20px | enter/exit only |

## Code

Tokens (values are examples):

```css
:root {
  --hairline: 1px;
  --shadow-raised: 0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04);
  --shadow-raised-hover: 0 0 0 1px oklch(0 0 0 / 0.08), 0 1px 2px -1px oklch(0 0 0 / 0.08), 0 2px 4px 0 oklch(0 0 0 / 0.06);
  --shadow-overlay: 0 0 0 1px oklch(0 0 0 / 0.06), 0 12px 32px oklch(0.2 0.02 260 / 0.18); /* tinted toward the canvas hue */
  --outline-media: 1px solid oklch(0 0 0 / 0.1);
}
[data-theme="dark"] {
  --shadow-raised: 0 0 0 1px oklch(1 0 0 / 0.08);
  --shadow-raised-hover: 0 0 0 1px oklch(1 0 0 / 0.13);
  --shadow-overlay: 0 0 0 1px oklch(1 0 0 / 0.10);
  --outline-media: 1px solid oklch(1 0 0 / 0.1);
}
@media (min-resolution: 2dppx) { :root { --hairline: 0.5px; } }

.raised { background: var(--color-bg-raised); box-shadow: var(--shadow-raised); border-radius: var(--r-2); isolation: isolate; }
.raised:hover { box-shadow: var(--shadow-raised-hover); }
.overlay { background: var(--color-bg-overlay); box-shadow: var(--shadow-overlay); }
img, video, .embed { outline: var(--outline-media); outline-offset: -1px; }
```

Material chrome, with the reduced-transparency fallback:

```css
.bar {
  background: oklch(from var(--canvas) l c h / 0.72);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  box-shadow: 0 var(--hairline) 0 var(--hairline-color);
}
@media (prefers-reduced-transparency: reduce) {
  .bar { background: var(--canvas); backdrop-filter: none; }
}
.bar .title { font-weight: 500; letter-spacing: 0.01em; } /* vibrancy: weight and tracking, not opacity */
```

Materialise on enter:

```css
@keyframes materialise {
  from { opacity: 0; transform: scale(0.96); filter: blur(4px); }
  to   { opacity: 1; transform: scale(1);    filter: blur(0); }
}
.popover[data-state="open"] { animation: materialise 200ms cubic-bezier(0.165, 0.84, 0.44, 1); }
```

Modal push-back:

```css
body:has(dialog[open]) > main {
  transform: scale(0.98);
  border-radius: 12px;
  transition: transform 300ms cubic-bezier(0.16, 1, 0.3, 1), border-radius 300ms cubic-bezier(0.16, 1, 0.3, 1);
}
```

Squircle enhancement:

```css
.hero-card { border-radius: 28px; }
@supports (corner-shape: superellipse(4)) { .hero-card { corner-shape: superellipse(4); } }
```

Tailwind mapping: `shadow-[var(--shadow-raised)]` or a `@theme` `--shadow-raised` token used as `shadow-raised`; `outline outline-1 -outline-offset-1 outline-black/10 dark:outline-white/10` on images; `backdrop-blur-xl backdrop-saturate-[1.8]`; `isolate`.

## Checks

- Count distinct shadow declarations in the codebase; more than the ladder means someone typed one.
- Every `<img>` on a light and a dark canvas shows a visible edge.
- Dark theme: no dark shadow remains; rings are present.
- Count `backdrop-filter` per screen; none on a scrolling container or an animated element.
- Every `backdrop-filter` includes `saturate`.
- No two translucent surfaces overlap.
- Text on materials measured for contrast over the lightest and darkest scrolling content.
- Nested radii equal outer minus padding.
- Cards: each one names what unit it represents; sections without a unit lost their box.

## Do not

- Put the same shadow under every card.
- Use `border: 1px` where a ring avoids the layout shift.
- Tint the image outline toward the brand or a slate grey.
- Blur a scrolling list header that moves with the list.
- Animate `filter: blur()` beyond 20px.
- Stack a translucent popover on a translucent sheet.
- Type a shadow value in a component.
