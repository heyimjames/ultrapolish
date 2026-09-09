# Lists, search and working with many things

Use this when a screen holds more rows than fit: a list, a table on iPad, a result set, an inbox. Covers dense rows, search, filtering, selection and bulk actions, swipe actions and context menus, and hardware keyboard use. The states each of these can be in are in `references/states.md`; the gestures behind them in `references/gestures-and-physics.md`.

Most of this is about letting someone act on a hundred things without a hundred taps, and about the row still being usable at AX5.

## Rules

1. **`List` for reading down, `Table` for comparing across, and only on a regular width.** `Table` needs a pointer or a wide layout to earn its columns; on a compact width it collapses to a list anyway, so design that list deliberately rather than accepting the fallback. Check: run the same screen on an iPhone and an iPad and confirm both were designed.
2. **A row has one primary line and at most two supporting ones.** Everything else belongs on the detail screen. A row that wraps to five lines at AX5 was carrying a detail view's worth of content. Check: read every row at `.accessibility5` and count the lines.
3. **Numbers that are compared down a column are monospaced and trailing-aligned.** `.monospacedDigit()` with `.frame(alignment: .trailing)`. Otherwise a proportional font puts a 9 and a 1,000,000 at unrelated widths and the column stops meaning anything. Check: the digits line up by place value.
4. **Row height is a decision, and the 44pt floor is about the tap target, not the visual.** A dense row may be shorter than 44pt provided the tappable area is expanded to meet it with `.contentShape` and padding. What is never acceptable is a 30pt row whose tap target is also 30pt. Check: the row height appears in the design contract, and a tap near the row's edge still registers.
5. **`.searchable` belongs on the navigation content, not on a subview.** Placement decides whether it hides on scroll, and `.searchable(text:placement:)` with `.navigationBarDrawer(displayMode: .always)` is right when search is the point of the screen rather than an occasional need. Add `.searchScopes` when the same query means different things. Check: the field is where a person reaches for it before they have thought about it.
6. **Results update in place; the previous set stays readable while the next loads.** Replacing the list with a spinner on every keystroke destroys the thing someone was reading. Debounce the request, keep the old rows, and dim rather than remove them. Never clear the query because a request failed. Check: type quickly and confirm the list never goes blank.
7. **A search with no results names the query and offers the way out.** "No results for 'quarterly'" with a control that clears the filters. This is a different state from the list simply being empty, and it needs different words. Check: search for nonsense and confirm you can get back without leaving the screen.
8. **Filters state themselves.** Active filters are visible and removable from the list itself, with a count of what is hidden, not buried behind a sheet someone must open to find out why they are looking at four rows. Check: apply filters, leave the screen and return; you can tell what is on without opening anything.
9. **Selection has a count, and the page is not the set.** In edit mode the title becomes the count, "3 selected", and the toolbar holds the actions. A "Select All" that means every match rather than every loaded row is a separate, explicit choice, because acting on 340 things when you meant 25 is not something a toast can undo. Check: enter edit mode, select all, read the count.
10. **A bulk action names the count and the noun.** "Delete 12 Projects" in the confirmation, never a bare "Delete". Destructive bulk actions confirm in a `.confirmationDialog` with the number in the title, and they get a longer undo window than a single-item action because the mistake is bigger. Check: read the confirmation; it tells you what happens to how many things.
11. **Swipe actions are for the one or two things done constantly, and the destructive one is not first.** `.swipeActions(edge: .trailing)` with the most common action nearest the thumb. Set `allowsFullSwipe: false` unless a full swipe is genuinely undoable, because a full swipe is easy to trigger by accident while scrolling. Everything rarer belongs in the context menu. Check: try to scroll a list quickly with one thumb without triggering anything.
12. **A context menu is a menu, not a dumping ground.** Up to about seven items, grouped, destructive last and marked `.destructive`, with a preview when the row has something worth previewing. Every action in it also exists somewhere reachable without a long press, because a long press is undiscoverable. Check: name the route to each context-menu action that does not involve a long press.
13. **Pull to refresh only where content genuinely arrives from elsewhere.** `.refreshable` on a list of local data that cannot change behind your back is a gesture that teaches people the app is confused. Check: ask what changed on the server since the screen opened; if the answer is nothing, remove it.
14. **On iPad, the hardware keyboard is a real input.** Arrow keys move the selection, Return opens, Space previews, Command-Delete deletes, and `.keyboardShortcut` puts the key next to the action in the menu so people learn it. Escape leaves search before it leaves the screen. Check: navigate and act on a list from a Magic Keyboard without touching the screen.
15. **The loading state for a list is the list.** Skeleton rows at the real height, about ten of them, not a spinner in the middle of an empty screen, so nothing moves when the data lands. Check: throttle the network and confirm the layout does not shift on arrival.
16. **Lists at scale stay lazy and stable.** `LazyVStack` or `List` with stable `id`s so rows are not rebuilt on every update, and a scroll position preserved with `.scrollPosition` across a re-sort so nobody loses their place. Check: sort a scrolled list; you are still looking at roughly the same region.

## Cheat sheet

| Thing | Value |
|---|---|
| Table vs List | `Table` only at a regular width; design the compact list deliberately |
| Row content | One primary line, at most two supporting |
| Numeric column | `.monospacedDigit()` + trailing alignment |
| Row height | Documented. Tap target still 44pt via `.contentShape` and padding |
| Search placement | `.navigationBarDrawer(displayMode: .always)` when search is the point |
| Results while typing | Keep and dim the old rows; never blank the list |
| Filtered count | Always shown, and clearable from the list |
| Selection title | The count: "3 selected" |
| Bulk label | Verb, count, noun: "Delete 12 Projects" |
| Swipe | Most common action nearest the thumb; `allowsFullSwipe: false` unless undoable |
| Context menu | ~7 items, grouped, destructive last and marked |
| Skeleton rows | ~10, at the real row height |

## Code

```swift
List(selection: $selected) {
    ForEach(rows) { row in
        RowView(row)
            // Dense rows keep a real target even when the visual is shorter.
            .contentShape(Rectangle())
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) { archive(row) } label: {
                    Label("Archive", systemImage: "archivebox")
                }
            }
            .contextMenu {
                Button("Rename") { rename(row) }
                Divider()
                Button("Delete", role: .destructive) { confirmDelete([row]) }
            }
    }
}
.searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
// The title is the count, so the toolbar does not have to say it twice.
.navigationTitle(editMode?.wrappedValue == .active && !selected.isEmpty
                 ? "\(selected.count) selected" : "Projects")
.confirmationDialog(
    // The number is in the title, where it cannot be missed.
    "Delete \(selected.count) \(selected.count == 1 ? "project" : "projects")?",
    isPresented: $confirming, titleVisibility: .visible
) {
    Button("Delete", role: .destructive) { delete(selected) }
    Button("Cancel", role: .cancel) {}
}
```

## Checks

- Read every row at `.accessibility5` and count the lines.
- Put 9 and 1,000,000 in one column; the digits align by place value.
- Type a query quickly; the list never goes blank and one request goes out.
- Search for nonsense; the empty state names the query and offers the way back.
- Enter edit mode and select all; the count says what was actually selected.
- Scroll the list fast with one thumb; nothing triggers by accident.
- On an iPad with a keyboard, move the selection and act on it without touching the screen.
- Throttle the network; nothing shifts when the rows arrive.

## Do not

- Ship a `Table` without designing what a compact width shows instead.
- Set a proportional font on figures that are compared down a column.
- Let a dense row's tap target shrink with its height.
- Blank the list on every keystroke.
- Put a destructive action under a full swipe that cannot be undone.
- Hide an action only behind a long press.
- Add `.refreshable` to data that cannot change remotely.
- Label a bulk action with a bare verb.
