# Overlays

Use this when you are building or reviewing anything that floats above the page: modals, sheets and drawers, popovers and menus, tooltips, toasts, confirmation dialogs.
The project's overlay library is fine; these rules apply on top of Vaul, Base UI, Radix, or a hand-rolled `<dialog>`.

## Rules

1. **Paired elements share easing and duration.** Modal and backdrop, tooltip and arrow, drawer and scrim move as one object. Two curves on one gesture read as two things. Check: replay at 10% speed; nothing lags its partner.
2. **Exits are shorter and accelerate.** 0.65× the entrance, `cubic-bezier(0.4, 0, 1, 1)`, no bounce. Sometimes the right exit is none: remove immediately when the user is already looking elsewhere. Check: close feels faster than open.
3. **Use `<dialog>` with `showModal()`.** You get the focus trap, `inert` on everything else, Escape, and the top layer for free. Check: Tab never leaves the modal; Escape closes it.
4. **A hand-rolled portal owes you the three things `<dialog>` gave you free.** `createPortal` with `role="dialog"` is the common case in React and it is usually 90% right, which is why the missing 10% survives review. You owe: `aria-modal="true"` on the panel, `inert` on the app root while it is open and removed after, and `document.activeElement` stored before you open and refocused on close. Of those, `aria-modal` is the one to check first: without it you have not merely failed to trap focus, you have actively told assistive technology the background is still available while it is covered. That is a worse failure than no trap at all, because it is a lie rather than an omission. Check: with the overlay open, run the screen reader's next-item command past the last control; you should not reach the page underneath.
5. **Focus the least destructive action on destructive confirms.** The default focus in "Delete project?" is Cancel. Enter should never delete. Check: open the confirm, press Enter, nothing is lost.
6. **Return focus to the trigger on close.** Otherwise keyboard users land at the top of the document. Check: close with Escape; the opening button has the ring.
7. **`overscroll-behavior: contain` inside every scrolling overlay.** Reaching the end of a sheet's content must not scroll the page behind it. Check: scroll to the bottom of the sheet and keep going.
8. **Lock page scroll without `position: fixed` on body.** `html { overflow: hidden; scrollbar-gutter: stable }` while open, so the layout does not jump by the scrollbar width and iOS does not lose its scroll position. Check: open and close a modal; the page has not moved.
9. **Escape closes what opened last.** Tooltip, then menu, then dialog. One press, one layer. Check: open a menu inside a modal, press Escape twice.
10. **Popovers grow from their trigger.** `transform-origin` at the trigger's edge; scale 0.95 → 1 plus opacity, 150–200ms, ease-out-quart. Flip placement near viewport edges. Check: the popover appears to come out of the button.
11. **Submenus get a diagonal safe area.** A triangle (`clip-path: polygon(0 0, 100% 0, 100% 100%)`) over the gap so the cursor can travel diagonally without the submenu closing. Check: move the cursor from the parent item to the far corner of the submenu.
12. **Sheets arrive as containers with contents inside.** Backdrop: opacity tween 250ms ease-out at t=0. Panel: `y: 100% → 0` on the `smooth` spring at t=0. Contents: fade and rise at t=80ms with a 30ms stagger. The 80ms offset is why native sheets feel like they carry things. Check: contents never lead the panel.
13. **Sheets dismiss on velocity.** Down-flick over 500px/s dismisses regardless of position; otherwise over 50% of height. An upward flick always cancels, even below the threshold. Velocity beats position. Check: a short fast flick closes it; a long slow drag under half snaps back.
14. **Pad sheet contents for the safe area, not the sheet's position.** `padding-bottom: calc(16px + env(safe-area-inset-bottom))` on the content. The sheet itself sits at `bottom: 0`. Check: on a phone with a home indicator the last row is fully visible.
15. **The source view may recede.** Scaling the page to 0.94 with a 14px radius behind a full sheet is a legitimate depth cue. Only for full-height sheets. Check: never combined with a half sheet.
16. **Stacked overlays differ in height by 25% or more.** Two same-height sheets read as one sheet that swapped content. Check: measure both.
17. **Toasts: 5s floor, pause on hover and focus, persist when they carry an action or an error.** A toast holding the only Undo that vanishes on a timer is data loss on a schedule. Check: hover a toast; the timer stops.
18. **One toast visible.** Queue the rest. A stack of toasts is a log, not feedback. Check: fire three; one shows.
19. **Toasts are `role="status"`, never focused.** Bottom-centre on mobile, top-right on desktop, or the project's own corner used consistently. Check: screen reader announces without moving focus.
20. **Contextual outcomes go inline, not in a toast.** A field error belongs on the field; a saved row shows saved on the row. Toasts are for minor, reversible, global outcomes ("Archived. Undo"). Check: could the person be looking somewhere else when this appears? If not, do not toast it.
21. **Confirmation dialogs name the noun.** "Delete this project?" with "Delete project" and "Cancel". Never "Are you sure?" with OK. Check: read only the buttons; you know what happens.
22. **`position: fixed` breaks inside a transformed ancestor.** A parent with `transform`, `filter`, or `will-change: transform` becomes the containing block. Render overlays in a portal at the document root. Check: open the overlay inside an animated card.
23. **Reduced motion: crossfade.** Sheets and modals fade in place, 150–200ms. Keep the backdrop. Check: enable Reduce Motion; nothing slides.

## Cheat sheet

| Overlay | Enter | Exit | Focus on open | Dismiss |
|---|---|---|---|---|
| Modal | 200–300ms ease-out-expo, scale 0.96 → 1 + opacity; backdrop same duration | 0.65×, accelerate | first field, or least-destructive action | Escape, backdrop click, Close |
| Sheet / drawer | `smooth` spring on `y`; backdrop 250ms; contents +80ms, stagger 30ms | `exitOf(smooth)` | first field after animation (~350ms) | drag > 50% or > 500px/s; up-flick cancels; Escape |
| Popover / menu | 150–200ms from trigger origin | 100–150ms | first item (menu) or none (popover) | Escape returns to trigger; outside click |
| Tooltip | 150ms after 200ms delay; instant when warm | instant | never | pointer leave, Escape |
| Toast | 200ms rise + fade | 150ms | never | 5s floor; pause on hover; persist with action or error |

| z-index | Value |
|---|---|
| dropdown | 100 |
| sticky | 150 |
| overlay / modal | 200 |
| popover | 300 |
| toast | 400 |

Never 9999. Prefer the top layer (`<dialog>`, `popover` attribute) where it exists.

## Code

```tsx
// Modal with <dialog>: trap, inert, Escape, top layer for free.
export function Modal({ open, onClose, children }: Props) {
  const ref = useRef<HTMLDialogElement>(null);
  const trigger = useRef<HTMLElement | null>(null);
  useEffect(() => {
    const d = ref.current!;
    if (open && !d.open) {
      trigger.current = document.activeElement as HTMLElement;
      d.showModal();
      document.documentElement.classList.add("scroll-locked");
    }
    if (!open && d.open) {
      d.close();
      document.documentElement.classList.remove("scroll-locked");
      trigger.current?.focus();
    }
  }, [open]);
  return (
    <dialog ref={ref} className="modal" onCancel={(e) => { e.preventDefault(); onClose(); }}
      onClick={(e) => { if (e.target === ref.current) onClose(); }}>
      <div className="modal-panel">{children}</div>
    </dialog>
  );
}
```

```tsx
// If you cannot use <dialog>: aria-modal, inert on the root, focus restored.
export function PortalModal({ open, onClose, children }: Props) {
  const trigger = useRef<HTMLElement | null>(null);
  useEffect(() => {
    if (!open) return;
    trigger.current = document.activeElement as HTMLElement;
    const root = document.getElementById("app-root")!;
    root.inert = true;
    document.documentElement.classList.add("scroll-locked");
    return () => {
      root.inert = false;
      document.documentElement.classList.remove("scroll-locked");
      // Restore after the overlay has gone, or focus lands on a dying node.
      requestAnimationFrame(() => trigger.current?.focus());
    };
  }, [open]);
  if (!open) return null;
  return createPortal(
    <div className="scrim" onClick={onClose}>
      <div role="dialog" aria-modal="true" aria-labelledby="t"
           className="modal-panel" onClick={(e) => e.stopPropagation()}>
        {children}
      </div>
    </div>,
    document.body,
  );
}
```

```css
html.scroll-locked { overflow: hidden; scrollbar-gutter: stable; }

.modal::backdrop { background: rgb(0 0 0 / 0.4); animation: fade 240ms var(--ease-enter); }
.modal[open] .modal-panel { animation: modal-in 240ms var(--ease-enter); }
@keyframes fade { from { opacity: 0 } }
@keyframes modal-in { from { opacity: 0; transform: scale(0.96) } }
.modal-panel { overscroll-behavior: contain; max-height: 85dvh; overflow: auto; }

/* exit: shorter, accelerating */
.modal[data-closing] .modal-panel { animation: modal-out 160ms var(--ease-exit) forwards; }
@keyframes modal-out { to { opacity: 0; transform: scale(0.98) } }

@media (prefers-reduced-motion: reduce) {
  .modal[open] .modal-panel, .modal[data-closing] .modal-panel { animation: fade 180ms ease; }
}
```

```tsx
// Sheet dismissal predicate: velocity beats position.
const DISMISS_VELOCITY = 500; // px/s
const DISMISS_DISTANCE = 0.5; // of sheet height
export function shouldDismiss(offsetY: number, velocityY: number, height: number) {
  if (velocityY < -DISMISS_VELOCITY / 2) return false;  // upward flick always cancels
  if (velocityY > DISMISS_VELOCITY) return true;
  return offsetY > height * DISMISS_DISTANCE;
}
```

```tsx
// Sheet choreography with Motion: panel at t=0, contents at t=0.08, stagger 0.03.
<motion.div className="backdrop" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.25, ease: "easeOut" }} />
<motion.div className="sheet" initial={{ y: "100%" }} animate={{ y: 0 }} exit={{ y: "100%" }} transition={SPRING.smooth}>
  <motion.div initial="hidden" animate="show" variants={{ show: { transition: { delayChildren: 0.08, staggerChildren: 0.03 } } }}>
    {rows.map((r) => <motion.div key={r.id} variants={{ hidden: { opacity: 0, y: 8 }, show: { opacity: 1, y: 0 } }} />)}
  </motion.div>
</motion.div>
```

```css
/* submenu safe area so the cursor can travel diagonally */
.submenu::before {
  content: ""; position: absolute; inset: 0 100% 0 auto; width: 24px;
  clip-path: polygon(0 0, 100% 0, 100% 100%);
}

/* toast */
.toast { position: fixed; inset-block-end: calc(16px + env(safe-area-inset-bottom)); inset-inline: 0; margin-inline: auto; width: max-content; z-index: 400; }
@media (min-width: 768px) { .toast { inset-block-end: auto; inset-block-start: 16px; inset-inline: auto 16px; margin: 0; } }
```

```ts
// Toast timer: 5s floor, pauses on hover/focus, persists if it has an action.
function schedule(toast: Toast) {
  if (toast.action || toast.kind === "error") return;
  let remaining = Math.max(5000, toast.duration ?? 5000);
  let started = Date.now();
  let t = setTimeout(dismiss, remaining);
  toast.el.addEventListener("pointerenter", () => { clearTimeout(t); remaining -= Date.now() - started; });
  toast.el.addEventListener("pointerleave", () => { started = Date.now(); t = setTimeout(dismiss, remaining); });
  toast.el.addEventListener("focusin", () => clearTimeout(t));
}
```

## Checks

- Open each overlay; Tab stays inside; Escape closes; focus returns to the trigger.
- Open a destructive confirm and press Enter; nothing is deleted.
- Scroll to the end of a sheet and keep scrolling; the page behind does not move.
- Open and close a modal; the page has not shifted by a scrollbar width.
- Flick a sheet down fast from the top; it closes. Drag it slowly to 40% and release; it returns.
- Fire three toasts; one shows, two queue. Hover it; the timer stops.
- Open an overlay from inside an animated card; it is not clipped or misplaced.
- Enable Reduce Motion; every overlay fades in place.

## Do not

- Ship `role="dialog"` without `aria-modal="true"`; it tells assistive tech the background is reachable while it is not.
- Leave focus where it was when an overlay closes.

- Animate the backdrop and the panel on different curves or durations.
- Put the only Undo in a toast that expires.
- Focus the destructive action by default.
- Lock scroll with `position: fixed` on `body`.
- Render overlays inside a transformed parent.
- Show a field error in a toast.
- Use `z-index: 9999`.
- Stack two sheets of the same height.

See `references/buttons-and-controls.md` for the buttons inside, `references/springs-and-gestures.md` for drag physics, `references/accessibility.md` for focus and announcement rules.
