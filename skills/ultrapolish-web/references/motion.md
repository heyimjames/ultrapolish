# Motion and transitions

Use this when you add, review, or tune any transition, entrance, exit, hover, or state change on the web. It covers the discipline (which properties, which curves, how long) and the vocabulary (named tokens with jobs). Springs and gestures live in `references/springs-and-gestures.md`; scroll-linked motion in `references/scroll.md`.

## Rules

1. **Name every property you transition.** `transition: all` animates properties you did not intend (layout, colour on theme switch, `border-radius` on hover) and costs a style recalc on each. Write `transition: transform 150ms var(--ease), opacity 150ms var(--ease)`. Check: grep for `transition: all` and `transition-property: all`; both should return nothing. Tailwind's bare `transition` is a curated list (colors, opacity, shadow, transform), not `all`; `transition-transform` covers `transform, translate, scale, rotate`.
2. **Build a vocabulary, then refuse anything outside it.** Five to eight named tokens, each with a stated job, in one file. Add the line: "If a new animation does not fit one of these, the answer is usually don't." Check: every `transition` and `animate` in the codebase references a token, not a literal.
3. **Frequency decides motion.** Seen 100+ times a day: instant, or a colour change ≤ 150ms. Seen a few times a day: 150–250ms. Seen rarely (onboarding, a milestone, a first paint): the fuller transition, whose ceiling is a considered piece of choreography and never a particle burst. Check: list the three most frequent interactions; none should have a transform animation over 150ms.
4. **Entrances decelerate, exits accelerate.** Enter on an ease-out (`cubic-bezier(0.165, 0.84, 0.44, 1)` for small, `cubic-bezier(0.16, 1, 0.3, 1)` for large). Exit on `cubic-bezier(0.4, 0, 1, 1)` at about 0.65× the entrance duration, never with bounce. Check: exits are visibly shorter when replayed at 10% speed.
5. **Paired elements share timing.** Modal and backdrop, tooltip and arrow, drawer and scrim, a number and its bar: identical easing and duration, or the pair reads as two things. Check: the two `transition` declarations are the same token.
6. **Stagger by kind.** List items 30–40ms apart, cap around 8 (240ms total). Semantic chunks (title, body, actions) 80–100ms apart. First appearance only, never re-run on scroll into view. Check: item 9 onward has no delay.
7. **Skip entrance animation on page load for above-the-fold chrome.** Navigation, headers, and the first visible content should be present at first paint. Animate only what arrives after interaction or after data. Check: reload the page; nothing in the viewport moves before you touch it.
8. **Opacity and colour tween; transforms may spring.** A bouncing opacity is an artefact. Use a 100–200ms ease for opacity, background, colour, border colour. See `references/springs-and-gestures.md` for what springs.
9. **Loops act, rest, then ease home.** A demo or ambient loop does the thing, parks the payoff so it dwells, then eases back. It never snaps to the start. Check: watch two cycles; the reset is invisible.
10. **Reduced motion is opt-in.** Wrap motion in `@media (prefers-reduced-motion: no-preference)`. Where a global kill switch is unavoidable, use `0.01ms`, never `none`, so `animationend` and `transitionend` still fire. Replace travel and scale with crossfades; keep functional feedback. Check: toggle the OS setting; nothing slides, everything still changes state.
11. **Review at 10% speed.** Open the browser's Animations panel, set playback to 10%, and trigger each pair. Overshoot, mismatched pairs, and late stagger are obvious at that speed and invisible at 100%. Check: done before any motion PR merges.
12. **Interpolate the presentation, never the data.** A number that counts up to a total must pass through values that were never true, so it may only do that where the intermediate values carry no meaning: a confetti-free "1,284 readers" is fine, an account balance, a dose, a score, a countdown to a deadline and a progress figure are not. Never smooth a value by inventing one, never round to make a transition land, and snap the last fraction rather than easing through a number the system does not believe. If a chart's range must grow to fit a new high, expand it instantly so the line is never drawn outside its own axis, and ease it back in when the spike passes. Check: pause the animation mid-flight and read the number on screen; if a person could act on that value and it is wrong, the animation is lying.

## Cheat sheet

### Easing ladder

| Name | Curve | Job |
|---|---|---|
| ease / micro | `cubic-bezier(0.2, 0, 0, 1)` | hover, colour, opacity, tiny state |
| out-quad | `cubic-bezier(0.25, 0.46, 0.45, 0.94)` | subtle enters |
| out-cubic | `cubic-bezier(0.215, 0.61, 0.355, 1)` | small enters |
| out-quart | `cubic-bezier(0.165, 0.84, 0.44, 1)` | default enter: dropdowns, tooltips, popovers |
| out-quint | `cubic-bezier(0.23, 1, 0.32, 1)` | medium surfaces |
| out-expo | `cubic-bezier(0.19, 1, 0.22, 1)` | large surfaces, page |
| enter (expo-ish) | `cubic-bezier(0.16, 1, 0.3, 1)` | modals, sheets, hero reveals |
| exit | `cubic-bezier(0.4, 0, 1, 1)` | every exit |
| in-out | `cubic-bezier(0.455, 0.03, 0.515, 0.955)` | on-screen moves (reorder, resize) |
| linear | `linear` | marquees, hold-to-confirm, progress |

Bigger surface, stronger curve. `ease-in` on an entering element is almost never right.

### Durations

| Job | Duration |
|---|---|
| Hover, colour, opacity | 100–150ms |
| Micro state (checkbox, toggle, chip) | 120–180ms |
| Enter: dropdown, tooltip, popover | 150–250ms |
| Enter: modal, sheet, drawer | 250–300ms |
| Page or view transition | 300–400ms |
| Exit, anything | 0.65× the entrance, ≤ 200ms |

### Enter and exit recipes

| | Transform | Opacity | Filter | Timing |
|---|---|---|---|---|
| Enter | `translateY(8–12px) → 0` (or `scale(0.95) → 1`) | 0 → 1 | `blur(4px) → 0` (optional; skip on lists > 20) | 200–300ms, out-quart or enter |
| Exit | `translateY(-8px)` (or `scale(0.97)`) | 1 → 0 | none | 150ms, exit |

Never animate from `scale(0)`. Start at 0.95.

### Contextual icon swap (copy → check)

| Property | From | To |
|---|---|---|
| scale | 0.25 | 1 |
| opacity | 0 | 1 |
| filter | `blur(4px)` | `blur(0)` |
| transition | spring `{ duration: 0.3, bounce: 0 }` | bounce is always 0 |

Hold the check 1.5s, then swap back. CSS fallback: both icons in the DOM, one `position: absolute`, cross-fade over 300ms with `cubic-bezier(0.2, 0, 0, 1)`.

### Motion library vs CSS

| Need | Use |
|---|---|
| Hover, focus, active, non-interruptible enter/exit | CSS transition with a token |
| Anything retriggerable mid-flight or continuing from a gesture | `motion/react` spring (velocity handoff) |
| Layout change (size, position, reorder) | `motion/react` `layout` |
| Shared element between routes | View Transitions API, or `layoutId` |
| Scroll-linked | `animation-timeline: scroll()` |
| Sequenced multi-element storyboard | `motion/react` with a stage integer |

`framer-motion` exports the same API; `import { motion } from "motion/react"` is the current package name.

## Code

Tokens, once, in one file:

```css
:root {
  --ease:       cubic-bezier(0.2, 0, 0, 1);    /* hover, colour, micro state */
  --ease-enter: cubic-bezier(0.16, 1, 0.3, 1); /* entrances, large surfaces */
  --ease-out-quart: cubic-bezier(0.165, 0.84, 0.44, 1); /* small entrances */
  --ease-exit:  cubic-bezier(0.4, 0, 1, 1);    /* every exit; accelerates away */
  --dur-micro:   120ms;
  --dur-ui:      200ms;
  --dur-overlay: 260ms;
  --dur-page:    340ms;
}
/* Springs live as --ease-<token> linear() strings with --dur-spring-<token> settle times; see assets/motion.css. */
/* If a new animation does not fit one of these, the answer is usually don't. */
```

A named-property transition (Tailwind alternative: `transition-[transform,background-color] duration-[var(--dur-micro)] ease-[var(--ease)]`):

```css
.button {
  transition: transform var(--dur-micro) var(--ease),
              background-color var(--dur-micro) var(--ease);
}
.button:active { transform: scale(0.97); }
```

Enter and exit as a pair, opt-in to motion:

```css
@media (prefers-reduced-motion: no-preference) {
  .panel[data-state="open"]  { animation: panel-in  var(--dur-ui) var(--ease-enter) both; }
  .panel[data-state="closed"] { animation: panel-out calc(var(--dur-ui) * 0.65) var(--ease-exit)  both; }
}
@keyframes panel-in  { from { opacity: 0; transform: translateY(8px);  filter: blur(4px); } }
@keyframes panel-out { to   { opacity: 0; transform: translateY(-8px); } }
```

Stagger without JavaScript (first appearance only, capped):

```css
.list > * { animation: rise var(--dur-ui) var(--ease-enter) both; animation-delay: calc(var(--i, 0) * 35ms); }
.list > :nth-child(n + 9) { animation-delay: 280ms; }
```

Set `style="--i: 3"` per item from the render loop.

The storyboard pattern for a sequenced moment. Timing lives in one object; the JSX reads from config objects, never literals:

```tsx
/* STORYBOARD (ms after trigger)
 *    0   waiting for mount
 *  120   card rises, scale 0.96 -> 1
 *  200   heading fades in
 *  320   rows rise, staggered 35ms
 *  520   action button fades in
 */
const TIMING = { card: 120, heading: 200, rows: 320, action: 520 };
const CARD = { fromScale: 0.96, spring: { type: "spring", visualDuration: 0.4, bounce: 0 } as const };
const ROWS = { stagger: 0.035, offsetY: 8 };

function Figure() {
  const [stage, setStage] = useState(0);
  useEffect(() => {
    const t = [
      setTimeout(() => setStage(1), TIMING.card),
      setTimeout(() => setStage(2), TIMING.heading),
      setTimeout(() => setStage(3), TIMING.rows),
      setTimeout(() => setStage(4), TIMING.action),
    ];
    return () => t.forEach(clearTimeout);
  }, []);
  return (
    <motion.div animate={{ opacity: stage >= 1 ? 1 : 0, scale: stage >= 1 ? 1 : CARD.fromScale }} transition={CARD.spring}>
      {rows.map((r, i) => (
        <motion.div key={r.id}
          animate={{ opacity: stage >= 3 ? 1 : 0, y: stage >= 3 ? 0 : ROWS.offsetY }}
          transition={{ duration: 0.2, ease: "easeOut", delay: i * ROWS.stagger }} />
      ))}
    </motion.div>
  );
}
```

One `stage` integer, one effect, one cleanup. Opacity tweens; scale springs.

Reduced-motion global fallback, only where per-element opt-in is impossible:

```css
@media (prefers-reduced-motion: reduce) {
  *, ::before, ::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

## Checks

- `grep -rn "transition: all\|transition-property: all" src` returns nothing.
- Every duration and easing in the codebase resolves to a token.
- Replay each enter/exit pair at 10% in the Animations panel: exits shorter, no overshoot on exits, pairs move together.
- Reload: nothing above the fold animates in.
- Toggle reduced motion: state changes still happen, nothing travels.
- Count staggered items: the ninth has the same delay as the eighth.

## Do not

- Animate `height`, `width`, `top`, `left`, `margin`, or `padding`. Use `transform` and `grid-template-rows: 0fr → 1fr` for accordions.
- Put `will-change` on anything before you have seen a first-frame stutter. Never `will-change: all`.
- Add a hover transform to an element that does not navigate or open something.
- Fade-and-slide every section as it scrolls into view. See `references/marketing-pages.md`.
- Bounce an icon swap, an opacity, or an exit.
- Use `animation: none` as the reduced-motion switch; it breaks `animationend` listeners.
