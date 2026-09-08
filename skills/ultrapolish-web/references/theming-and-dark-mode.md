# Theming and dark mode

Use this when you are adding, fixing, or auditing a light/dark switch, defining how surfaces and inks flip, or handling the system preference and the print theme.
Pair with `references/color.md` for the values and `references/surfaces-and-depth.md` for what shadows become in the dark.

## Rules

1. **Dark mode is not a mirror.** Reversing every palette step produces glaring text on a muddy ground. Design the dark theme as a second set of pairs and re-check every foreground/background pair in both. Check: the findings table lists each pair with both measurements.
2. **Step the ink in alpha, not in separate greys.** Define one ink and derive secondary, tertiary, quaternary, and hairline as that ink at 0.62, 0.45, 0.28, and 0.10. When the dark theme swaps the base ink and canvas, the whole hierarchy follows for free and stays proportional on any surface.
3. **Tokens on `:root`, overrides on `[data-theme]`.** Surfaces and inks are CSS variables; the theme attribute flips them. Never build surfaces with Tailwind `dark:` classes, because every component then owns its own copy of the decision and the copies drift.
4. **"System" is the absence of a stored key.** Store only an explicit choice. When the user picks System, remove the key and follow `matchMedia("(prefers-color-scheme: dark)")`. Browsers that never chose keep the behaviour they always had.
5. **One source of truth, read through `useSyncExternalStore`.** The header toggle and the settings page subscribe to the same store, so they cannot disagree.
6. **Suppress transitions for one frame while switching.** Without it every control cross-fades its own colours on its own curve and the switch reads as a ripple of mismatched fades. Add a class that sets `transition: none !important`, flip the theme, remove the class after two nested `requestAnimationFrame` calls, and add a `setTimeout` of 120ms as a backstop because rAF does not fire in a background tab. (`next-themes` exposes this as `disableTransitionOnChange`.)
7. **Set `color-scheme` on the root.** `color-scheme: light dark` (or the active one) makes native controls, scrollbars, and form elements render in the right scheme without custom styling.
8. **Prevent the flash.** Apply the stored theme in a blocking inline script in `<head>` before first paint. A theme applied after hydration flashes the wrong scheme on every load.
9. **Shadows vanish in the dark; use a ring.** Replace the light shadow stack with a single `0 0 0 1px oklch(1 0 0 / 0.08)` ring, hover `0.13`. See `references/surfaces-and-depth.md`.
10. **Desaturate the brand colour 20–30% in dark and lift its L.** Saturated accents vibrate on dark grounds, and a dark ground needs the accent's L raised roughly 0.06 to hold 3:1 for UI. Hover states come from `color-mix(in oklch, var(--color-accent) 85%, black)` rather than a second hardcoded value.
11. **Near-black carries the palette's hue.** Pure `#000` is a written decision (OLED bleed, media-first chrome), not a default. A canvas at L 0.12–0.20 with a whisper of the brand hue reads as a room, not a void.
12. **Images and media get an outline, not a filter.** A 1px `oklch(1 0 0 / 0.1)` inset outline separates a photo from a dark canvas. `filter: brightness(0.9)` on images is a last resort for glaring white product shots, applied per image, never globally.
13. **Honour `prefers-reduced-transparency`.** Translucent chrome becomes a solid surface token when the user asks. Test the page with it on.
14. **Never fight `forced-colors: active`.** Do not set `forced-color-adjust: none` on content. Use system colour keywords (`CanvasText`, `LinkText`, `ButtonFace`) if you must style within it, and let focus rings and borders be drawn by the browser.
15. **Print is a real theme.** Greys become black, canvas becomes white, shadows and backdrops go, type drops a step. Test it; a dark theme printed as-is wastes toner and reads as broken.
16. **Test both themes for every state.** Hover, focus, selected, disabled, error, and placeholder each have two pairs. Half-tested is untested.

## Cheat sheet

| Layer | Light | Dark |
|---|---|---|
| Canvas | `--canvas` | `--canvas` (near-black with hue) |
| Ink | `--ink` | `--ink` (near-white, not pure) |
| Ink secondary / tertiary / quaternary | ink at 0.62 / 0.45 / 0.28 | same alphas on the dark ink |
| Hairline | ink at 0.10 | ink at 0.12 |
| Elevation | 3-layer shadow-as-border | single white ring 0.08, hover 0.13 |
| Accent | brand value | 20–30% less chroma, L lifted ~0.06 |
| Images | optional outline | outline 1px white 10% inset |

| Preference | Response |
|---|---|
| No stored key | follow `prefers-color-scheme` |
| Stored `light` / `dark` | apply; ignore the OS until the user picks System |
| `prefers-reduced-transparency` | solid surface tokens |
| `prefers-contrast: more` | widen L gap ≥ 0.15 (see `references/color.md`) |
| `forced-colors: active` | do not override |
| `print` | black on white, no shadows, no blur |

## Code

Tokens (values are examples; the mechanism is the point):

```css
:root {
  color-scheme: light;
  --canvas: #ffffff;
  --ink: #1a1a1a;
  --ink-secondary: rgb(from var(--ink) r g b / 0.62);
  --ink-tertiary: rgb(from var(--ink) r g b / 0.45);
  --ink-quaternary: rgb(from var(--ink) r g b / 0.28);
  --hairline: rgb(from var(--ink) r g b / 0.10);
  --elevation: 0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04);
}

[data-theme="dark"] {
  color-scheme: dark;
  --canvas: #161616;
  --ink: #ededed;
  --hairline: rgb(from var(--ink) r g b / 0.12);
  --elevation: 0 0 0 1px oklch(1 0 0 / 0.08);
}

/* No stored choice: follow the OS. The inline script below sets data-theme only for explicit choices. */
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    color-scheme: dark;
    --canvas: #161616;
    --ink: #ededed;
    --hairline: rgb(from var(--ink) r g b / 0.12);
    --elevation: 0 0 0 1px oklch(1 0 0 / 0.08);
  }
}

html.theme-switching * { transition: none !important; }

@media (prefers-reduced-transparency: reduce) {
  :root { --glass: var(--canvas); }
}

@media print {
  :root { --canvas: #fff; --ink: #000; --elevation: none; }
  * { backdrop-filter: none !important; box-shadow: none !important; }
}
```

Blocking init in `<head>`, before any stylesheet paints:

```html
<script>
  try {
    var t = localStorage.getItem("theme");
    if (t === "dark" || t === "light") document.documentElement.dataset.theme = t;
  } catch (e) {}
</script>
```

Store, switch, and hook (`theme.ts`):

```ts
import { useSyncExternalStore } from "react";

export type ThemePref = "light" | "dark" | "system";
const KEY = "theme";
const listeners = new Set<() => void>();

export function themePref(): ThemePref {
  try {
    const s = localStorage.getItem(KEY);
    return s === "dark" ? "dark" : s === "light" ? "light" : "system";
  } catch {
    return "system";
  }
}

export function applyTheme(dark: boolean) {
  const root = document.documentElement;
  root.classList.add("theme-switching");
  root.dataset.theme = dark ? "dark" : "light";
  const clear = () => root.classList.remove("theme-switching");
  requestAnimationFrame(() => requestAnimationFrame(clear));
  setTimeout(clear, 120); // rAF does not fire in a background tab
}

export function setThemePref(pref: ThemePref) {
  try {
    if (pref === "system") localStorage.removeItem(KEY);
    else localStorage.setItem(KEY, pref);
  } catch {}
  applyTheme(
    pref === "system"
      ? window.matchMedia("(prefers-color-scheme: dark)").matches
      : pref === "dark",
  );
  listeners.forEach((fn) => fn());
}

export function useThemePref(): ThemePref {
  return useSyncExternalStore(
    (cb) => { listeners.add(cb); return () => listeners.delete(cb); },
    themePref,
    () => "system",
  );
}

// Follow the OS while in system mode.
if (typeof window !== "undefined") {
  const mq = window.matchMedia("(prefers-color-scheme: dark)");
  mq.addEventListener("change", () => { if (themePref() === "system") applyTheme(mq.matches); });
}
```

Accent hover without a second literal:

```css
.button-primary:hover {
  background: color-mix(in oklch, var(--color-accent) 85%, black);
}
```

## Checks

- Toggle the theme with the Animations panel open: exactly one frame, no cross-fading controls.
- Switch the theme in a background tab, return: transitions still work.
- Clear storage, change the OS scheme: the page follows.
- Every state (hover, focus, selected, disabled, error, placeholder) screenshotted in both themes.
- `color-scheme` set; native `<select>`, scrollbars, and date inputs render in the active scheme.
- Print preview: black on white, no shadows, no blur.
- With `prefers-reduced-transparency` on, no translucent chrome remains.
- Grep for `dark:` on background or text utility classes returns nothing (or only for genuinely one-off content).

## Do not

- Build surfaces with `dark:` classes.
- Store "system" as a value.
- Flip the theme without the one-frame suppressor.
- Invert images, or apply a global brightness filter.
- Use pure `#000` without writing the decision in the design contract.
- Override `forced-colors`.
- Ship a dark theme without re-measuring every pair.
