# Native feel

**The default for app-like products, and wrong for site-like ones.** Everything universal lives in the neutral references; this file is the iOS-specific layer on top of them.

Decide which the project is before anything else:

| Shape | Examples | Default |
|---|---|---|
| App-like | A dashboard, an editor, a tool, a PWA, anything behind a login | This file, in full, unless the design contract opts out |
| Site-like | Marketing, documentation, a blog, a landing page | The neutral references only. Close this file |

Two things still outrank that default. A project with an established motion or type system keeps it, because the universality guard applies here exactly as it does everywhere else: these are defaults for projects without an established value, and a consistent existing token always wins. And a design contract that says "this is not an iOS app" closes the file regardless of shape.

Do not use it to make a marketing site feel iOS. A dense data tool is app-like and takes the layer, but its own documented row heights and timings win wherever they exist, which in a mature tool is most places.

**It is all or nothing.** A partial native layer feels worse than none, because the half that behaves natively teaches people to expect the other half. A sheet that drags but does not carry its velocity into the settle is worse than a sheet that does not drag. A push transition without an interruptible back-swipe is worse than a fade. If the project cannot afford every rule below, take none of them and build something that is excellent as web instead; the neutral references already cover that completely. Check before starting: every rule in this file has an owner, or the file is closed.

## Rules

1. **Body is 17px, not 16.** The whole scale shifts with it (cheat sheet). Why: every web default is 16; the one pixel is subliminal and it is most of the difference. Check: computed `font-size` on `<p>` is 17px.
2. **Tracking is size-specific and negative above 20px.** Display −0.022em, title −0.019em, body −0.011em, caption 0, all-caps micro +0.006em. `font-optical-sizing: auto`. Why: SF Pro Display is tighter than SF Pro Text; browsers render everything at 0. Check: headlines carry negative `letter-spacing`.
3. **`-apple-system` first in the stack.** `system-ui` alone resolves inconsistently. `ui-rounded` gives SF Pro Rounded for glanceable numerals. Check: the stack begins `-apple-system, BlinkMacSystemFont`.
4. **Labels are one ink with four alphas.** Primary 1, secondary `rgb(60 60 67 / 0.6)`, tertiary `0.3`, quaternary `0.18`; dark uses `rgb(235 235 245 / …)`. Separators `rgb(60 60 67 / 0.29)`. Check: no secondary text is a flat grey hex.
5. **Backgrounds come in three levels.** Light: `#FFFFFF`, `#F2F2F7`, `#FFFFFF`. Dark: `#000000` or `#1C1C1E` as the base, then `#1C1C1E`, `#2C2C2E`. True black is a written decision in the design contract, not a default; if chosen, elevation comes from the level ladder, never from shadows. See `references/theming-and-dark-mode.md`.
6. **Elevation is three layers with a half-pixel ring.** `0 0 0 0.5px rgb(0 0 0 / 0.04), 0 1px 2px rgb(0 0 0 / 0.04), 0 8px 24px -4px rgb(0 0 0 / 0.08)`. The ring does more than the blur. Check: no single-shadow cards.
7. **Materials need `saturate(180%)`.** ultraThin `blur(20px)` at white 0.30; thin `30px` / 0.50; regular `40px` / 0.68; thick `50px` / 0.80; dark regular `rgb(28 28 30 / 0.68)`. Two or three per screen, static, on chrome only. Never on a scrolling element. Check: every `backdrop-filter` includes `saturate`.
8. **Sheets have physics.** Backdrop tween 250ms ease-out; sheet springs in (`smooth`); contents arrive at +80ms with a 30ms stagger; the source view scales to 0.94 and rounds to 14px behind it. Dismiss on velocity > 500px/s or offset > 50%; an upward flick always cancels. Rubber-band past the edge with `c = 0.55`. Scroll-versus-drag arbitration: at scrollTop 0 a downward drag moves the sheet, otherwise the content scrolls. Check: flick from 10% down; it dismisses.
9. **Navigation pushes with parallax and an interruptible edge swipe.** The outgoing view slides to −30%; the incoming from 100%; both on the same spring. Back-swipe tracks the finger 1:1 and commits on velocity sign. Use the View Transitions API or Motion `layoutId` for shared elements; keep titles in a surviving parent. Check: start a back swipe, reverse, release; it returns smoothly with no jump.
10. **Grouped lists look grouped.** 0.5px separators at `rgb(60 60 67 / 0.29)` inset to the content start (16px), last row no separator, press state fills edge to edge with `rgb(0 0 0 / 0.06)` as an overlay, chevrons 14px at 30%, groups on a 10px radius over the secondary background. Check: separators are half a pixel on a retina screen.
11. **Press is a highlight, not a colour change.** Overlay `rgb(0 0 0 / 0.06)` (light) on down; scale 0.97 for large surfaces, 0.94 for small icons, never below 0.9. Check: press a list row; the whole row tints.
12. **Squircles only where the radius is load-bearing.** `corner-shape: superellipse(4)` (Chrome 139+) or a clip-path for radius > 20px on hero cards and icons. Below that nobody can tell. Check: grep `corner-shape`; every use is above 20px.
13. **Liquid Glass, honestly.** Real refraction needs `backdrop-filter: url(#svg-filter)` with a displacement map, and only Chromium supports it; Safari and Firefox get nothing. Ship blur + saturate + an inset specular highlight first; it is 90% of the effect for 2% of the cost. Add refraction only for a hero element on a Chromium-first audience, and animate `scale` on the filter, never the element size. Check: the `@supports` fallback exists and looks finished on Safari.
14. **Haptics are a hack on iOS Safari.** `navigator.vibrate` does not exist there. The `<input type="checkbox" switch>` trick fires the system switch haptic when clicked inside a user gesture; feature-detect and treat it as a bonus. Android gets `vibrate` on `pointerdown` (8 / 15 / 25ms). See `references/haptics-and-sound.md`.
15. **Standalone mode gets the PWA meta.** `apple-touch-icon`, `apple-mobile-web-app-capable`, `apple-mobile-web-app-status-bar-style: black-translucent`, per-scheme `theme-color`, and `overscroll-behavior: none` only inside `display-mode: standalone`. See `references/touch-and-mobile.md`.
16. **Momentum is the platform's.** iOS decelerates at 0.998 per millisecond. Do not build a custom scroller; use native scroll with `scroll-snap` where paging is wanted. Check: no scroll library in the bundle.

## What this file does not repeat

Everything below is universal and lives in the neutral references. Apply it first; layer this file on top.

| Topic | Reference |
|---|---|
| Spring tokens, exits, stagger | `references/motion.md`, `references/springs-and-gestures.md` |
| Base layer, safe areas, keyboard, `dvh` | `references/touch-and-mobile.md` |
| Focus, roving tabindex, reduced motion | `references/accessibility.md` |
| Loading ladder, optimistic ghosts | `references/states.md` |
| Icon stroke and states | `references/icons.md` |
| OKLCH tokens, theme switch | `references/color.md`, `references/theming-and-dark-mode.md` |

## Cheat sheet: the iOS type scale in px

| Role | Size | Weight | Tracking | Line height |
|---|---|---|---|---|
| Large Title | 34 | 700 | −0.026em | 1.21 |
| Title 1 | 28 | 700 | −0.022em | 1.21 |
| Title 2 | 22 | 700 | −0.019em | 1.27 |
| Title 3 | 20 | 600 | −0.019em | 1.25 |
| Headline | 17 | 600 | −0.011em | 1.29 |
| Body | 17 | 400 | −0.011em | 1.29 |
| Callout | 16 | 400 | −0.009em | 1.31 |
| Subhead | 15 | 400 | −0.006em | 1.33 |
| Footnote | 13 | 400 | 0 | 1.38 |
| Caption 1 | 12 | 400 | 0 | 1.33 |
| Caption 2 | 11 | 400 | +0.006em | 1.18 |

## Cheat sheet: springs and constants

| Thing | Value |
|---|---|
| Sheet in | Motion `{ type: "spring", visualDuration: 0.4, bounce: 0 }` |
| Sheet out | `visualDuration: 0.26, bounce: 0` |
| Dismiss | velocity > 500px/s, or offset > 0.5 × height; upward flick cancels |
| Rubber-band | `(1 − 1 / (offset / dimension × 0.55 + 1)) × dimension` |
| Nav push parallax | outgoing `translateX(-30%)` |
| Source behind sheet | scale 0.94, radius 14px |
| Deceleration | 0.998 / ms (do not reimplement) |
| Press overlay | `rgb(0 0 0 / 0.06)` |

## Code

```css
@theme {
  --font-sans: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI Variable", "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  --font-rounded: ui-rounded, "SF Pro Rounded", var(--font-sans);
}
:root { font-optical-sizing: auto; }
body { font-size: 17px; line-height: 1.29; letter-spacing: -0.011em; }
.text-display { font-size: 28px; font-weight: 700; letter-spacing: -0.022em; line-height: 1.21; }

.material-regular { backdrop-filter: blur(40px) saturate(180%); background: rgb(255 255 255 / 0.68); }
.dark .material-regular { background: rgb(28 28 30 / 0.68); }

.elevated {
  box-shadow: 0 0 0 0.5px rgb(0 0 0 / 0.04), 0 1px 2px rgb(0 0 0 / 0.04), 0 8px 24px -4px rgb(0 0 0 / 0.08);
}

.row + .row { border-top: 0.5px solid rgb(60 60 67 / 0.29); margin-inline-start: 16px; }
.row:active::after { content: ""; position: absolute; inset: 0; background: rgb(0 0 0 / 0.06); }

.glass {
  backdrop-filter: blur(24px) saturate(180%);
  background: rgb(255 255 255 / 0.2);
  box-shadow: inset 1px 1px 0 rgb(255 255 255 / 0.6);
}
@supports (backdrop-filter: url(#glass)) { .glass { backdrop-filter: url(#glass); } }
```

```ts
const DISMISS_DISTANCE = 0.5;
const DISMISS_VELOCITY = 500;
export function shouldDismiss(offsetY: number, velocityY: number, height: number) {
  if (velocityY > DISMISS_VELOCITY) return true;
  if (velocityY < -DISMISS_VELOCITY) return false;
  return offsetY > height * DISMISS_DISTANCE;
}
export function rubberBand(offset: number, dimension: number, c = 0.55) {
  return (1 - 1 / ((offset / dimension) * c + 1)) * dimension;
}
```

## Checks

- Computed body size is 17px; headlines have negative tracking.
- Every `backdrop-filter` has `saturate(180%)` and sits on static chrome.
- Sheet dismisses on a fast flick from any position; upward flick cancels.
- Back swipe reverses without a jump.
- Separators render at half a pixel on a 2x screen.
- Safari shows a finished glass fallback.
- No scroll library in the bundle.

## Do not

- Load this file for a project whose contract does not say "native feel".
- Use `system-ui` alone.
- Ship glass refraction without the Safari fallback.
- Set true black without writing the decision down.
- Reimplement momentum, rubber-banding, or the edge swipe from scratch when Vaul, Base UI, or the View Transitions API already does it.
