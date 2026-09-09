# Icons

Use this when you are choosing, sizing, colouring, animating, or auditing icons and the buttons built from them.
Pair with `references/typography.md` for weight matching and `references/accessibility.md` for names and announcements.

## Rules

1. **One family, everywhere.** Two icon sets in one interface never match in stroke, corner, or optical size. If a glyph is missing from the family, draw it in the family's grid; do not import a second set for one icon.
2. **Stroke matches the adjacent text weight.** 1.5px beside 400 text at 14–16px; 2px beside 500–600; 2.5px beside 700. An icon heavier than its label shouts; lighter, it disappears. Lucide's default stroke of 2 is heavy beside most body text: use 1.5–1.75 with `absoluteStrokeWidth` so the stroke does not scale with size.
3. **`currentColor` only.** Icons inherit the colour of the text they sit beside. No hardcoded fills, no per-icon colour props. Then every state (hover, disabled, selected, error) is one CSS rule on the parent.
4. **One asset per icon, recoloured per state.** Never two SVGs for "active" and "inactive" that differ only in fill. State is CSS.
5. **Two states: outline at rest, fill when active.** Outline is the default; the filled variant marks selected, on, or current. Three-state schemes (stroke, duotone, solid) triple the asset count for no gain in meaning.
6. **Size inline icons at 1em–1.25em.** They follow the type scale. Standalone icons use the family's native grids: 16, 20, 24. Never 18 or 22 from a 24-grid; the strokes land on half pixels and blur.
7. **Design and test at 16px.** If an icon is unreadable at 16px, simplify it. Detail that only reads at 32px is decoration.
8. **Icon-only controls have a name.** `aria-label` on the button, or a visually hidden label. A tooltip is not a name. See `references/accessibility.md`.
9. **Decorative SVGs are hidden; meaningful ones are images.** Decorative: `aria-hidden="true" focusable="false"`. Meaningful (the icon is the only content): `role="img"` with `aria-label`. An icon inside a labelled button is decorative.
10. **Optically align, then measure.** The icon-side padding of a button is 2px less than the text-side (`ps-4 pe-3.5` when the icon leads). A play triangle inside a circle shifts `translateX(2px)`. A square glyph in a circle renders at about 92% of the circle's diameter to look equal.
11. **Contextual swaps animate with fixed values.** Copy to check, plus to close, play to pause: scale 0.25 to 1, opacity 0 to 1, `blur(4px)` to 0, spring `{ type: "spring", duration: 0.3, bounce: 0 }`. Bounce is always 0 on an icon swap. Hold a success glyph 1.5s before reverting. CSS fallback: both icons in the DOM, one absolute, cross-fade with `cubic-bezier(0.2, 0, 0, 1)` over 300ms.
12. **Flip for RTL by meaning, not by default.** Flip glyphs that encode reading direction: back and forward chevrons, text-alignment and list glyphs, send arrows, volume waves, progress arrows. Do not flip logos, checkmarks, physical objects (a phone, a clock), media playback (play, fast-forward), or anything with text in it.
13. **Disabled icon buttons use a muted token.** `color: var(--color-icon-disabled)`, not `opacity: 0.4`. Opacity changes contrast unpredictably over different backgrounds.
14. **Inline SVG or sprite, never an icon font.** Icon fonts break with font loading, reflow on swap, and read as characters to assistive tech. Inline SVG for a handful; a `<symbol>` sprite with `<use>` for many.
15. **Corners follow the type.** A rounded typeface wants round-capped strokes; a sharp one wants square caps and joins. Check the family's `stroke-linecap` against the letterforms.
16. **No idle animation.** An icon that breathes, pulses, or wiggles while nothing is happening is the loudest template tell. Animate only on a state change, and pair it with the change.
17. **Selected state is the fill, not the colour.** A filled glyph in `currentColor` marks selection without the accent. The accent on a selected tab is a house choice; record it in the design contract.
18. **Rotate when the shape is the same at another angle; morph only when the geometry genuinely differs.** A chevron becoming a down-arrow, a plus becoming a cross, a caret flipping: these are one shape at two rotations, and rotating them is exact at every frame. Interpolating their coordinates instead makes the strokes bend and warp on the way, which is the wobble you see in a lot of otherwise careful icon animation. Reserve coordinate morphing for pairs that are actually different drawings, and give those a shared point count so the interpolation has somewhere sensible to go. A swap with no relationship at all crossfades. Check: play it at a tenth speed and watch the middle frame; if a straight line bows, it should have been a rotation.

## Cheat sheet

| Text weight | Icon stroke |
|---|---|
| 400 at 14–16px | 1.5px |
| 500–600 | 2px |
| 700 | 2.5px |

| Context | Size |
|---|---|
| Inline with text | 1em–1.25em |
| Standalone, dense UI | 16px |
| Toolbar, list rows | 20px |
| Navigation, hero controls | 24px |
| Touch target around any of these | 44px (40px pointer) |

| RTL | Flip | Do not flip |
|---|---|---|
| | chevron-left/right, arrow-left/right, back, forward, send, reply, undo/redo, align-left/right, list indent, volume, progress | logos, check, x, plus, minus, search, clock, phone, camera, play, pause, skip, anything containing letters |

| State | Mechanism |
|---|---|
| Hover | parent `color` change, ≤ 150ms |
| Active / selected | filled variant |
| Disabled | muted token |
| Swap (copy to check) | scale 0.25 to 1, blur 4 to 0, spring bounce 0, 300ms |

## Code

Inline icon that inherits everything:

```tsx
export function Icon({ children, size = "1em", ...rest }: React.SVGProps<SVGSVGElement> & { size?: string | number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor"
         strokeWidth={1.5} strokeLinecap="round" strokeLinejoin="round"
         aria-hidden="true" focusable="false" {...rest}>
      {children}
    </svg>
  );
}
```

Lucide with an honest stroke:

```tsx
import { Copy } from "lucide-react";
<Copy size={16} strokeWidth={1.5} absoluteStrokeWidth aria-hidden="true" />
```

Icon-only button with a name and a 44px target:

```tsx
<button type="button" aria-label="Copy link" className="icon-button">
  <Copy size={16} strokeWidth={1.5} absoluteStrokeWidth aria-hidden="true" />
</button>
```

```css
.icon-button { position: relative; inline-size: 32px; block-size: 32px; color: var(--color-icon); }
.icon-button::after { content: ""; position: absolute; inset: -6px; } /* 44px hit area */
.icon-button:hover { color: var(--color-icon-hover); transition: color 150ms ease; }
.icon-button:disabled { color: var(--color-icon-disabled); }
.icon-button[aria-pressed="true"] svg { fill: currentColor; } /* fill = active */
[dir="rtl"] .icon-directional { transform: scaleX(-1); }
```

Contextual swap, Motion:

```tsx
<AnimatePresence mode="wait" initial={false}>
  <motion.span key={copied ? "check" : "copy"}
    initial={{ scale: 0.25, opacity: 0, filter: "blur(4px)" }}
    animate={{ scale: 1, opacity: 1, filter: "blur(0px)" }}
    exit={{ scale: 0.25, opacity: 0, filter: "blur(4px)" }}
    transition={{ type: "spring", duration: 0.3, bounce: 0 }}>
    {copied ? <Check size={16} /> : <Copy size={16} />}
  </motion.span>
</AnimatePresence>
```

CSS-only swap, both glyphs in the DOM:

```css
.swap { position: relative; display: inline-grid; }
.swap > svg { grid-area: 1 / 1; transition: opacity 300ms cubic-bezier(0.2, 0, 0, 1), transform 300ms cubic-bezier(0.2, 0, 0, 1); }
.swap > .alt { opacity: 0; transform: scale(0.25); }
.swap[data-on] > .base { opacity: 0; transform: scale(0.25); }
.swap[data-on] > .alt { opacity: 1; transform: scale(1); }
```

Optical padding on a leading-icon button:

```css
.button-with-icon { padding-inline: 14px 16px; gap: 8px; } /* icon side 2px less */
.play-glyph { transform: translateX(2px); }
```

Tailwind mapping: `size-4` / `size-5` / `size-6`; `[&_svg]:size-4 [&_svg]:shrink-0` on buttons; `ps-3.5 pe-4`; `rtl:-scale-x-100` on directional icons.

## Checks

- Grep the bundle for a second icon package or an icon font.
- Every `<svg>` has either `aria-hidden="true"` or `role="img"` plus a label.
- Every icon-only `<button>` has `aria-label` or a hidden label.
- Stroke width beside body text is 1.5–1.75px, measured with the inspector.
- Sizes are 16, 20, or 24, or `1em`; no 18 or 22.
- `dir="rtl"` pass: chevrons and send flip; checks and logos do not.
- Hover and disabled use tokens; grep `opacity-40` on icon buttons returns nothing.
- Nothing animates at rest; the Animations panel is empty on an idle screen.

## Do not

- Mix two icon families.
- Hardcode fills or pass colour props per icon.
- Keep a filled and an outline SVG as separate assets for one state pair.
- Size a 24-grid icon at 18px or 22px.
- Use a tooltip as the only name for an icon button.
- Animate an icon while nothing happens.
- Ship an icon font.
