# Scroll

Use this when building or reviewing anything that scrolls: pages, panels, carousels, sticky headers, anchored sections, long lists. Momentum and gestures on non-scroll surfaces live in `references/springs-and-gestures.md`; virtualisation budgets in `references/performance.md`.

## Rules

1. **Momentum is the platform's.** Native overflow scrolling runs off the main thread with per-device deceleration. Any JavaScript that reimplements scrolling feels wrong on at least one device and breaks accessibility scrolling. Check: no `wheel` or `touchmove` handler calls `preventDefault` to drive scroll position.
2. **Contain overscroll inside overlays; leave the page alone in a browser.** `overscroll-behavior: contain` on modals, sheets, and side panels stops scroll chaining to the page. `overscroll-behavior: none` on `html`/`body` only inside `@media (display-mode: standalone)`; in a browser tab users expect pull-to-refresh and edge bounce. Check: scroll to the end of a modal's content; the page behind does not move.
3. **Paging needs `scroll-snap-stop: always`.** `scroll-snap-type: x mandatory` alone lets a hard flick skip three pages. `always` on each item makes it one page per swipe. Check: a hard flick advances exactly one page.
4. **Show the next item peeking.** A horizontal scroller whose last visible card ends exactly at the edge looks complete, and nobody scrolls it. Let 16–32px of the next item show, with `scroll-padding-inline` matching the container padding so snapped items align. Check: at every viewport width, a partial item is visible at the trailing edge.
5. **Sticky chrome shrinks on the compositor.** Use `animation-timeline: scroll()` inside `@supports` for headers that shrink or fade as you scroll; JS scroll listeners run on the main thread and stutter on mid-range devices. Check: the header animates with no `scroll` event handler attached.
6. **Edge effects, not hard dividers.** Where content scrolls under floating chrome, fade it with a gradient or blur mask instead of a 1px line; the eye reads depth, not a border. Check: a translucent header shows content fading beneath it.
7. **Anchors land clear of fixed headers.** `scroll-margin-top` on every `[id]` equal to the header height plus breathing room, so in-page links and browser find-in-page do not hide the target. Check: click a table-of-contents link; the heading sits fully below the header.
8. **Scrollbars only inside panels, never on the page.** Restyle scrollbars within bounded panes where a thin, inset bar reads as part of the component. The page scrollbar belongs to the OS and the user's settings. Check: `::-webkit-scrollbar` rules are scoped to a class, never to `*`, `html`, or `body`.
9. **`scroll-behavior: smooth` only for in-page anchors, and off under reduced motion.** Smooth scrolling on every navigation makes back/forward and find-in-page crawl. Check: `scroll-behavior` is on `html` only inside `@media (prefers-reduced-motion: no-preference)` and only affects anchor jumps.
10. **Restore position on back, start at top on forward.** Browsers restore automatically for full loads; SPAs must do it themselves (`history.scrollRestoration = "manual"` plus saving `scrollY` per entry). Check: navigate into a detail and back; the list is where you left it.
11. **`scrollIntoView` with `block: "nearest"`.** `"start"` or `"center"` yank the page when the element is already visible. Check: focusing an already-visible row does not scroll.
12. **Infinite scroll needs a floor.** Pagination or "Load more" for anything a user might want to reach the end of (search results, settings, footers). Infinite scroll only for feeds with no end, and even then with a visible position marker. Check: the footer is reachable.

## Cheat sheet

| Need | Property |
|---|---|
| Stop scroll chaining in an overlay | `overscroll-behavior: contain` |
| Stop page bounce in a PWA only | `@media (display-mode: standalone) { html, body { overscroll-behavior: none } }` |
| One page per swipe | `scroll-snap-type: x mandatory` on the container, `scroll-snap-align: center; scroll-snap-stop: always` on items |
| Peek | container `padding-inline: 24px; scroll-padding-inline: 24px`, items `flex: 0 0 calc(100% - 72px)` |
| Anchor offset | `[id] { scroll-margin-top: 80px }` |
| Header shrink on scroll | `animation-timeline: scroll(nearest block); animation-range: 0 120px` |
| Content fade under chrome | `mask-image: linear-gradient(to bottom, transparent, black 24px)` on the scroll container |
| Panel scrollbar | scoped `scrollbar-width: thin` + `::-webkit-scrollbar-thumb { background-clip: padding-box; border: 3px solid transparent }` |
| Cheap long lists | `content-visibility: auto; contain-intrinsic-size: auto 72px` (see `references/performance.md`) |

## Code

Paging carousel with a peek:

```css
.pager {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding-inline: 24px;
  scroll-padding-inline: 24px;
  scroll-snap-type: x mandatory;
  overscroll-behavior-x: contain;
  scrollbar-width: none;            /* the pager is its own affordance */
}
.pager > * {
  flex: 0 0 calc(100% - 48px - 24px); /* margins + 24px peek of the next item */
  scroll-snap-align: start;
  scroll-snap-stop: always;
}
```

Tailwind alternative: `flex gap-3 overflow-x-auto px-6 scroll-px-6 snap-x snap-mandatory` on the container, `shrink-0 w-[80%] snap-start snap-always` on items.

Header that shrinks on the compositor, with a static fallback:

```css
.header { height: 72px; }
@supports (animation-timeline: scroll()) {
  @media (prefers-reduced-motion: no-preference) {
    .header {
      animation: shrink linear both;
      animation-timeline: scroll(nearest block);
      animation-range: 0 120px;
    }
  }
}
@keyframes shrink { to { height: 48px; } }
```

Overlay scroll containment and anchors:

```css
.dialog { overscroll-behavior: contain; }
[id] { scroll-margin-top: calc(var(--header-h, 64px) + 16px); }
@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; } /* affects anchor jumps only */
}
```

Scrollbar restyle, scoped to panels only:

```css
.panel-scroll {
  scrollbar-width: thin;
  scrollbar-color: var(--scrollbar-thumb) transparent;
}
.panel-scroll::-webkit-scrollbar { width: 10px; height: 10px; }
.panel-scroll::-webkit-scrollbar-thumb {
  background-color: var(--scrollbar-thumb);
  background-clip: padding-box;   /* the transparent border fakes an inset track */
  border: 3px solid transparent;
  border-radius: 999px;
}
.panel-scroll::-webkit-scrollbar-thumb:hover { background-color: var(--scrollbar-thumb-hover); }
```

Content fading under a floating toolbar:

```css
.scroll-area {
  mask-image: linear-gradient(to bottom, transparent 0, black 24px, black calc(100% - 24px), transparent 100%);
}
```

SPA scroll restoration:

```ts
if ("scrollRestoration" in history) history.scrollRestoration = "manual";
// on navigate away: sessionStorage.setItem(`scroll:${key}`, String(window.scrollY))
// on popstate: window.scrollTo({ top: Number(sessionStorage.getItem(`scroll:${key}`) ?? 0) })
// on push: window.scrollTo({ top: 0 })
```

Focus without yanking:

```ts
row.scrollIntoView({ block: "nearest", inline: "nearest" });
```

## Checks

- Hard flick in a paged carousel advances one page.
- A partial next card is visible at every breakpoint.
- Scroll a modal to its end; the page does not move behind it.
- In a browser tab, pull-to-refresh still works on mobile.
- Anchor links land with the heading fully visible below any fixed header.
- Header shrink happens with no `scroll` listener in the Event Listeners panel.
- Only panels have custom scrollbars; the page scrollbar is native.
- Back navigation restores the list position.

## Do not

- Implement momentum or smooth scrolling in JavaScript.
- Put `overscroll-behavior: none` on the body of a site that runs in a browser tab.
- Restyle the page scrollbar.
- Use `position: fixed` on `body` to lock scroll behind a modal; use `overscroll-behavior: contain` and, if needed, `scrollbar-gutter: stable`.
- Autoplay a carousel. See `references/marketing-pages.md`.
- Attach a `scroll` listener that sets React state per frame.
