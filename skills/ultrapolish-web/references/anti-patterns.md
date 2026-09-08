# Anti-patterns and AI tells

Each entry is a thing that reads as "made by nobody in particular". Every one has a fix and a way to spot it. This is a negative list: it says what to refuse, not what to choose. A project whose design contract owns one of these keeps it; the tell is choosing it by default.

## Motion

### `transition: all`
Why it reads as careless: it animates properties you did not intend (layout, colour, shadow) on their own timings, so nothing lines up, and it costs layout on every frame.
The fix: name the property. `transition: transform 150ms ease-out, opacity 150ms ease-out;`. Tailwind's bare `transition` is a curated list, not `all`; `transition-transform` covers `transform, translate, scale, rotate`.
How to spot it: `grep -rn "transition: all\|transition-all"`.

### `will-change` on everything
Why: each promoted layer costs memory; promoted text blurs; nothing gets faster.
The fix: remove it. Add `will-change: transform` only to one element after you have observed a first-frame stutter in the Performance panel.
How to spot it: `grep -rn "will-change"`; more than a handful of hits is the finding.

### Fade-and-slide-up on every section as it scrolls into view
Why: it is the statistical average of every template, delays content the reader already scrolled to, and triggers vestibular discomfort by default.
The fix: delete it. Keep one orchestrated hero moment gated by `sessionStorage`. See `references/marketing-pages.md`.
How to spot it: `grep -rn "whileInView\|IntersectionObserver\|data-aos"`; open the Animations panel and scroll.

### Hover lift on every card
Why: lift promises navigation; a card that lifts and goes nowhere teaches the reader to distrust hover.
The fix: cards that navigate change one thing (border or underline colour). Cards that do not navigate do nothing on hover.
How to spot it: hover each card; ask where it goes.

### Spring on opacity
Why: opacity has no mass; a bounce past 1 clamps and reads as a stutter.
The fix: opacity tweens, `200ms ease-out`. Transforms may spring.
How to spot it: any `type: "spring"` whose target includes `opacity`.

### Bounce on an icon swap
Why: a check mark that overshoots looks like a toy.
The fix: `scale 0.25 → 1`, `blur(4px) → 0`, `{ duration: 0.3, bounce: 0 }`.
How to spot it: contextual icons with `bounce` > 0.

### Stagger beyond eight items
Why: the last item arrives after the reader has already looked at it.
The fix: 30–40ms per item, cap around 8, first appearance only.
How to spot it: `staggerChildren` on lists without a cap.

### Exits slower than entrances, or bouncy
Why: people want out faster than they wanted in.
The fix: exit at 0.65× the entrance, accelerating curve `cubic-bezier(0.4, 0, 1, 1)`, no bounce.
How to spot it: compare `exit` and `animate` durations in the same component.

### Reduced motion handled with `animation: none`, or not at all
Why: `none` never fires `animationend`, so JS waiting on it hangs; ignoring the preference is a vestibular hazard.
The fix: opt-in motion under `prefers-reduced-motion: no-preference`; kill switch at `0.01ms`.
How to spot it: `grep -rn "prefers-reduced-motion"`; zero hits or `animation: none` inside.

## Colour and surfaces

### One border-radius on everything
Why: the same radius on a 900px card and a 20px chip makes the chip look like a lozenge and the card look like a chip; nested corners collide.
The fix: three radii at most; nested radius = outer − padding.
How to spot it: `grep -rn "rounded-xl\|border-radius"`, count distinct values and their contexts.

### The same `rgba(0,0,0,.1)` shadow under every card
Why: one soft grey blur under identical cards is the SaaS-template signature.
The fix: shadow-as-border in light (`0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04)`), a single white ring in dark, and an elevation ladder by named surface.
How to spot it: `grep -rn "rgba(0, *0, *0, *0.1)"`.

### The five generic palettes and chrome
Cream near `#F4F1EA` with a serif and terracotta near `#D97757`; near-black plus one acid accent; broadsheet hairlines at zero radius; the identical-card kit; template chrome (ALL-CAPS eyebrows, middle-dot meta, a WORD then a spaced em dash then a fragment, `#0B0B0B` or `#111` posing as black, mono for small labels, an arrow appended to links).
Why: each is the default output of a thousand generators.
The fix: keep the project's own palette; if the project has none, write the design contract first. Remove eyebrows, arrows, and middle dots unless they carry information.
How to spot it: `grep -rn "F4F1EA\|D97757\|#111\b\|#0B0B0B\|uppercase.*tracking"`.

### A single word in a headline italicised or coloured for effect
Why: it is a decoration that pretends to be emphasis.
The fix: one weight, one colour, a shorter headline.
How to spot it: `<em>` or a colour span inside an `<h1>`.

### Numbered markers on content that is not a sequence
Why: 01 / 02 / 03 promises order that does not exist.
The fix: drop the numbers unless reordering would break meaning.
How to spot it: could the items be shuffled?

### `backdrop-filter` without `saturate`
Why: blur desaturates; the result is grey mush.
The fix: `backdrop-filter: blur(24px) saturate(180%)`.
How to spot it: `grep -rn "backdrop-filter" | grep -v saturate`.

### `backdrop-filter` on a scrolling or animating element
Why: it re-rasterises every frame anything behind it moves; it is the number-one frame killer.
The fix: static chrome only, two or three per screen.
How to spot it: Performance panel, scroll, look for long paint bars on the blurred element.

### Opacity-based disabled states
Why: `opacity: 0.4` passes or fails contrast at random depending on the background.
The fix: a muted token pair, explicit and measured, plus a reason the control is disabled.
How to spot it: `grep -rn "disabled:opacity\|:disabled.*opacity"`.

### Blue text that is not a link; accent hue on a non-interactive element
Why: colour is a promise of interactivity.
The fix: one colour, one meaning; anything within ±15° of the accent hue is either interactive or recoloured.
How to spot it: click every blue thing.

### Tinted near-black posing as black
Why: `#111` under a `#000` heading reads as a mistake; it is the tell of a template that could not decide.
The fix: one ink, stepped in alpha for hierarchy.
How to spot it: count distinct dark greys in the token file.

## States

### Spinner on the clicked button
Why: it says "the button is thinking" instead of "your thing is arriving".
The fix: lock the button's width and swap the label for a spinner in the same box, or better, show progress where the result will appear.
How to spot it: click, watch where the spinner lands.

### Spinner before 300ms
Why: a flash of spinner for a fast request reads as slowness.
The fix: nothing for 300ms, then a skeleton with final dimensions.
How to spot it: throttle to fast 3G; anything that flashes is the finding.

### Skeleton that does not match the content
Why: the illusion breaks when three bars become five lines.
The fix: same count, widths, and positions as the real content.
How to spot it: overlay the skeleton and the loaded state.

### Toast for a field error
Why: the error vanishes before the reader finds the field.
The fix: inline on the label row, `aria-invalid`, focus the field.
How to spot it: submit an invalid form and watch the top-right corner.

### Toast that vanishes with the only Undo
Why: data loss on a timer.
The fix: 5s floor, pause on hover, persist when it carries an action.
How to spot it: trigger a destructive action and count.

## Controls and forms

### Submit disabled until the form is valid
Why: users get a dead button and no explanation.
The fix: keep it enabled, validate on submit, focus the first invalid field.
How to spot it: `grep -rn "disabled={!isValid\|disabled={!form"`.

### `autocomplete="off"` on identity or payment fields
Why: it fails WCAG 1.3.5 and forces retyping.
The fix: the right token (`email`, `cc-number`, `one-time-code`, …).
How to spot it: `grep -rn 'autocomplete="off"'`.

### Paste blocked
Why: it defeats password managers and OTP autofill.
The fix: remove the handler; trim values before validating.
How to spot it: `grep -rn "onPaste"` with `preventDefault`.

### Hit area on the `<input>`
Why: replaced elements do not render pseudo-elements reliably; the expansion silently fails.
The fix: pseudo-element on the wrapping `<label>` or `<button>`.
How to spot it: DevTools box on the checkbox is 16px.

### `z-index: 9999`
Why: it means the stack was never designed; the next overlay will be 10000.
The fix: a scale (`100 / 200 / 300 / 400`) or `isolation: isolate`.
How to spot it: `grep -rn "z-index: *9\{3,\}\|z-\[9"`.

## Copy

### "Are you sure?" with OK / Cancel
Why: neither button names the consequence.
The fix: "Delete project?" with "Delete project" and "Cancel".
How to spot it: grep for "Are you sure".

### "Oops! Something went wrong."
Why: it apologises and says nothing.
The fix: "Unable to save. Check your connection and try again."
How to spot it: grep for "Oops", "Something went wrong", "We're having trouble".

### Emoji bullets and corporate openers
Why: checkmark and rocket lists are the most recognisable machine-written pattern; "We're thrilled to announce" says nothing.
The fix: plain bullets, or prose; lead with the thing.
How to spot it: grep the copy for the emoji ranges and for "thrilled".

## Structure and performance

### `100vh` layouts
Why: iOS Safari's largest viewport overflows under the URL bar.
The fix: `dvh` for fill, `svh` for fixed chrome.
How to spot it: `grep -rn "100vh"`.

### `maximum-scale=1` or `user-scalable=no`
Why: fails WCAG 1.4.4; Safari ignores it anyway.
The fix: inputs at 16px, remove the flag.
How to spot it: the viewport meta.

### `position: fixed` on body to lock scroll
Why: loses scroll position and breaks the keyboard.
The fix: `<dialog>` + `overscroll-behavior: contain`, or `inert`.
How to spot it: grep for `body.style.position`.

### `-webkit-overflow-scrolling: touch`
Why: default since iOS 13; it is dead code that signals a copied snippet.
The fix: delete it.
How to spot it: grep.

### Fonts introduced by the polish pass
Why: a polish pass that adds a typeface is a restyle; Inter-by-default is its own tell.
The fix: use what the project owns. If it owns nothing, the design contract decides, not the audit.
How to spot it: diff `font-family` before and after the pass.

### `setState` inside a drag handler
Why: a React render per pointer event drops frames.
The fix: `useMotionValue`, or a ref and a single rAF.
How to spot it: `onDrag` bodies that call a state setter.

## Marketing

### Scroll hijacking, parallax, auto-advancing carousels
Why: scroll belongs to the reader; parallax off 1:1 is a vestibular trigger; carousels hide content.
The fix: remove; show the content.
How to spot it: scroll with the trackpad and watch the page do something else.

### An arrow glyph after link text
Why: it decorates the link instead of describing the destination.
The fix: descriptive link text.
How to spot it: grep for the arrow character in JSX.

### OG image that dies at 200px
Why: Slack and iMessage render it at 200px wide; small type vanishes.
The fix: headline ≥ 80px at 1200 wide, one focal point, tested at 200×105 and in greyscale.
How to spot it: resize the image to 200 wide.
