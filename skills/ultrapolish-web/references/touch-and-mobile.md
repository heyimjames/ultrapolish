# Touch and mobile web

Use this when the interface will be used on a phone or tablet, in a browser or as an installed web app. Most "feels like a website" complaints trace to a dozen platform defaults nobody turned off, and a few that somebody turned off wrongly.

## Rules

1. **Ship the base layer once, at the root.** Tap highlight, text-size adjust, touch callout, touch-action, selection policy, focus policy, and input size (see Code). Why: these are per-page defaults that read as sloppiness on every screen at once. Check: the base layer exists in one file and is imported first.
2. **Inputs are at least 16px.** `font-size: max(16px, 1rem)`. Why: below 16px iOS Safari zooms the viewport on focus and does not zoom back. Check: focus every input on a real iPhone; nothing zooms.
3. **Never `user-scalable=no` or `maximum-scale=1`.** Safari ignores it for pinch, every other browser honours it, and it fails WCAG 1.4.4. Fix the zoom cause (rule 2) instead. Check: the viewport meta contains neither.
4. **`viewport-fit=cover`, then add safe areas to padding.** `padding-bottom: calc(16px + env(safe-area-inset-bottom, 0px))`. Never use the inset as the whole padding. For sheets, pad the contents, not the position. Why: without `viewport-fit=cover`, `env()` returns 0 and you will not notice until a device with a home indicator. Check: run on an iPhone with a home indicator; nothing sits under it.
5. **`dvh` for fill layouts, `svh` for fixed chrome, `vh` never.** `100vh` is the largest viewport on iOS and overflows under the URL bar. `dvh` reflows during scroll, so prefer `svh` for a composer or a bottom bar. Check: grep for `100vh`; each hit is a finding.
6. **`overscroll-behavior: none` on html/body only in standalone mode.** In the browser, people expect pull-to-refresh and rubber-banding. Inside scroll containers use `overscroll-behavior: contain`. Check: the rule lives inside `@media (display-mode: standalone)`.
7. **Every hover-only affordance has a touch equivalent.** Wrap hover styles in `@media (hover: hover)`; expose the same action via a visible control, a long-press, or an always-on state. Why: a hover-revealed delete button does not exist on a phone. Check: emulate touch in DevTools; can you reach every action?
8. **Targets are 44px on touch.** Visual size can be smaller; expand the hit area with a pseudo-element on the `<button>` or `<label>`, never on the `<input>`. No two hit areas overlap. See `references/accessibility.md`.
9. **`touch-action: manipulation` on every control.** Removes the 300ms double-tap delay where it still exists and stops accidental zoom on rapid taps. Check: grep controls for `touch-action`.
10. **Haptics fire on `pointerdown`, never `click`, never on scroll.** See `references/haptics-and-sound.md`.
11. **Handle the virtual keyboard.** iOS resizes `visualViewport`, not the layout viewport; `position: fixed` elements do not move. Use the VirtualKeyboard API where present and a `visualViewport` fallback that writes `--kb` and moves the composer with `transform`, not `bottom`. Never focus an input in the same frame you open a sheet; wait ~350ms or `onAnimationComplete`. Check: open the composer on iOS; it sits above the keyboard.
12. **`enterkeyhint` and `inputmode` on every field.** `enterkeyhint="send"`, `"search"`, `"next"`, `"done"`; `inputmode="numeric"` for codes, `"decimal"` for money, `"email"`, `"tel"`. Why: the keyboard's primary key should say what will happen. Check: every `<input>` names both.
13. **Scroll snap paging needs `scroll-snap-stop: always`.** Without it a hard flick skips three pages. Check: flick fast on a snap carousel; it advances one.
14. **Test the smallest first.** 320px wide, vertical scroll only, no horizontal overflow. Then the largest. Check: DevTools at 320, look for a horizontal scrollbar.
15. **Test on a real device.** iPhone with Safari's remote inspector, and an Android phone with Chrome. Simulators miss zoom-on-focus, keyboard insets, tap highlight, and momentum. Check: at least one real-device pass per release.

## Cheat sheet

| Property | Value |
|---|---|
| Input size | `max(16px, 1rem)` |
| Viewport meta | `width=device-width, initial-scale=1, viewport-fit=cover` |
| Fill height | `100dvh` |
| Fixed chrome height | `svh` |
| Safe area | `calc(<pad> + env(safe-area-inset-*, 0px))` |
| Touch target | 44px, pseudo-element on button/label |
| Controls | `touch-action: manipulation` |
| Overscroll (page) | `none` only in standalone; otherwise leave it |
| Overscroll (container) | `contain` |
| Snap paging | `scroll-snap-type: x mandatory; scroll-snap-stop: always` |
| Keyboard | VirtualKeyboard API, `visualViewport` fallback, move with `transform` |
| Focus after sheet | ~350ms or on animation complete |

## Code

The base layer:

```css
@layer base {
  * { -webkit-tap-highlight-color: transparent; }   /* or match the design's press colour */

  html {
    -webkit-text-size-adjust: 100%;
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  button, [role="button"], a, label, summary, input[type="checkbox"], input[type="radio"] {
    touch-action: manipulation;
  }

  /* Chrome is UI. Content is content. */
  nav, header, footer, button, [role="button"], label {
    -webkit-user-select: none; user-select: none;
  }
  p, article, main, li, td, [contenteditable] {
    -webkit-user-select: text; user-select: text;
  }

  img:not([data-saveable]) { -webkit-touch-callout: none; }

  :focus { outline: none; }
  :focus-visible { outline: 2px solid var(--focus-ring, currentColor); outline-offset: 2px; }

  input, textarea, select {
    font-size: max(16px, 1rem);
    -webkit-appearance: none;
  }

  @media (hover: hover) {
    /* hover-only styles live here */
  }

  @media (display-mode: standalone) {
    html, body { overscroll-behavior: none; }
  }
}
```

Viewport and opt-in PWA meta:

```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, interactive-widget=resizes-content">
<meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#111111" media="(prefers-color-scheme: dark)">
<!-- Only when the project is an installable app: -->
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
```

Keyboard inset:

```ts
if ("virtualKeyboard" in navigator) {
  (navigator as any).virtualKeyboard.overlaysContent = true;
}
// Fallback for everything else
const vv = window.visualViewport;
function update() {
  if (!vv) return;
  const inset = window.innerHeight - vv.height - vv.offsetTop;
  document.documentElement.style.setProperty("--kb", `${Math.max(0, inset)}px`);
}
vv?.addEventListener("resize", update);
vv?.addEventListener("scroll", update);
```

```css
.composer {
  position: fixed; inset-inline: 0; bottom: 0;
  padding-bottom: calc(8px + env(safe-area-inset-bottom, 0px));
  transform: translateY(calc(-1 * var(--kb, 0px)));
}
@supports (bottom: env(keyboard-inset-height)) {
  .composer { bottom: env(keyboard-inset-height, 0px); transform: none; }
}
```

Snap paging:

```css
.pager { display: flex; overflow-x: auto; scroll-snap-type: x mandatory; scroll-snap-stop: always; }
.pager > * { flex: 0 0 100%; scroll-snap-align: start; }
```

## Anti-advice

Widely recommended, wrong today:

| Advice | Why not | Instead |
|---|---|---|
| `-webkit-overflow-scrolling: touch` for momentum | Default since iOS 13 | Delete it |
| `position: fixed` on body to lock scroll | Loses scroll position, breaks keyboard | `<dialog>` + `overscroll-behavior: contain`, or `inert` |
| `user-select: none` globally | People copy text | Chrome none, content text |
| JS smooth-scroll libraries | Fight the platform, tank INP | `scroll-behavior: smooth` on the container, or nothing |
| `will-change: transform` everywhere | Memory per layer | Only after a measured first-frame stutter |
| `100vh` + resize listener | Jumps on scroll | `dvh` or `svh` |
| `maximum-scale=1` | Fails WCAG; ignored by Safari | Fix input sizes |
| Custom momentum scroller | Never matches the platform curve | Native scroll |

## Checks

- Focus every input on an iPhone: no zoom.
- Viewport meta: `viewport-fit=cover`, no `user-scalable`, no `maximum-scale`.
- `grep -rn "100vh"`: zero hits or each justified.
- `grep -rn "overscroll-behavior"`: page-level rule only inside `display-mode: standalone`.
- DevTools touch emulation: every hover action reachable.
- 320px width: no horizontal scrollbar.
- Composer above the keyboard on iOS and Android.
- One real-device pass on each platform.

## Do not

- Disable zoom.
- Use the safe-area inset as the whole padding.
- Put `overscroll-behavior: none` on the page in a browser tab.
- Hide an action behind hover with no touch path.
- Focus an input while a sheet is still animating.
- Build a custom scroller.
