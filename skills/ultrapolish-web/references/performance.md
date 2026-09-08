# Performance as a design property

Use this when an interface feels heavy, late, or jumpy, and when you review anything that animates, loads, or lists. Speed is felt before it is measured; a polished interface responds within the frame. Motion curves live in `references/motion.md`; scroll containers in `references/scroll.md`.

## Rules

1. **Respond within 100ms, settle within 200ms.** Any click or tap must produce visible change within 100ms; Interaction to Next Paint (INP) stays under 200ms, ideally under 100. On a 120Hz display a frame is 8.3ms, not 16. Check: the Performance panel shows the first paint after input inside 100ms on the primary path.
2. **No layout shift, ever.** Reserve every box: `width` and `height` (or `aspect-ratio`) on images and embeds, skeletons at final dimensions, loading buttons that lock their width, `font-variant-numeric: tabular-nums` on changing numbers, `size-adjust` on the fallback font so the swap does not reflow. Check: CLS is 0 in the Performance panel's Layout Shift track during load, font swap, data arrival, and button loading.
3. **Know the frame killers, in order.** (1) `backdrop-filter` on an element that scrolls or animates. (2) Animating layout properties (`height`, `width`, `top`, `left`, `margin`). (3) A large blurred `box-shadow` on an animated element. (4) React re-renders during a gesture. (5) Unbounded lists. Fix in that order. Check: the Performance panel's flame chart shows no purple layout bars during an animation.
4. **`will-change` is a last resort, not a prefix.** Only `transform`, `opacity`, or `filter`; only on an element you have watched stutter on its first frame; never `all`. Each promoted layer costs memory and can blur text. Check: `grep -rn will-change src` returns a handful of lines, each with a comment naming the stutter it fixed.
5. **Never animate blur above 20px.** Static `backdrop-filter: blur(40px)` on a fixed header is fine. Animating blur, or blurring something that moves, is the most expensive thing a page can do in Safari. Check: any `blur()` inside `@keyframes` or a transition is ≤ 20px.
6. **Make long content cheap before making it virtual.** `content-visibility: auto; contain-intrinsic-size: auto 72px` on list rows skips rendering off-screen rows in one line and gets most of the win. Virtualise past ~100 rows or when rows are heavy (images, charts). Check: a 500-row list scrolls at frame rate; DevTools Rendering shows off-screen rows unpainted.
7. **Prefetch on `pointerdown`, not `click`.** The gap between press and release is 100–150ms of free time. Prefetch the route or data on `pointerdown` (or `mouseenter` on desktop). Mark the largest above-the-fold image `fetchpriority="high"` and never lazy-load it. Check: the Network panel shows the route request starting before the click event.
8. **Switch themes in one frame.** Add a `.theme-switching` class that disables transitions, flip the theme attribute, remove the class after two nested `requestAnimationFrame`s, with a 120ms `setTimeout` backstop because rAF does not fire in a background tab. Without it every control cross-fades its own colours on its own curve and the switch reads as a ripple. Check: toggle the theme; everything changes in the same frame.
9. **Freeze timers when the tab is hidden.** Ambient loops, countdowns, and polling pause on `visibilitychange` and resume on return, so the page does not burn battery in the background and does not jump on return. Check: hide the tab for a minute; on return nothing catches up in a burst.
10. **Debounce search at 300ms; throttle scroll and resize with rAF.** 300ms is under the threshold where typing feels laggy and over the threshold where every keystroke hits the network. Check: typing five characters fast produces one request.
11. **Images arrive, they do not pop.** Reserve the box with `aspect-ratio`, show a blurred placeholder (blurhash or a 20px-wide inline version), and fade the real image in over ~320ms once decoded. Check: no image causes shift; no image flashes from blank to full.
12. **Intro animation plays once per session.** Gate first-visit theatre on `sessionStorage`, not `localStorage`, so a returning user sees it again tomorrow but not on every route change today. Check: navigate away and back; the intro does not replay.

## Cheat sheet

| Budget | Value |
|---|---|
| Input to visible change | < 100ms |
| INP | < 200ms, ideally < 100ms |
| Frame at 120Hz | 8.3ms |
| CLS | 0 on load, font swap, data, button loading |
| Spinner delay | 300ms |
| Search debounce | 300ms |
| Image fade-in | ~320ms |
| Theme-switch backstop | 120ms |
| Virtualise past | ~100 rows |

| Frame killer | Fix |
|---|---|
| `backdrop-filter` on moving element | Static chrome only; ≤ 3 per screen; never in a transition |
| Animating layout | `transform` / `opacity`; `grid-template-rows: 0fr → 1fr` for accordions |
| Blurred shadow on animated element | Put the shadow on a pseudo-element and animate its opacity |
| Re-render per pointer move | `useMotionValue` + `useTransform`; never `setState` in `onDrag` |
| Unbounded list | `content-visibility: auto`, then virtualise |

## Code

Reserve boxes and stabilise fonts:

```css
img, video { max-width: 100%; height: auto; }
.thumb { aspect-ratio: 4 / 3; }
@font-face {
  font-family: "Fallback";
  src: local("Arial");
  size-adjust: 104%;        /* match the web font's width so the swap does not reflow */
  ascent-override: 92%;
}
.count { font-variant-numeric: tabular-nums; }
```

Cheap long lists:

```css
.row { content-visibility: auto; contain-intrinsic-size: auto 72px; }
```

Prefetch on press, LCP image priority:

```tsx
<a href="/settings" onPointerDown={() => router.prefetch("/settings")}>Settings</a>
<img src={hero} width={1200} height={630} fetchpriority="high" decoding="async" alt="" />
```

Theme switch in one frame (see `assets/theme-switch.ts`):

```ts
export function applyTheme(dark: boolean) {
  const root = document.documentElement;
  root.classList.add("theme-switching");
  root.dataset.theme = dark ? "dark" : "light";
  const clear = () => root.classList.remove("theme-switching");
  requestAnimationFrame(() => requestAnimationFrame(clear));
  setTimeout(clear, 120); // rAF does not fire in a background tab
}
```

```css
.theme-switching *, .theme-switching *::before, .theme-switching *::after {
  transition: none !important;
}
```

Freeze on hide:

```ts
document.addEventListener("visibilitychange", () => {
  if (document.hidden) stopLoop(); else startLoop();
});
```

Shadow that animates cheaply:

```css
.card { position: relative; }
.card::after {
  content: ""; position: absolute; inset: 0; border-radius: inherit;
  box-shadow: 0 8px 24px -4px oklch(0 0 0 / 0.16);
  opacity: 0; transition: opacity 150ms var(--ease-micro);
}
.card:hover::after { opacity: 1; }
```

Image fade-in with a placeholder:

```tsx
<div className="thumb" style={{ backgroundImage: `url(${blurDataUrl})`, backgroundSize: "cover" }}>
  <img src={src} alt={alt} width={w} height={h} loading="lazy" decoding="async"
       onLoad={(e) => e.currentTarget.classList.add("is-loaded")} />
</div>
```

```css
.thumb img { opacity: 0; transition: opacity 320ms var(--ease-micro); }
.thumb img.is-loaded { opacity: 1; }
```

Intro gate:

```ts
const seen = sessionStorage.getItem("intro");
if (!seen) { playIntro(); sessionStorage.setItem("intro", "1"); }
```

## Checks

- Performance panel, record the primary path: INP < 200ms; no layout bars inside animations.
- Layout Shift track is empty across load, font swap, first data, and a loading button.
- Rendering panel with "Paint flashing": scrolling a list paints only new rows.
- Network panel: route prefetch starts on pointerdown; the hero image is first in the queue.
- Theme toggle changes every colour in one frame with no ripple.
- Hide the tab for 60s: on return, no loop catches up.
- `grep -rn "will-change" src` shows only justified lines.

## Do not

- Put `will-change` in a base stylesheet.
- Animate `height`, `blur()` above 20px, or a blurred `box-shadow` directly.
- Lazy-load the above-the-fold image.
- Show a spinner before 300ms.
- Store the "intro seen" flag in `localStorage`.
- Set React state from a scroll or drag handler.
