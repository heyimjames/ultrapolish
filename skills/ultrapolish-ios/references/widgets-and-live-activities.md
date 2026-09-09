# Widgets, Live Activities and Dynamic Island

Use this when the app ships a Home Screen, Lock Screen, or StandBy widget, a Control Center control, a Live Activity, or a Dynamic Island presentation. These surfaces are seen a hundred times a day for half a second each. That half-second is where most of an app's perceived quality lives.

## Rules

1. **Content margins, not safe areas, and 24pt is the target rather than the 16 the system hands you.** WidgetKit gives every widget `widgetContentMargins`, about 16pt by default and 11pt when the system wants a tight grouping, and `ignoresSafeArea()` has no effect inside a widget: the system owns the container, you own the content. Treat 16 as the floor. A widget is read at arm's length among other widgets, so it wants more air than a screen does, and 24pt of total inset is what separates one that looks considered from one that looks like a view someone shrank. Get there by adding 8pt inside the system margins, or by taking `.contentMarginsDisabled()` and owning all 24. Drop back to 16 only when the content genuinely needs the room, and to 11 in a tight accessory. Check: measure from the container edge to the first glyph; it is 24 unless there is a written reason.
2. **Never type a literal corner radius inside a widget.** Use `ContainerRelativeShape()` for every nested card so corners stay concentric with the system container on every device. Why: the container radius differs by device and by family; a literal 22 clips on one and floats on another. Check: `grep -rn "cornerRadius\|RoundedRectangle" Widgets/` returns nothing but `ContainerRelativeShape`.
3. **`.containerBackground(for: .widget)` is required on iOS 17+.** It lets the system remove your background on the Lock Screen, in StandBy, and on the iPad Lock Screen. Why: without it the widget renders with a blank background in those placements or is rejected from them. Check: every widget view body ends with `.containerBackground(for: .widget) { ... }`.
4. **Only set `.containerBackgroundRemovable(false)` when the widget is its background.** A photo widget, a full-bleed gradient that carries the meaning. Cost: the widget is ineligible for iPad Lock Screen and StandBy. Why: you are trading reach for fidelity; know that you are doing it. Check: any `containerBackgroundRemovable(false)` has a comment stating the trade.
5. **Three render modes are three designs.** Read `widgetRenderingMode` and design for `.fullColor`, `.accented`, and `.vibrant` separately. In `.accented` the system treats your views as template images: it ignores hue and renders from the alpha channel. In `.vibrant` hierarchy comes from opaque greys (`Color(white: 0.6)`), never from white at reduced opacity, because opacity controls blur strength there and reads as mush. Why: one design tested only in full colour looks broken on two out of three placements. Check: preview all three modes; check `.vibrant` in greyscale.
6. **`widgetAccentable(false)` on a child does not undo a parent's `true`.** Structure accent groups deliberately. Check: accent groups are siblings, not nested.
7. **Typography floor is 11pt; no Ultralight, Thin, or Light weights.** Why: the widget is read at arm's length, often through a blur. Check: `grep -rn "\.light\|\.thin\|\.ultraLight" Widgets/` is empty; no `.system(size:` under 11.
8. **`ViewThatFits` for every variable-length string.** Provide the ideal, a tighter variant, and a last resort. Test at AX5 and in German. Why: a truncated hero label is the most common shipped widget bug. Check: every `Text` bound to data sits inside a `ViewThatFits`.
9. **Every changing number is `.monospacedDigit()`** and transitions with `.contentTransition(.numericText())`. Why: 99 becoming 100 otherwise shifts the whole layout. Check: grep for numbers without `monospacedDigit`.
10. **What a widget can animate:** `Text(timerInterval:)` and `Text(_:style:)` tick on their own with zero timeline entries; `.contentTransition(.numericText())`, `.contentTransition(.symbolEffect(.replace))`, `.contentTransition(.opacity)`, `.interpolate`; a background wash that shifts per entry; `.invalidatableContent()` while an intent runs. **What it cannot:** continuous animation, `TimelineView(.animation)`, gestures, press-scale, confetti, particles, breathing icons. Why: the widget is a snapshot; pretending otherwise produces a frozen frame of a half-finished animation. Check: no `withAnimation`, `repeatForever`, or `TimelineView(.animation)` in the extension.
11. **Timeline entries at least 5 minutes apart; long timelines.** Budget is roughly 40–70 reloads per day per device. Recompute any ambient wash per entry at a 30–60 minute cadence. Why: exceed the budget and the system throttles you into showing stale data. Check: `TimelineProvider` produces entries spaced ≥ 5 minutes and a policy of `.after` or `.atEnd`, never `.never` for live data.
12. **The widget itself is near-silent.** Its only life is a wash healing across the day and a number rolling when it changes. That restraint is the polish. Why: a widget that shouts is a widget that gets removed. Check: nothing on the widget moves except the number and the background.
13. **App writes, extension reads.** Keep one `Codable` snapshot in the App Group container. The extension never queries PhotoKit, HealthKit, or the network directly. Why: the extension has seconds of runtime and no permission prompts; a query that works in the app hangs in the extension. Check: the extension imports no data framework.
14. **Deep-link continuity.** The link carries exactly what was tapped (the item, the mode). The app enters from a matching state, ideally with the same visual it was tapped on. Why: tap the widget and it should feel like you picked the thing up. Check: `widgetURL` or `Link` destinations are specific; no widget opens the app's root.
15. **Lock Screen accessory sizes are fixed.** `.accessoryCircular` about 76×76pt, `.accessoryRectangular` about 172×76pt, `.accessoryInline` one line of text with an optional leading symbol. No drop shadows, no gradients: tint mode flattens them. Check: accessory families preview in tint mode.
16. **StandBy is read from across a room.** Hero number ≥ 56pt. Test the red night-tint mode; most widgets have never been checked there and look broken. Check: preview with the StandBy environment and the red tint.
17. **Live Activity Lock Screen presentation ≤ 160pt tall.** Top row 24pt, bottom row 20pt. It hugs the sensor housing. System animations cap at about 2 seconds, there are none on Always-On, and it ignores your `withAnimation`. Update cadence matches the domain: transport every 30 s, audio every 5–10 s, a flight every 10 minutes until approach. Check: the activity view fits in a 160pt frame at AX3.
18. **Dynamic Island has hard limits.** Compact regions about 50pt wide, ≤ 5 characters each. Minimal is a single 22×22pt glyph. Expanded ≤ 200pt tall. Inset every image ≥ 4pt from the edge. No background colours. No buttons in compact or minimal. `.keylineTint` is the only branding chrome you get. Why: the island is system territory; violate the shape and it reads as a bug. Check: compact leading and trailing views are a glyph plus at most five characters.
19. **End a Live Activity with a short summary, then dismiss.** `dismissalPolicy: .after(.now + 15...30 min)` for "arrived", `.immediate` for cancelled. The system cap is 8 hours; design guidance is much shorter. Why: a stale "arriving" activity on the Lock Screen at midnight is a broken promise. Check: every `Activity.end` call passes a policy.
20. **Control Center titles are verb-first.** "Log water" reads on the Action Button as "Hold to Log Water". The control performs instantly and does not open the app unless the action needs a screen. Check: `ControlWidgetButton` titles start with a verb; `openAppWhenRun` is false unless there is a screen to show.
21. **Widget copy.** Relative time ("updated 4 min ago") over absolute. Empty state is warm and short ("nothing logged yet"), never "No data". Errors say "couldn't refresh" with the last good value dimmed, never "Error 404". Chrome labels lowercase if the project's copy is; sentence case otherwise. Gallery description is one verb-first sentence.
22. **Contrast for custom colours in dark mode: 7:1 for small text, never below 4.5:1.** Why: the Home Screen wallpaper is unknown; the widget container is your only guarantee.
23. **No confetti in a widget.** Completion is a quiet landing beat: the number lands, the gauge fills, the symbol morphs. **No faked press states.** The system gives you none; pretending is worse than nothing.

## Cheat sheet

| Surface | Size | Type floor | What moves |
|---|---|---|---|
| Small (Home) | ~158–170pt square | 11pt | number, wash |
| Medium (Home) | ~338–364 × 158–170pt | 11pt | number, wash |
| Large (Home) | ~338–364 × 354–382pt | 11pt | number, wash |
| Extra large | iPad and Mac only | 11pt | number, wash |
| Accessory circular | ~76×76pt | 11pt | number |
| Accessory rectangular | ~172×76pt | 11pt | number |
| Accessory inline | one line | system | text |
| StandBy | full | hero ≥ 56pt | number, wash |
| Live Activity (Lock) | ≤ 160pt tall | 12pt | `timerInterval`, `numericText` |
| Island compact | ~50pt each side, ≤ 5 chars | 12pt | `numericText` |
| Island minimal | 22×22pt | glyph | replace |
| Island expanded | ≤ 200pt tall | 12pt | `numericText` |

Content margins: ~16pt default, ~11pt tight. Timeline: entries ≥ 5 min; 40–70 reloads a day. Dark custom colours: 7:1 small text.

## Code

Snapshot shared through the App Group (app writes, extension reads):

```swift
struct WidgetSnapshot: Codable, Equatable {
    static let appGroup = "group.com.example.app"      // rename
    var count: Int
    var label: String?
    var updated: Date

    static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
            .appendingPathComponent("widget", isDirectory: true)
    }
    static func load() -> WidgetSnapshot? {
        guard let url = containerURL?.appendingPathComponent("snapshot.json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(WidgetSnapshot.self, from: data)
    }
    func save() throws {
        guard let dir = Self.containerURL else { return }
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try JSONEncoder().encode(self).write(to: dir.appendingPathComponent("snapshot.json"), options: .atomic)
    }
}
```

A widget view that respects every rule above:

```swift
struct CountWidgetView: View {
    @Environment(\.widgetRenderingMode) private var mode
    let entry: CountEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ViewThatFits {
                Text(entry.label)
                Text(entry.shortLabel)
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(secondary)

            Text(entry.count, format: .number)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .contentTransition(.numericText())
                .foregroundStyle(primary)

            Text("updated \(entry.date, style: .relative) ago")
                .font(.system(size: 11))
                .foregroundStyle(secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) { Color.clear }   // project background here
        .widgetURL(entry.deepLink)
    }

    // Vibrant hierarchy is opaque grey, never white at opacity.
    private var primary: Color { mode == .vibrant ? Color(white: 0.95) : .primary }
    private var secondary: Color { mode == .vibrant ? Color(white: 0.6) : .secondary }
}
```

Dynamic Island shape, within the limits:

```swift
DynamicIsland {
    DynamicIslandExpandedRegion(.leading) { Image(systemName: "figure.walk").padding(4) }
    DynamicIslandExpandedRegion(.trailing) {
        Text(timerInterval: context.state.range, countsDown: true).monospacedDigit()
    }
} compactLeading: {
    Image(systemName: "figure.walk")
} compactTrailing: {
    Text(context.state.shortStatus)          // ≤ 5 characters
        .monospacedDigit()
} minimal: {
    Image(systemName: "figure.walk")         // 22×22
}
.keylineTint(.accentColor)
```

## Checks

- Preview every family in `.fullColor`, `.accented`, and `.vibrant`; view `.vibrant` in greyscale.
- Preview accessory families in tint mode; nothing relies on a gradient or shadow.
- Preview StandBy with the red night tint.
- Set the simulator to AX5 and switch the language to German; no label truncates outside a `ViewThatFits` fallback.
- Tap every widget and every Live Activity; the app lands on the tapped thing, not the root.
- Force a timeline reload and count entries; spacing ≥ 5 minutes.
- Kill the app, wait an hour, look at the widget; it shows a relative time and the last good value, not "No data".
- Extension target imports: no PhotoKit, HealthKit, CoreLocation, or networking.

## Do not

- The shrunk screen: a miniature of the app's home view.
- The dead-centre logo: a widget whose hero is the brand mark.
- Washed-out tint: a custom colour that disappears in `.accented`.
- The mush: white at 0.5 opacity in `.vibrant`.
- The confident stale number: a value with no "updated" line and no dimming when old.
- The clipped corner: a literal radius inside `ContainerRelativeShape` territory.
- The blank widget: a timeline provider that ran out of memory fetching thumbnails.
- The dead-end tap: `widgetURL` that opens the app root.
- "Tap to configure": a placeholder that never had placeholder data.
- The teleport: a number that jumps without `.numericText`.
- The breathing icon: any symbol effect that loops.
- The disagreeing parts: the number, the gauge, and the label reflecting different timeline entries.
- The everything panel: three metrics, two buttons, and a chart in a small widget.
