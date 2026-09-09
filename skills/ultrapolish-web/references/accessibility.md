# Accessibility as polish

Use this when building or reviewing any interactive component, form, overlay, or route, and whenever something "works with a mouse" but has not been tried with a keyboard, a screen reader, zoom, or reduced motion. The interfaces people love are the ones that hold together under all four.

## Rules

1. **`:focus-visible` only, and a ring you can see.** Keep the browser ring and add `outline-offset: 2px`, or draw a custom `outline: 2px solid var(--focus-ring)` and verify it against every colour it crosses. `currentColor` is not automatically visible. Never `forced-color-adjust: none` inside `forced-colors: active`. Check: Tab through the primary path; the ring is visible at every stop, including on the accent-coloured button.
2. **`tabindex` is 0 or -1, never positive.** Composite widgets (tabs, toolbars, grids, listboxes) use roving tabindex: the active item is 0, the rest are -1, arrows move within, Tab leaves. Check: `grep -rn 'tabindex="[1-9]'` returns nothing.
3. **Modals use `<dialog>` with `showModal()`, or `inert` on everything else.** Focus the least destructive action on a destructive confirm. Return focus to the trigger on close. `overscroll-behavior: contain` inside. Check: open, Tab wraps inside; Escape closes; focus lands back on the button that opened it.
4. **Escape closes whatever opened last.** Tooltip, then menu, then dialog. Check: open a menu inside a dialog; Escape closes the menu only.
5. **Custom widgets keep the APG keyboard promise.** A role is a contract (see cheat sheet). Check: implement the table row for every `role=` you ship.
6. **Reduced motion is opt-in, and reduced, not eliminated.** Wrap motion in `@media (prefers-reduced-motion: no-preference)`. If you must use a global kill switch, set durations to `0.01ms`, not `none`, so `animationend` and `transitionend` still fire. Disable parallax, autoplay, and large-scale movement; replace slides and zooms with opacity crossfades; keep spinners, focus rings, and brief functional feedback. Check: emulate reduced motion in DevTools; the app still responds visibly to every action.
7. **The global kill switch is a floor, not a solution.** A `*` selector reaches CSS animations and transitions in the document, and nothing else. It does not reach five things, each of which is capable of being the single largest movement in your app. A project that honours reduced motion in a dozen hand-written CSS blocks still fails if its biggest slide is driven by JavaScript. Check: list every animation over 100px of travel, then name the mechanism driving each one.
8. **Anything that moves, blinks, or updates for more than five seconds has a visible pause.** Toasts stay at least 5s, pause on hover and focus, and persist when they carry an action or an error. Check: hover a toast; the timer stops.
9. **Zoom to 200% and reflow at 320px.** Text scales, nothing clips, no horizontal scrolling except in data tables and diagrams that scroll inside their own container. Check: 1280px wide at 400% zoom, and DevTools at 320px.
10. **`rem` for type, text containers, and breakpoints; `px` for hairlines, rings, and shadows.** Why: users who scale text expect layout to scale with it; borders should not. Check: grep breakpoints; media queries use `rem` or `em`.
11. **Visually hidden text uses the canonical `.sr-only` block.** 1px, not 0; `clip-path: inset(50%)`; `white-space: nowrap`. Never `display: none` for content a screen reader should read. Check: the class matches the block below.
12. **Choose how to announce.** Move focus for a new view; `aria-describedby` for context on a control; `role="status"` for polite updates; `role="alert"` only for urgent interruptions. Keep a stable, empty live region in the DOM for repeated polite updates. Check: a screen reader hears "Saved" once, not twice, and not the whole form.
13. **Never disable submit until valid.** Keep it enabled, validate on submit, set `aria-invalid="true"` and `aria-describedby` on each failing field, focus the first invalid field. Disable only once the request starts, keeping the label beside the spinner. Check: submit an empty form; focus lands on the first error and the error is read.
14. **`autocomplete` is a WCAG requirement (1.3.5).** `name`, `email`, `tel`, `street-address`, `postal-code`, `cc-number`, `cc-exp`, `cc-csc`, `username`, `current-password`, `new-password`, `one-time-code`. Never `autocomplete="off"` on identity or payment fields. Never block paste. Check: every identity field has a token.
15. **Alt by purpose.** Decorative: `alt=""` present, never missing (a missing alt reads the filename). Functional: name the action, `alt="Search"`, not the picture. Complex: a short summary plus a data table nearby. SVG: decorative gets `aria-hidden="true" focusable="false"`; meaningful gets `role="img"` and `aria-label`. Check: `grep -rn "<img" | grep -v "alt="` returns nothing.
16. **The visible label is in the accessible name.** Name precedence: `aria-labelledby` > `aria-label` > native label, text, alt > `title`. A button that shows "Save" must not be named "Submit form". Mark brand names and identifiers `translate="no"`. Check: inspect the accessibility tree; names match what is on screen.
17. **`aria-disabled` or `disabled`, never both.** With `aria-disabled` you must block pointer, keyboard, and submission in code and style it yourself. Check: grep for elements carrying both.
18. **Route changes announce themselves.** Update `document.title`, move focus to the new view's `<h1 tabindex="-1">` or `<main>`, restore scroll on back and forward, scroll to top on forward. Check: navigate with a screen reader running; the new page title is spoken.
19. **Hit areas: 24px floor, 44 touch, 40 pointer.** Expand with a pseudo-element on the wrapping `<button>` or `<label>`, never on the `<input>` (replaced elements do not render pseudo-elements reliably). Two hit areas never overlap. The 24px floor has a spacing exception: a 24px circle centred on the target must not intersect another target. Check: DevTools, hover each control, read the box.
20. **Colour never carries meaning alone.** Pair with a symbol, a label, or a pattern. Check: view in greyscale; can you still tell error from success?
21. **Respect `prefers-contrast: more` and `prefers-reduced-transparency`.** Widen the lightness gap by at least 0.15 L; swap translucent surfaces for solid. Check: emulate both in DevTools.

## Cheat sheet: what the kill switch does not reach

| Not reached | Why | Fix |
|---|---|---|
| Motion, GSAP, `element.animate()` | JS and WAAPI animations are not CSS; no selector touches them | `<MotionConfig reducedMotion="user">` at the root; `useReducedMotion()` to guard hand-rolled WAAPI |
| `::view-transition-*` | The transition pseudo-elements live in their own tree, outside the document | A separate `@media` block targeting `::view-transition-group(*)` and siblings |
| Canvas and WebGL render loops | A `requestAnimationFrame` loop is code, not style | `matchMedia("(prefers-reduced-motion: reduce)")` before you start the loop |
| `<video autoplay>`, animated GIF and WebP | Playback is not animation | Drop `autoplay`, or swap the poster for the animated source only under `no-preference` |
| Scroll-linked effects | `animation-timeline: scroll()` is still an animation, but a JS scroll handler is not | Guard the handler with the same `matchMedia` check |

## Cheat sheet: APG keyboard contracts

| Widget | Keys |
|---|---|
| Dialog | Tab / Shift+Tab cycle inside and wrap; Escape closes; focus returns to trigger |
| Tabs | Arrows move between tabs (wrap); Tab exits to the panel; Home / End jump |
| Menu button | Enter / Space / ArrowDown opens to first item; ArrowUp opens to last; arrows move; Escape closes and refocuses the button |
| Disclosure | A `<button aria-expanded>`; Enter and Space toggle |
| Combobox | ArrowDown opens or moves into the list; Enter accepts; Escape closes and returns to the input; typing filters |
| Listbox / radio group | Arrows move selection; one Tab stop for the group |

Universal: arrows move inside a composite, Tab moves between composites. Enter submits the focused input's form; in a `<textarea>` Enter inserts a newline and Cmd/Ctrl+Enter submits.

## Cheat sheet: announcement ladder

This is the canonical statement of the ladder. Other references point here rather than repeating it.

| Change | Mechanism | Example |
|---|---|---|
| A new view or step | Move focus to its heading | route change, wizard step |
| Extra context on a control | `aria-describedby` | "Must be at least 8 characters" |
| Polite status | `role="status"` (stable empty region, update its text) | "Saved", "3 results" |
| Urgent interruption | `role="alert"` | "Connection lost. Changes not saved." |

Pick the lowest rung that works. Two rungs for one change is a double announcement.

## Cheat sheet: units

| Use `rem` | Use `px` |
|---|---|
| `font-size` | borders and hairlines |
| text container `max-width` | focus outline width and offset |
| media-query breakpoints | `box-shadow` offsets and blur |
| spacing that should scale with text | fixed decorations and icons inside buttons |

## Code

```css
.sr-only {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  clip-path: inset(50%);
  white-space: nowrap;
  border: 0;
}

:focus-visible { outline: 2px solid var(--focus-ring); outline-offset: 2px; }

/* Motion is opt-in */
@media (prefers-reduced-motion: no-preference) {
  .card { transition: transform 200ms cubic-bezier(0.165, 0.84, 0.44, 1); }
}
/* Fallback kill switch for legacy code. A floor, not a solution: this
   reaches CSS animations and transitions in the document and nothing else. */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* View transitions live in their own tree, which the rule above cannot enter. */
@media (prefers-reduced-motion: reduce) {
  ::view-transition-group(*),
  ::view-transition-old(*),
  ::view-transition-new(*) {
    animation: none !important;
  }
}

/* Hit area on the button, not the input */
.check { position: relative; }
.check::after { content: ""; position: absolute; inset: -10px; }
```

```tsx
// Form errors
<label htmlFor="email">Email</label>
<input id="email" type="email" autoComplete="email" inputMode="email"
  aria-invalid={!!error} aria-describedby={error ? "email-error" : undefined} />
{error && <p id="email-error" role="alert">{error}</p>}

// Motion, GSAP, and any WAAPI animation need their own guard.
<MotionConfig reducedMotion="user">
  <App />
</MotionConfig>

// A render loop is code, so ask before you start it.
const still = matchMedia("(prefers-reduced-motion: reduce)");
function start() {
  if (still.matches) { drawOneFrame(); return; }
  raf = requestAnimationFrame(tick);
}
still.addEventListener("change", () => { cancelAnimationFrame(raf); start(); });

// Route change
useEffect(() => {
  document.title = `${pageTitle} · ${appName}`;
  headingRef.current?.focus();
}, [pathname]);
<h1 ref={headingRef} tabIndex={-1}>{pageTitle}</h1>
```

## Checks

1. Keyboard-only pass through the primary path: every control reachable, ring visible, Escape ladder correct, focus returns after every overlay.
2. VoiceOver on Safari (Cmd+F5): headings navigable, controls named as shown, errors announced once.
3. axe or Lighthouse: zero critical issues; read every "needs review".
4. 200% zoom at 1280 and 320px width: no clipping, no horizontal scroll.
5. Emulate `prefers-reduced-motion`, `prefers-contrast: more`, `prefers-reduced-transparency`, `forced-colors`.
6. Greyscale screenshot: state still legible.
7. `grep -rn 'tabindex="[1-9]'`, `grep -rn "<img" | grep -v alt=`, `grep -rn 'autocomplete="off"'`: zero hits or each justified.
8. **Audit every role against its keyboard handling.** A role is a contract, and a broken one is invisible to a mouse, which is why this is often the most productive grep in a review. Count the composite roles you ship, then count the keyboard code in the same files:

   ```bash
   grep -rEn 'role="(radiogroup|tablist|menu|menubar|listbox|tree|grid)"' src | wc -l
   grep -rn 'onKeyDown\|tabIndex' src | wc -l
   # then, per file:
   grep -rlE 'role="(radiogroup|tablist|menu|listbox)"' src \
     | xargs -I{} sh -c 'printf "%s roles=%s keys=%s\n" {} \
         "$(grep -cE "role=\"(radiogroup|tablist|menu|listbox)\"" {})" \
         "$(grep -c "onKeyDown" {})"'
   ```

   Any file with roles and zero `onKeyDown` is a promise the markup makes and the code does not keep.

## Do not

- Remove the focus ring without replacing it with one you verified.
- Use `display: none` for text a screen reader should read.
- Disable submit until the form validates.
- Set `autocomplete="off"` on a name, email, address, card, or OTP field.
- Block paste.
- Announce the same change twice (focus move plus alert).
- Handle reduced motion with `animation: none`.
- Ship a global kill switch and assume JavaScript animation is covered.
- Ship a `role=` without its keyboard contract.
