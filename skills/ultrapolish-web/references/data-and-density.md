# Tables, search and working with many things

Use this when a screen holds more rows than fit: a table, a long list, a result set, an inbox. Covers dense rows, sorting, search and filtering, multi-select and bulk actions, and keyboard control. Virtualisation budgets are in `references/performance.md`; the states each of these can be in are in `references/states.md`.

A dense tool is not a consumer app with smaller padding. It is a different product with different rules, and most of them are about letting someone act on a hundred things without touching the mouse.

## Rules

1. **A table is for comparing values down a column. Anything else is a list.** If nobody will ever scan one field across many rows, the columns are decoration and cards or rows will read better. Check: name the column a person actually compares; if you cannot, it is not a table.
2. **Numbers right-align and go tabular. Text left-aligns. Nothing centres.** `font-variant-numeric: tabular-nums` plus `text-align: right` is what lets someone see that one figure is an order of magnitude larger without reading it. Align the column header to match its cells. Centred columns make every edge ragged and give the eye nothing to run down. Check: put 9 and 1,000,000 in one column; the digits line up by place value.
3. **Row height is a decision, written down, and it is the tool's not the platform's.** A dense professional table is entitled to sit between the 24px WCAG floor and the 40px pointer default, provided the row height is a documented choice with a comfortable option. A consumer app is not. Offer compact and comfortable if people live in it all day. Check: the row height appears in the design contract with a number.
4. **Zebra striping is a last resort; a hairline or nothing is usually better.** Stripes double the number of background values on screen and fight every other surface. Reach for them only past about seven columns, where the eye genuinely loses the row. A row hover band is more useful and costs nothing at rest. Check: remove the stripes and see whether anyone can still track a row.
5. **The header stays.** `position: sticky; top: 0` on `<thead>` cells, with a background so content does not show through and a `z-index` from the scale. A table you have to scroll back up to read is a table you cannot use. Freeze the identifying first column too when the table scrolls sideways. Check: scroll to row 200; you can still name every column.
6. **Sort is on the header, shows its direction, and says so out loud.** The active column carries an arrow, and the header is a real `<button>` inside the `<th>` with `aria-sort` set to `ascending`, `descending` or `none`. Default to the order that is most useful, not to whatever the database returned. Check: a screen reader announces the sort state without the arrow.
7. **Search debounces at 300ms, and the field never loses what was typed.** Under 300ms every keystroke hits the network; over it, typing feels laggy. Results update in place rather than the whole view being replaced by a spinner, so the previous result set stays readable while the next one loads. Never clear the query because a request failed. Check: type five characters fast; one request goes out and the old rows dim rather than disappear.
8. **A search with no results names the query and offers the way out.** "No results for 'quarterly'" with a Clear filters button. An empty result set that looks identical to an empty table teaches people the tool is broken. Check: filter to zero and confirm you can get back in one action from the empty state itself.
9. **Filters state themselves and clear themselves.** Every active filter is visible as a removable chip, not buried in a panel someone has to open to discover why they are looking at four rows. A count of what is hidden ("12 of 340") is the single most useful thing on a filtered view. Check: apply three filters, navigate away and back; you can tell what is on without opening anything.
10. **Selection has a count, a clear, and a distinction between the page and the set.** When someone selects the header checkbox they have selected the rows they can see. "Select all 340" is a second, explicit action, because deleting 340 things when you meant 25 is not recoverable by an undo toast. The bar showing the count is where the bulk actions live, and it appears in place rather than as a floating layer over the rows it acts on. Check: select all on page one and read the count; it says 25, not 340.
11. **A bulk action names the count and the noun.** "Delete 12 projects", never "Delete". For anything destructive at scale, the confirmation restates the number, and the undo window is longer than a single-item undo because the mistake is bigger. Check: read the button; it tells you what will happen to how many things.
12. **Everything reachable by mouse is reachable by keyboard, and in a dense tool that is the primary input.** Arrow keys move the active row, Space toggles its selection, Shift-click and Shift-arrow extend a range, Enter opens. Use a roving `tabindex` so the table is one tab stop rather than four hundred. Check: select a range of ten rows and delete them without touching the mouse.
13. **A command palette is a shortcut, never the only route.** Cmd-K is for people who already know what they want; every action in it also exists somewhere visible. Show the shortcut next to the action in its menu, which is how people learn it. Check: every palette entry can also be reached by pointing at something.
14. **Shortcuts do not fight the text field they are typed into.** Single-key shortcuts are ignored while focus is in an input, a textarea, or anything `contenteditable`. Escape leaves the field before it closes anything else. Never override Cmd-F, Cmd-P, Cmd-L or Cmd-W unless the product genuinely replaces that function. Check: type "n" into the search box and confirm a New dialog does not open.
15. **Long lists reserve their scroll height.** A virtualised list whose scrollbar changes size as you scroll tells everyone it is virtualised. Give rows a fixed height or measure them once, and keep the scroll position across a re-sort so people do not lose their place. Check: sort a scrolled table; you are still looking at roughly the same region.
16. **The loading state for a table is the table.** Skeleton rows at the real row height and the real column widths, not a spinner in the middle of an empty box, so nothing moves when the data lands. Ten rows is enough; a full page of skeletons reads as noise. Check: throttle the network and confirm nothing shifts on arrival.

## Cheat sheet

| Thing | Value |
|---|---|
| Numeric column | `text-align: right` + `font-variant-numeric: tabular-nums` |
| Row height | Documented. 24px absolute floor, 32–36 dense, 40–48 comfortable |
| Zebra | Only past about 7 columns; prefer a hover band |
| Sticky header | `position: sticky; top: 0` + opaque background + `--z-sticky` |
| Sort semantics | `<button>` in `<th>`, `aria-sort` on the `<th>` |
| Search debounce | 300ms |
| Filtered count | Always shown: "12 of 340" |
| Select-all | Page first, "select all N" as a separate explicit action |
| Bulk label | Verb, count, noun: "Delete 12 projects" |
| Keyboard | Roving tabindex, arrows move, Space selects, Shift extends, Enter opens |
| Shortcut suppression | Ignore single keys while in input, textarea, contenteditable |
| Skeleton rows | ~10, at the real row height and column widths |

## Code

```tsx
// One tab stop for the whole table; arrows move within it.
function useRovingRows(count: number) {
  const [active, setActive] = useState(0);
  const onKeyDown = (e: React.KeyboardEvent) => {
    // Never steal a key from something being typed into.
    const t = e.target as HTMLElement;
    if (t.closest("input, textarea, [contenteditable]")) return;
    if (e.key === "ArrowDown") { e.preventDefault(); setActive((i) => Math.min(i + 1, count - 1)); }
    if (e.key === "ArrowUp")   { e.preventDefault(); setActive((i) => Math.max(i - 1, 0)); }
  };
  return { active, onKeyDown };
}
```

```css
/* Numbers compare down the column only if they are aligned by place value. */
.cell-numeric { text-align: right; font-variant-numeric: tabular-nums; }
th { text-align: inherit; }

thead th {
  position: sticky;
  top: 0;
  z-index: var(--z-sticky);
  background: var(--surface); /* opaque, or rows show through */
}
```

## Checks

- Put 9 and 1,000,000 in one column and confirm the digits align by place value.
- Scroll to row 200: every column is still named and the identifying column is still visible.
- Type five characters into search quickly: one request, and the old rows stay readable.
- Filter to zero results: the empty state names the query and clears the filters.
- Select the header checkbox and read the count: it is the page, not the set.
- Select ten rows and act on them without touching the mouse.
- Type a single-letter shortcut into the search field: nothing else happens.
- Throttle the network and load the table: nothing shifts when the rows arrive.

## Do not

- Centre a column.
- Use a proportional font for figures that are meant to be compared.
- Put a spinner where the table will be.
- Let the header checkbox silently mean "all 340".
- Label a bulk action with a bare verb.
- Make the command palette the only way to reach something.
- Fire a single-key shortcut while someone is typing.
- Hide active filters behind a panel.
