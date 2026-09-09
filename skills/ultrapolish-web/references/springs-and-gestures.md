# Springs and gestures

Use this when something has mass, follows a finger, or can be interrupted mid-flight: sheets, drawers, drag-to-reorder, swipe-to-dismiss, pull-to-refresh, shared-element moves. For curves and durations on ordinary transitions see `references/motion.md`; for scroll containers see `references/scroll.md`.

## Rules

1. **Parameterise springs by `visualDuration` and `bounce`.** `visualDuration` is the time to first reach the target; the settle happens after. `duration` in Motion means total time including settle and makes every spring feel slow. Stiffness, damping, and mass are for modelling something physical, not for UI. Check: no `stiffness:` in the codebase outside a physics demo.
2. **Springs are for mass and interruption.** Drag release, sheet dismiss, reorder, anything a second gesture can retrigger before it settles. Hover, colour, opacity, and tooltips use curves. Opacity never springs. Check: every `type: "spring"` is on `x`, `y`, `scale`, or `rotate`.
3. **Exit with `exitOf()`.** Exit springs use `visualDuration × 0.65` and `bounce: 0`. Out is faster than in, and an exit that overshoots looks like it changed its mind. Check: no exit transition carries a nonzero bounce.
4. **Bake springs into CSS for anything non-interruptible.** A `linear()` easing with 100+ sampled points costs the same as `linear(0, 1)` at runtime. Generate strings at build time from the same tokens (`assets/gen-springs.mjs`) and pair each with its measured settle duration, which is always longer than the visual duration. Check: `--ease-snappy` and `--dur-spring-snappy` exist as a pair.
5. **Velocity beats position.** Dismiss when velocity exceeds 500px/s regardless of distance. An upward flick always cancels. Only when velocity is small does position decide, at 50% of the height. The user's intent is in the derivative. Check: a hard flick from 10% down dismisses.
6. **Rubber-band past the boundary with Apple's constant.** `(1 − 1 / (offset / dimension × 0.55 + 1)) × dimension` is asymptotic: you can drag forever and never reach the dimension. That is why it feels like elastic and not a wall. Check: overscroll slows smoothly and never hits a stop.
7. **Animate from the current value, never the target.** When a gesture reverses or a second tap lands mid-flight, start the new animation from where the element is now and blend the velocity. A hard cut in velocity reads as a brick wall. Motion does this by default; do not reset state before animating. Check: tap open, tap close halfway; the element turns back from where it was.
8. **Decompose 2D motion into independent X and Y springs.** One spring on a 2D distance desynchronises the axes and the object curves. Check: a diagonal drag release travels straight.
9. **Recognise, then commit.** Tap tolerance ~10px (allow cancel by dragging away and back). Drag commits to an axis after ~10px of movement. Detect all plausible gestures in parallel from the first move, then cancel the losers. Check: a slight wobble while tapping still taps; a diagonal drag picks one axis.
10. **Never `setState` in a drag handler.** Bind the drag to a `MotionValue` and transform it; a React re-render per pointer move drops frames on mid-range devices. Check: React DevTools highlight shows no renders during a drag.
11. **Sheets arbitrate scroll and drag.** If the sheet's content is scrolled to the top and the finger moves down, the sheet moves. Otherwise the content scrolls. Getting this wrong is what makes web sheets feel broken. Check: scroll a long sheet up, then drag down; it scrolls back to top before the sheet moves.
12. **Do not build a custom scroller.** Platform momentum (iOS decelerates at ~0.998 per ms) is tuned per device and runs off the main thread. Use native overflow and `scroll-snap`. Check: no `wheel` or `touchmove` handler implements scrolling.

## Cheat sheet

| Token | Motion config | CSS settle (approx.) | Use |
|---|---|---|---|
| micro | `{ type: "spring", visualDuration: 0.2, bounce: 0.12 }` | ~320ms | press, checkbox, icon swap |
| snappy | `{ type: "spring", visualDuration: 0.3, bounce: 0.18 }` | ~480ms | default: toggles, tab indicators, chips |
| smooth | `{ type: "spring", visualDuration: 0.4, bounce: 0 }` | ~400ms | sheets, modals, panes |
| bouncy | `{ type: "spring", visualDuration: 0.35, bounce: 0.32 }` | ~700ms | likes, badges, one celebration |
| gentle | `{ type: "spring", visualDuration: 0.6, bounce: 0 }` | ~600ms | backdrops, hero reveals |
| exit | `exitOf(token)` | | every exit |
| instant | `{ duration: 0 }` | | reduced motion, live drag tracking |

Bigger element: longer duration, less bounce. A full-screen sheet with `bounce: 0.3` looks like a bug. Anything the user did not initiate: `gentle`.

| Threshold | Value |
|---|---|
| Dismiss velocity | 500px/s |
| Dismiss distance | 50% of height |
| Rubber-band constant | 0.55 (Motion `dragElastic` ≈ 0.2–0.3) |
| Tap tolerance | ~10px |
| Drag axis commit | ~10px |
| Sheet content offset | +80ms after the container, stagger 30ms |

| Shared element | Use when |
|---|---|
| View Transitions API | Cross-route, DOM replaced, no JS state needed; snapshot-based |
| `layoutId` | Same React tree, element persists, must be interruptible |

## Code

Tokens and `exitOf()` (see `assets/motion.ts`):

```ts
import type { Transition } from "motion/react";

export const SPRING = {
  micro:  { type: "spring", visualDuration: 0.2,  bounce: 0.12 },
  snappy: { type: "spring", visualDuration: 0.3,  bounce: 0.18 },
  smooth: { type: "spring", visualDuration: 0.4,  bounce: 0 },
  bouncy: { type: "spring", visualDuration: 0.35, bounce: 0.32 },
  gentle: { type: "spring", visualDuration: 0.6,  bounce: 0 },
} as const satisfies Record<string, Transition>;

export const TWEEN = { fade: { duration: 0.2, ease: "easeOut" } } as const;

export const exitOf = (s: { visualDuration: number }): Transition =>
  ({ type: "spring", visualDuration: s.visualDuration * 0.65, bounce: 0 });
```

Generate CSS springs at build time (`node assets/gen-springs.mjs > motion.generated.css`):

```js
import { spring } from "motion";
const gen = spring({ visualDuration: 0.3, bounce: 0.18, keyframes: [0, 1] });
// sample until done to find settle, then 60 points across it -> linear(...)
```

Dismissal predicate and rubber band:

```ts
const DISMISS_VELOCITY = 500; // px/s
const DISMISS_DISTANCE = 0.5; // of height

export function shouldDismiss(offsetY: number, velocityY: number, height: number) {
  if (velocityY > DISMISS_VELOCITY) return true;    // flick beats position
  if (velocityY < -DISMISS_VELOCITY) return false;  // upward flick always cancels
  return offsetY > height * DISMISS_DISTANCE;
}

export function rubberBand(offset: number, dimension: number, c = 0.55) {
  return (1 - 1 / ((offset / dimension) * c + 1)) * dimension;
}
// apply only past the boundary
const y = raw < 0 ? -rubberBand(-raw, sheetHeight) : raw;
```

A draggable sheet with velocity handoff:

```tsx
import { motion, useMotionValue, useTransform } from "motion/react";

function Sheet({ height, onDismiss }: { height: number; onDismiss: () => void }) {
  const y = useMotionValue(0);
  const backdrop = useTransform(y, [0, height], [1, 0]); // no setState, no re-render
  return (
    <>
      <motion.div className="backdrop" style={{ opacity: backdrop }} />
      <motion.div
        className="sheet"
        style={{ y, borderRadius: 16 }}       /* inline radius so layout animations correct it */
        drag="y"
        dragConstraints={{ top: 0, bottom: 0 }}
        dragElastic={0.2}
        dragTransition={{ bounceStiffness: 500, bounceDamping: 40 }}
        initial={{ y: "100%" }}
        animate={{ y: 0 }}
        exit={{ y: "100%", transition: exitOf(SPRING.smooth) }}
        transition={SPRING.smooth}
        onDragEnd={(_, info) => {
          if (shouldDismiss(info.offset.y, info.velocity.y, height)) onDismiss();
        }}
      >
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}
          transition={{ ...TWEEN.fade, delay: 0.08 }}>
          {/* contents arrive 80ms after the container */}
        </motion.div>
      </motion.div>
    </>
  );
}
```

Vaul handles the arbitration and snap points and is the pragmatic default; its gap is no spring settle. Build on a headless dialog plus the code above when that settle matters.

Interruptible back-swipe shape (edge gesture drives a MotionValue; release decides):

```ts
onDragEnd: (_, info) => {
  const commit = info.velocity.x > 500 || info.offset.x > width * 0.5;
  animate(x, commit ? width : 0, commit ? SPRING.smooth : exitOf(SPRING.smooth));
}
```

`layout` gotchas:

```tsx
<motion.div layout style={{ borderRadius: 12 }}>      {/* radius inline, not in CSS */}
  <motion.p layout="position">Text does not shimmer</motion.p>
</motion.div>
<motion.ul layoutScroll style={{ overflow: "auto" }} />  {/* scroll containers */}
<motion.div layoutRoot style={{ position: "fixed" }} /> {/* fixed ancestors */}
```

A shared-layout element under a continuously animating ancestor transform
does not travel. `layout` and `layoutId` work by measuring the box before and
after and inverting the difference; if a parent carries a CSS animation on
`transform`, every measurement reads a different origin and the element lands
at its destination instead of moving to it. The same applies to a parent
being dragged, or to any ancestor whose transform is driven outside React.
When an indicator has to slide inside a surface that is itself moving, drive
it by index rather than by measurement: one absolutely positioned element,
`x` animated as a percentage of its own width. A percentage of self needs no
box read, so it is immune to whatever the ancestor is doing.

## Checks

- Flick a sheet down from 10%: it dismisses. Drag slowly to 40% and release: it returns.
- Drag past the top: movement slows asymptotically, never stops dead.
- Open then close mid-animation: the element reverses from its current position with no jump.
- Diagonal drag release travels in a straight line.
- React DevTools shows zero renders during a drag.
- `--ease-*` and `--dur-*` pairs exist for every token used in CSS.

## Do not

- Spring opacity, colour, or blur.
- Use `duration` with `bounce` on a Motion spring; use `visualDuration`.
- Decide dismissal by position alone.
- Reset a MotionValue to its start before re-animating.
- Put `border-radius` in a stylesheet on a `layout` element.
- Reimplement momentum scrolling in JavaScript.
