# Buttons and controls

Use this when you are building or reviewing any clickable thing: buttons, icon buttons, toggles, segmented controls, sliders, footers with Save and Cancel, anything with a loading or disabled state.
The project's own control tokens win; these are the defaults and the checks.

## Rules

1. **Six states, every button.** Rest, hover, active, focus-visible, loading, disabled. A button with four of the six is unfinished. Check: tab to it, hover it, hold it, submit with it, disable it.
2. **Hover changes colour, not position.** Motion on hover promises a destination; a card that lifts but is not a link lies. ≤ 150ms, `ease`. A lift of 1px is acceptable only on links to other pages. Check: does the hovered element navigate somewhere? If not, colour only.
3. **Press scale from the ladder.** Rows 0.99, surfaces and CTAs 0.97, icon buttons 0.94, floor 0.90. `transition: transform 150ms ease-out`. Never animate from `scale(0)`; start at 0.95. Check: hold a button; it should feel pressed, not shrunk.
4. **Focus ring only on `:focus-visible`.** Keep the browser ring plus `outline-offset: 2px`, or a custom `outline: 2px solid var(--focus-ring)` verified against every colour it crosses. Never `outline: none` without a replacement. Check: tab through the page; every stop is visible.
5. **Loading locks the width.** Measure the resting width, fix it, swap the label for a spinner inside the same box. Nothing else on the page moves. Keep the accessible name (`aria-label` = original label, `aria-busy="true"`). Check: click and watch the layout; zero shift.
6. **Disabled is a muted token, not opacity, and it says why.** Opacity-based disabled states pass or fail contrast at random. Pair the state with a reason in text nearby ("Add a title to publish"). Check: any disabled control with no visible reason is a finding.
7. **`disabled` or `aria-disabled`, never both.** `disabled` removes it from the tab order; `aria-disabled` keeps it reachable and announces the state, but then you block pointer, keyboard, and submission in code. Use `aria-disabled` when the reason should be discoverable by keyboard users. Check: tab to it; does it behave as announced?
8. **Targets 44px touch, 40px pointer, 24px WCAG floor.** Expand with a pseudo-element on the `<button>` or `<label>`, never on an `<input>` (replaced elements do not render `::before` reliably). Two hit areas never overlap; the 24px floor has a spacing exception: a 24px circle centred on the target must not intersect another. Check: DevTools, hover the pseudo-element, measure.
9. **`touch-action: manipulation` on every control.** Removes the 300ms double-tap delay where it still exists and stops accidental zoom. Set `-webkit-tap-highlight-color` to match the design (usually transparent, with your own active state). Check: tap fast twice on mobile; no zoom.
10. **One filled primary per view.** Colour goes on the background of the primary, never on its label. Blue text reads as a link. Secondary is outlined or tinted; tertiary is text-only with a hover background. Check: count filled buttons in the viewport; more than one is a finding.
11. **Icon-only buttons have names.** `aria-label` always; a tooltip does not count. Check: screen reader reads "Close", not "button".
12. **Tooltips open after 200ms, then warm.** First tooltip waits 200ms; while a tooltip is open or was open within the last 300ms, siblings open instantly with no animation. Check: sweep across a toolbar; the first waits, the rest follow the cursor.
13. **Optical alignment: icon side gets 2px less padding.** An icon next to text has less visual mass on that side. `padding-inline-start: 14px; padding-inline-end: 16px` (Tailwind `ps-3.5 pe-4`). A play triangle nudges `translateX(2px)` in a circle. Check: squint; the label looks centred.
14. **Confirmation and copy states hold for 1.5s.** Copy-to-clipboard swaps to a check, "Publishing…" becomes "Published", then reverts. Long enough to read, short enough not to feel stuck. Check: time it.
15. **Footers reserve their final width.** "Done" becomes "Cancel · Save" when dirty; the footer keeps the wider layout from the start and cross-fades labels in 150ms. Nothing reflows. Check: type in a field and watch the footer edge.
16. **The button is the spinner.** On submit, the working button swaps its label for an inline spinner at locked width and stops accepting clicks. No separate loading UI, no second click window. Check: double-click submit; one request.
17. **Toggles are switches.** `<button role="switch" aria-checked>`. The label names the ON state ("Send read receipts"). The thumb moves in ≤ 150ms or instantly; a toggle is a 100×-a-day control. Check: read the label; does "on" make sense?
18. **Segmented controls slide one indicator.** The selected background is one element that moves with the `snappy` spring; labels do not animate. Arrow keys move selection; one Tab stop. Check: press ← → with focus on the control.
19. **Sliders are native inputs, styled.** 6px track, 16px thumb, `:focus-visible` ring via `color-mix`, `:active` scale 1.15 in 120ms. Never a custom drag implementation for a value picker. Check: keyboard arrows change the value.
20. **Every press animation has an escape hatch.** A `static` prop (or class) that removes scale for buttons inside lists, tables, and toolbars where the motion becomes noise. Check: any button pressed 100+ times a day is static.

## Cheat sheet

| State | Value |
|---|---|
| Hover | colour change ≤ 150ms `ease`; no transform unless it navigates |
| Active | `scale(0.97)` CTAs, 0.94 icon buttons, 0.99 rows; `150ms ease-out` |
| Focus | `:focus-visible` ring, `outline-offset: 2px` |
| Loading | width locked, spinner replaces label, `aria-busy` |
| Disabled | muted token (not opacity) + visible reason |
| Target | 44px touch, 40px pointer, 24px floor |
| Tooltip | 200ms delay, warm for 300ms |
| Confirm hold | 1.5s |
| Search debounce | 300ms |
| Label crossfade | 150ms |

| Button role | Fill | Where |
|---|---|---|
| Primary | filled with the accent | once per view |
| Secondary | outlined or tinted surface | beside the primary |
| Tertiary | text only, hover background | menus, toolbars, inline |
| Destructive | filled only in a confirm dialog; text elsewhere | named noun ("Delete project") |

## Code

```css
.btn {
  position: relative;
  min-height: 40px;
  padding-inline: 16px;
  border-radius: var(--radius-md);
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
  transition: background-color 150ms ease, color 150ms ease, transform 150ms ease-out;
}
.btn:active:not([data-static]) { transform: scale(0.97); }
.btn:focus-visible { outline: 2px solid var(--focus-ring); outline-offset: 2px; }
.btn[aria-disabled="true"], .btn:disabled { background: var(--surface-muted); color: var(--ink-muted); }
.btn[aria-busy="true"] > .label { visibility: hidden; }
.btn[aria-busy="true"] > .spinner { position: absolute; inset: 0; display: grid; place-items: center; }

/* icon-side optical padding */
.btn:has(> .icon:first-child) { padding-inline-start: 14px; }

/* hit-area expansion on a small icon button (24px visual, 44px target) */
.icon-btn { position: relative; inline-size: 24px; block-size: 24px; }
.icon-btn::after { content: ""; position: absolute; inset: -10px; }

/* native range, styled */
.range {
  -webkit-appearance: none; appearance: none;
  width: 100%; height: 6px; border-radius: 999px;
  background: var(--track); cursor: pointer; outline: none;
}
.range::-webkit-slider-thumb {
  -webkit-appearance: none; appearance: none;
  width: 16px; height: 16px; border-radius: 50%;
  background: var(--thumb); border: 2px solid var(--canvas);
  box-shadow: 0 1px 3px rgb(0 0 0 / 0.25);
  transition: transform 0.12s ease;
}
.range::-webkit-slider-thumb:active { transform: scale(1.15); }
.range::-moz-range-thumb { width: 16px; height: 16px; border-radius: 50%; background: var(--thumb); border: 2px solid var(--canvas); }
.range:focus-visible { box-shadow: 0 0 0 3px color-mix(in srgb, var(--thumb) 35%, transparent); }
```

```tsx
// Button.tsx: one component, six states, width lock on loading.
import { useLayoutEffect, useRef, useState } from "react";

type Props = React.ComponentProps<"button"> & {
  loading?: boolean;
  static?: boolean;          // disables press scale (lists, toolbars)
  variant?: "primary" | "secondary" | "tertiary";
};

export function Button({ loading, static: isStatic, variant = "secondary", children, ...rest }: Props) {
  const ref = useRef<HTMLButtonElement>(null);
  const [width, setWidth] = useState<number>();
  useLayoutEffect(() => {
    if (loading && ref.current && width === undefined) setWidth(ref.current.offsetWidth);
    if (!loading) setWidth(undefined);
  }, [loading]);
  return (
    <button
      ref={ref}
      className={`btn btn-${variant}`}
      data-static={isStatic || undefined}
      aria-busy={loading || undefined}
      aria-label={loading ? String(children) : undefined}
      style={width ? { width } : undefined}
      onClick={loading ? undefined : rest.onClick}
      {...rest}
    >
      <span className="label">{children}</span>
      {loading && <span className="spinner" aria-hidden="true">…</span>}
    </button>
  );
}
// If you need the styles on an <a>, expose an `asChild` prop (Base UI / Radix Slot pattern)
// rather than rendering a <button> inside a link. A link is not a button.
```

```tsx
// Copy to clipboard: check for 1.5s, then revert.
const [copied, setCopied] = useState(false);
async function copy(text: string) {
  await navigator.clipboard.writeText(text);
  setCopied(true);
  setTimeout(() => setCopied(false), 1500);
}
```

```tsx
// Done → Cancel · Save: reserve the wider width; cross-fade the labels.
<div className="footer" style={{ minWidth: "var(--footer-dirty-width)" }}>
  {dirty ? (
    <>
      <Button variant="tertiary" onClick={reset}>Cancel</Button>
      <Button variant="primary" loading={saving} onClick={save}>Save</Button>
    </>
  ) : (
    <Button variant="primary" onClick={close}>Done</Button>
  )}
</div>
```

```css
.footer > * { transition: opacity 150ms ease; }
```

## Checks

- Tab through every control; the ring shows on every stop and only on keyboard focus.
- Hold each button; the scale matches the ladder and nothing below 0.90 exists.
- Click submit twice fast; the network tab shows one request.
- Disable every control in turn; each has a visible reason.
- Measure icon buttons in DevTools; the pseudo-element reaches 44px.
- Sweep a toolbar with the cursor; the first tooltip waits, the rest are instant.
- Type in a form with a Done footer; the footer edge does not move.
- Screen reader over icon buttons; each reads a verb.

## Do not

- Animate hover position on anything that does not navigate.
- Put two filled buttons side by side.
- Use `opacity` to mean disabled.
- Put both `disabled` and `aria-disabled` on one element.
- Expand hit areas on an `<input>`; do it on the `<label>`.
- Render a `<div onClick>` where a `<button>` belongs.
- Show a spinner anywhere except inside the button that is working, at locked width.
- Build a slider from divs when `<input type="range">` will do.

See `references/forms-and-inputs.md` for submit rules, `references/overlays.md` for confirm dialogs, `references/motion.md` for the easing tokens.
