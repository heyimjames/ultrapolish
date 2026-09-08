# Sheets and navigation

Use this when presenting anything: sheets, detents, popovers, full-screen covers, hero transitions, navigation pushes, share sheets, and confirmation dialogs.
Presentation is where spatial continuity is won or lost. A sheet that arrives from nowhere and a title that leaves and comes back both break the sense of one place that changed.

## Rules

1. **Pick the detent by job, not by taste.** A quick confirm at `.height(220)`, a picker at `.medium`, a browse at `[.medium, .large]`, a form at `.large`. The user should be able to predict how tall the sheet will be from what they tapped. Check: every `.presentationDetents` in the app maps to one row of the cheat sheet.
2. **Name the corner radius once.** `.presentationCornerRadius` defaults to 10pt, which rarely matches a project's card radius. Set it to the project's large radius as a single constant and use it everywhere. Check: grep `presentationCornerRadius`; every call passes the same constant.
3. **Stacked sheets differ in height by at least 25%.** Two identical-height sheets read as one layer that swapped its contents; the user loses track of depth. Check: for any sheet presented from a sheet, compare detents.
4. **Trays adopt the environment.** A sheet presented from a themed surface inherits `.tint`, `.preferredColorScheme`, and `.presentationBackground`. A light sheet over a dark chat is disorienting. Check: present every sheet from a dark-mode and a tinted context.
5. **Contents arrive after the container.** The sheet springs in at t=0; its children fade and rise starting 60–80ms later, staggered 30ms. That offset is why system sheets feel like containers arriving with things inside. Check: watch at 10% speed; the first child appears after the sheet has mostly landed.
6. **Show the drag indicator unless there is a Close button.** Two dismissal affordances compete; zero leave the user stuck. Check: every sheet has exactly one obvious way out plus the swipe.
7. **Let the background stay interactive when the sheet is a companion.** Map with a results sheet, chart with an inspector, player with a queue: `.presentationBackgroundInteraction(.enabled(upThrough: .medium))`. Check: a medium sheet over a map still pans the map.
8. **Directional continuity.** Forward enters from the trailing edge and back returns to it. Deeper levels grow in from scale 0.94; shallower levels shrink in from 1.04. The eye learns the hierarchy from the direction. Check: push and pop three levels; the direction never flips.
9. **Titles live in the parent.** If a title, toolbar, or pill exists on both sides of a push, render it in a container that survives the push. Animating it out and back in is the most common continuity break. Check: on push, nothing that persists flickers.
10. **Hero transitions animate the radius with the size.** A thumbnail at radius 18 becomes a full-screen view at radius 0 by way of the device bezel radius (~38) during drag-dismiss. A radius that jumps reads as a cut. Check: scrub a hero transition at 10% speed; corners never pop.
11. **Destructive confirmations name the noun.** `confirmationDialog` with a button titled "Delete project" and `role: .destructive`, never "Are you sure?" with Yes/No. Pair with `.sensoryFeedback(.warning)` on present. Check: grep `confirmationDialog`; every destructive button names what it destroys.
12. **Share with `ShareLink` and `Transferable`.** The system sheet inherits the correct appearance, supports every target, and needs no `UIViewControllerRepresentable`. Check: grep `UIActivityViewController`; each is justified by a target `ShareLink` cannot reach.
13. **On iPad, quick choices are popovers, not sheets.** A full-width sheet for a three-item picker on a 13-inch screen is a phone layout leaking. Check: run the app on iPad; every small picker anchors to its trigger.

## Cheat sheet

| Job | Detents | Indicator | Extras |
|---|---|---|---|
| Quick confirm, 1–2 actions | `.height(220)` or `.fraction(0.25)` | visible | |
| Picker, short list | `.medium` | visible | iPad: `.popover` |
| Filter, browse | `[.medium, .large]` | visible | `backgroundInteraction(.enabled(upThrough: .medium))` when the parent is a map/chart/player |
| Form, compose | `.large` | hidden if Close exists | `.interactiveDismissDisabled(isDirty)` |
| Full takeover | `.large` | hidden | `.presentationDragIndicator(.hidden)` |

| Motion | Value |
|---|---|
| Sheet present | `.spring(duration: 0.42, bounce: 0.18)` |
| Sheet dismiss | `.spring(duration: 0.32, bounce: 0)` |
| Contents offset | +60–80ms, stagger 30ms |
| Push | `.spring(duration: 0.38, bounce: 0.05)`; deeper from 0.94, shallower from 1.04 |
| Hero | `.spring(duration: 0.42, bounce: 0.16)`; radius 18 → 38 → 0 on drag-dismiss |
| Drag-dismiss commit | 120pt or 600pt/s |
| Corner radius | project's large radius, one constant |
| Stacked sheets | ≥ 25% height difference |

## Code

### The canonical sheet modifier stack

```swift
enum Sheet {
    static let radius: CGFloat = 28   // the project's large radius; set once
}

.sheet(isPresented: $showFilters) {
    FilterView()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Sheet.radius)
        .presentationBackground(.background)              // adopt the environment
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
}
```

### Contents arriving after the container

```swift
struct SheetBody: View {
    @State private var landed = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                row
                    .opacity(landed ? 1 : 0)
                    .offset(y: landed ? 0 : 6)
                    .animation(.smooth(duration: 0.22).delay(0.07 + Double(index) * 0.03), value: landed)
            }
        }
        .onAppear { landed = true }
    }
}
```

### Titles in the parent (bad, then good)

```swift
// Bad: the title is inside each destination, so it leaves and returns on every push.
NavigationStack {
    ListView().navigationTitle("Library")
}
.navigationDestination(for: Item.self) { item in
    DetailView(item: item).navigationTitle(item.name)
}

// Good: persistent chrome sits in a parent that survives; only content transitions.
struct Shell: View {
    @State private var path: [Item] = []
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: path.last?.name ?? "Library")   // one view, crossfades its text
                .animation(.smooth(duration: 0.22), value: path.count)
            NavigationStack(path: $path) {
                ListView()
                    .navigationDestination(for: Item.self) { DetailView(item: $0) }
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
```

### Hero with animated radius

```swift
struct Hero: View {
    @Namespace private var ns
    @State private var open = false
    @State private var dragProgress: CGFloat = 0     // 0 at rest, 1 at commit
    let item: Item

    var body: some View {
        ZStack {
            if !open {
                Thumb(item: item)
                    .clipShape(.rect(cornerRadius: 18, style: .continuous))
                    .matchedGeometryEffect(id: item.id, in: ns)
                    .onTapGesture { withAnimation(.spring(duration: 0.42, bounce: 0.16)) { open = true } }
            } else {
                Full(item: item)
                    .clipShape(.rect(cornerRadius: 38 * dragProgress, style: .continuous))   // bezel radius while dragging
                    .matchedGeometryEffect(id: item.id, in: ns)
                    .ignoresSafeArea()
            }
        }
    }
}
```

At rest the full view has radius 0. As the user drags to dismiss, `dragProgress` rises and the corners round toward the bezel; on commit the spring carries it back to 18 at the thumbnail. The radius is a function of the same value that moves the view, which keeps it on one curve.

### Directional push with depth scaling

```swift
extension AnyTransition {
    /// Deeper grows in from 0.94; shallower shrinks in from 1.04.
    static let deeper = AnyTransition.asymmetric(
        insertion: .scale(scale: 0.94).combined(with: .opacity),
        removal: .opacity)
    static let shallower = AnyTransition.asymmetric(
        insertion: .scale(scale: 1.04).combined(with: .opacity),
        removal: .opacity)
}

.transition(isGoingDeeper ? .deeper : .shallower)
.animation(.spring(duration: 0.38, bounce: 0.05), value: level)
```

### Destructive confirmation and share

```swift
.confirmationDialog("Delete \"\(project.name)\"?", isPresented: $confirmDelete, titleVisibility: .visible) {
    Button("Delete project", role: .destructive) { delete(project) }
    Button("Cancel", role: .cancel) {}
} message: {
    Text("This removes the project and its 12 files. You can restore it from Recently Deleted for 30 days.")
}
.sensoryFeedback(.warning, trigger: confirmDelete) { _, new in new }

ShareLink(item: project, preview: SharePreview(project.name, image: project.cover)) {
    Label("Share", systemImage: "square.and.arrow.up")
}
```

`Project` conforms to `Transferable` with a `ProxyRepresentation` for text and a `FileRepresentation` for the export; the share sheet picks the right one per target.

### iPad popover for small choices

```swift
.popover(isPresented: $showSort, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
    SortPicker()
        .presentationCompactAdaptation(.sheet)   // phones still get a sheet
}
```

## Checks

- Every sheet maps to one row of the detent table and uses the shared radius constant.
- Present each sheet from dark mode and from a tinted screen; it matches.
- Stack two sheets; heights differ by ≥ 25%.
- Watch a sheet open at 10% speed; the container lands before its children appear.
- Push three levels deep and pop; direction and scale never flip; persistent chrome never flickers.
- Scrub a hero transition; the corner radius is continuous.
- Every destructive dialog names the noun and uses `role: .destructive`.
- On iPad, small pickers are popovers anchored to their trigger.

## Do not

- Leave `.presentationCornerRadius` at its 10pt default when the project's cards are 16–28.
- Present a full-height sheet for two buttons.
- Present a sheet from a sheet at the same height.
- Put the title inside each destination and animate it on every push.
- Use `.easeIn` on a sheet's arrival.
- Build `UIActivityViewController` wrappers where `ShareLink` works.
- Ask "Are you sure?".
