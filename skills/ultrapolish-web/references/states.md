# States

Use this when anything on screen can be empty, loading, failing, succeeding, offline, or overflowing. Which is everything that talks to data.
Every state gets the same care as the happy path; the empty state is the first thing every new user sees.

## Rules

1. **Follow the loading ladder.** 0–300ms: nothing, or the optimistic result. 300ms–2s: a skeleton at the exact final size, or inline progress where the result will land. 2s+: explicit progress with a label and a cancel. 10s+: let the person leave and notify them. Check: throttle the network to Slow 3G and watch each threshold.
2. **The spinner travels.** Progress appears where the result will appear, not only on the control that was clicked. A sent comment shows pending in the list; an uploaded file shows progress on its row. The control may carry progress as well once the result has a home of its own, which is why a button that doubles as a progress bar is right when the work also appears where it will land and wrong when that is the only place it appears. Check: after a click, where does the eye go? That is where the indicator belongs, and it is not allowed to be nowhere.
3. **No spinner before 300ms.** A flash of spinner for a 120ms request reads as slower than no indicator at all. Check: set a 300ms delay before any spinner mounts.
4. **Skeletons match the structure.** Same number of lines, same widths, same positions as the content that will replace them. Three bars for five lines is a broken promise. Shimmer 1.2–1.5s, subtle, static under `prefers-reduced-motion`. Check: overlay the skeleton on the loaded state; edges align.
5. **Optimistic first, ghost while pending.** Apply the change immediately at 60% opacity, confirm to 100% on success, revert with an inline reason on failure. Not a spinner; a ghost. Check: send a message with the network off; it appears, then reverts with a reason next to it.
6. **The empty state shows the destination, not just the door.** The name of what is missing, one line of what goes here, a ghosted non-interactive preview of the filled state, and the one action that gets there. "No projects yet. Create one to start tracking time. [New project]", above a dimmed sketch of a project row. Never "No items". Why: this is the most-seen screen for a new user and the last place to be terse; a person who cannot picture the filled state cannot want it. Check: cover the button; can someone still tell what this screen becomes?
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
17. **Announce state changes with the ladder.** Pick the lowest rung that works and use each change once; the ladder itself lives in `references/accessibility.md`. Check: screen reader hears each transition once.
18. **Suspense boundaries wrap components, not pages.** A page-level boundary turns one slow widget into a blank page. Wrap the widget. Check: slow one query; the rest of the page renders.
19. **Stream without shifting.** Reserve the box before the data arrives (`min-height`, aspect ratio, skeleton at final size). Content that streams in must land in space that already exists. Check: record the load; CLS is zero.
20. **Retry is visible and backed off.** Automatic retry with exponential backoff behind the scenes, plus a Retry control the person can press. Never an infinite spinner. Check: fail three times; the person sees a button.
21. **A long local job needs a surface of its own.** The ladder above is written for a network request that returns JSON. A forty-second export, encode, or render on the person's own CPU is a different shape, and five things follow from it. Progress lives in a surface that survives the whole job and shows the artefact being worked on, not only as a sweep on the control that started it. The cancel is reachable throughout and actually stops the work, rather than hiding the progress. When the job fails, the progress surface does not unmount in the same frame the error appears, or the failure lands somewhere the eye is not; hold the surface and show the reason inside it. Completion while the person has tabbed away is announced through `role="status"`, not a toast that expires before they look. And when the result is a file, the download or the save is the completion; progress reaching 100% is not. Check: start the job, switch tabs, come back. Then fail it on purpose and watch where your eye goes.
22. **One channel per severity, and grep for a second.** The taxonomy above assumes one implementation of each mechanism. The common failure is two: a toast system, plus an older status string in a toolbar or a status bar that predates it and still has call sites, usually on the paths that were written first and matter most. The symptom is a message surface that nothing new is wired to and nothing old was migrated off. Check: grep for every function that displays a message; if there are two, list the call sites of the older one and route them through the newer.

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

| Long local job | Where it belongs |
|---|---|
| Progress | a surface that outlives the job, showing the artefact |
| Cancel | reachable throughout; stops the work, not just the display |
| Failure | inside the progress surface, which stays put |
| Completion, tabbed away | `role="status"`, not an expiring toast |
| Completion, result is a file | the save or download, not 100% |

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

```tsx
// A long local job: the surface outlives the job, and failure lands in it.
type Job =
  | { phase: "idle" }
  | { phase: "running"; done: number; total: number }
  | { phase: "failed"; reason: string }
  | { phase: "saved"; name: string };

// One surface for all three non-idle phases. It does not unmount on failure,
// so the reason appears where the person was already looking.
{job.phase !== "idle" && (
  <section className="job" aria-labelledby="job-title">
    <h2 id="job-title">Exporting</h2>
    <Preview frame={job.phase === "running" ? job.done : undefined} />
    {job.phase === "running" && (
      <>
        <progress value={job.done} max={job.total} />
        <button onClick={cancel}>Cancel</button>
      </>
    )}
    {job.phase === "failed" && <p className="error">{job.reason}</p>}
    <p role="status" className="sr-only">
      {job.phase === "saved" ? `Export saved as ${job.name}` : ""}
    </p>
  </section>
)}
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
- Start a long job, switch tabs, return: you are told it finished. Fail it on purpose: the reason is in the surface you were watching.
- Grep every message-display function; if there are two, the older one has no call sites left.

## Do not

- Show a spinner on the clicked button, or before 300ms.
- Ship a skeleton that does not match the content.
- Write "No items" or "Nothing here".
- Put instructions people will need later in an empty state.
- Toast a field error.
- Hide the toast and call it undo.
- Wrap the page in one Suspense boundary.
- Retry silently forever.
- Unmount the progress surface in the same frame the error appears.
- Leave a superseded message channel wired to the paths that matter most.

See `references/overlays.md` for toasts, `references/forms-and-inputs.md` for field errors, `references/accessibility.md` for live regions.
