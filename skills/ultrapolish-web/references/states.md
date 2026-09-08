# States

Use this when anything on screen can be empty, loading, failing, succeeding, offline, or overflowing. Which is everything that talks to data.
Every state gets the same care as the happy path; the empty state is the first thing every new user sees.

## Rules

1. **Follow the loading ladder.** 0–300ms: nothing, or the optimistic result. 300ms–2s: a skeleton at the exact final size, or inline progress where the result will land. 2s+: explicit progress with a label and a cancel. 10s+: let the person leave and notify them. Check: throttle the network to Slow 3G and watch each threshold.
2. **The spinner travels.** Progress appears where the result will appear, never on the control that was clicked. A sent comment shows pending in the list; an uploaded file shows progress on its row. Check: after a click, where does the eye go? That is where the indicator belongs.
3. **No spinner before 300ms.** A flash of spinner for a 120ms request reads as slower than no indicator at all. Check: set a 300ms delay before any spinner mounts.
4. **Skeletons match the structure.** Same number of lines, same widths, same positions as the content that will replace them. Three bars for five lines is a broken promise. Shimmer 1.2–1.5s, subtle, static under `prefers-reduced-motion`. Check: overlay the skeleton on the loaded state; edges align.
5. **Optimistic first, ghost while pending.** Apply the change immediately at 60% opacity, confirm to 100% on success, revert with an inline reason on failure. Not a spinner; a ghost. Check: send a message with the network off; it appears, then reverts with a reason next to it.
6. **Empty states have three parts.** The name of what is missing, one line of why, one action. "No projects yet. Create one to start tracking time. [New project]". Never "No items". Check: every empty state has exactly one button.
7. **Search and filter empties name the query and offer an exit.** "No results for 'quarterly'. Clear filters." Check: filter to zero results; the filter can be cleared from the empty state.
8. **Never park crucial persistent information in an empty state.** It disappears the moment there is one item. Settings, limits, and instructions live somewhere permanent. Check: add one item; did any important text vanish?
9. **First-run is not the empty state.** First-run invites and can show an example; empty after deletion is quieter and offers the same action without the tour. Check: delete everything; you do not see the welcome again.
10. **Offline is a state, not an error.** A quiet banner, cached content still readable, writes queued with a visible pending mark. Check: go offline; can you still read what you loaded?
11. **Design for two and for two hundred.** Test every list with 0, 1, 2, and 200 rows; every title at 60 characters; every description at 4 lines. Check: nothing overlaps, truncates without a tooltip, or breaks the grid.
12. **Denied, missing, and broken pages offer a way forward.** 403 says what you need and who to ask. 404 offers search and the nearest parent. 500 keeps the navigation and offers retry. Check: each page has at least one link that is not "Home".
13. **Errors sit next to the thing that failed.** Field errors on the label row; row errors on the row; page-level errors at the top with focus moved to them. Never a toast for a contextual error. Check: could the person be looking elsewhere? If not, inline.
14. **Feedback follows the taxonomy.** Minor and reversible: a toast with Undo. Contextual: inline at the thing that changed. The app acted for you: a receipt card that stays. Destructive: confirm with the noun, then resolve in place. Check: classify each feedback moment; the mechanism follows.
15. **Undo actually undoes.** The row comes back, the server is told, the state matches. Hiding the toast is not undo. Check: delete, undo, reload.
16. **Success is acknowledged once, where the result appears.** A saved row shows "Saved" on the row for 1.5s, or the new item appears in its place. Not a toast plus a banner plus a checkmark. Check: count the acknowledgements; one.
17. **Announce state changes with the ladder.** Move focus for page-level outcomes, `aria-describedby` for field outcomes, `role="status"` for polite updates, `role="alert"` only for urgent ones. Keep a stable empty live region in the DOM for repeated polite updates. Check: screen reader hears each transition once.
18. **Suspense boundaries wrap components, not pages.** A page-level boundary turns one slow widget into a blank page. Wrap the widget. Check: slow one query; the rest of the page renders.
19. **Stream without shifting.** Reserve the box before the data arrives (`min-height`, aspect ratio, skeleton at final size). Content that streams in must land in space that already exists. Check: record the load; CLS is zero.
20. **Retry is visible and backed off.** Automatic retry with exponential backoff behind the scenes, plus a Retry control the person can press. Never an infinite spinner. Check: fail three times; the person sees a button.

## Cheat sheet

| Elapsed | Show |
|---|---|
| 0–300ms | nothing, or the optimistic result |
| 300ms–2s | skeleton at final size, or inline progress where the result lands |
| 2s+ | explicit progress with label and cancel |
| 10s+ | let them leave; notify on completion |

| Outcome | Mechanism |
|---|---|
| Minor, reversible, global | toast with Undo, 5s floor |
| Contextual | inline at the thing |
| App acted on your behalf | receipt card that stays |
| Destructive | confirm naming the noun, resolve in place |
| Field invalid | error on the label row |
| Page-level failure | summary at top, focus moved |

| State | Must exist for |
|---|---|
| Empty | every list, table, search, filter |
| Loading | every fetch |
| Error | every fetch, every submit |
| Success | every submit |
| Offline | every app with writes |
| Overflow | every list (200 rows), every title (60 chars) |

## Code

```tsx
// Spinner only after 300ms.
export function DelayedSpinner({ delay = 300 }: { delay?: number }) {
  const [show, setShow] = useState(false);
  useEffect(() => { const t = setTimeout(() => setShow(true), delay); return () => clearTimeout(t); }, [delay]);
  return show ? <Spinner /> : null;
}
```

```css
/* Skeleton: final size, subtle shimmer, static under reduced motion. */
.skeleton {
  background: var(--surface-muted);
  border-radius: var(--radius-sm);
  position: relative; overflow: hidden;
}
.skeleton::after {
  content: ""; position: absolute; inset: 0;
  background: linear-gradient(90deg, transparent, rgb(255 255 255 / 0.25), transparent);
  transform: translateX(-100%);
  animation: shimmer 1.4s linear infinite;
}
@keyframes shimmer { to { transform: translateX(100%) } }
@media (prefers-reduced-motion: reduce) { .skeleton::after { animation: none; } }
```

```tsx
// Optimistic with ghost and revert (React 19 useOptimistic; adapt if older).
const [optimistic, add] = useOptimistic(items, (state, next: Item) => [...state, { ...next, pending: true }]);
async function send(item: Item) {
  add(item);
  try { await api.create(item); }
  catch (e) { setError(item.id, "Could not send. Tap to retry."); }
}
// row
<li style={{ opacity: item.pending ? 0.6 : 1 }} aria-busy={item.pending || undefined}>
  {item.text}
  {item.error && <button className="inline-error" onClick={() => send(item)}>{item.error}</button>}
</li>
```

```tsx
// Empty state: name, why, one action. Search variant names the query.
function Empty({ query, onClear, onCreate }: Props) {
  if (query) return (
    <div className="empty" role="status">
      <p>No results for "{query}".</p>
      <Button onClick={onClear}>Clear filters</Button>
    </div>
  );
  return (
    <div className="empty">
      <p>No projects yet. Create one to start tracking time.</p>
      <Button variant="primary" onClick={onCreate}>New project</Button>
    </div>
  );
}
```

```tsx
// Undo that undoes: keep the item, tell the server, restore on undo.
async function archive(item: Item) {
  setItems((s) => s.filter((i) => i.id !== item.id));
  const { undo } = await api.archive(item.id); // server returns an undo token
  toast({ text: "Archived", action: { label: "Undo", onClick: async () => { await api.unarchive(undo); setItems((s) => [...s, item]); } } });
}
```

```tsx
// Stable live region for repeated polite updates.
<div role="status" aria-live="polite" className="sr-only" id="status">{statusText}</div>
```

## Checks

- Throttle to Slow 3G; watch the 300ms, 2s, and 10s thresholds behave.
- Overlay each skeleton on its loaded content; edges align.
- Go offline; read cached content; make a change; see it queued.
- Every list at 0, 1, 2, 200 items; every title at 60 characters.
- Delete, Undo, reload; the item is there.
- Filter to zero; the empty state clears the filter.
- Screen reader through a submit: one announcement per outcome.
- Record a page load; CLS is zero.

## Do not

- Show a spinner on the clicked button, or before 300ms.
- Ship a skeleton that does not match the content.
- Write "No items" or "Nothing here".
- Put instructions people will need later in an empty state.
- Toast a field error.
- Hide the toast and call it undo.
- Wrap the page in one Suspense boundary.
- Retry silently forever.

See `references/overlays.md` for toasts, `references/forms-and-inputs.md` for field errors, `references/accessibility.md` for live regions.
