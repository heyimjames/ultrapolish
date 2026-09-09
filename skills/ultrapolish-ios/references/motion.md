# Motion

Use this when you are adding, reviewing, or consolidating any animation in a SwiftUI app: springs, curves, staggers, content transitions, ambient loops, or the Reduce Motion fallback.
The goal is a small named vocabulary that every animation in the app comes from, so the whole app moves like one object.

## Rules

1. **Build a vocabulary, then forbid everything outside it.** An app with forty ad-hoc springs feels like forty apps. Name 5–8 curves, give each one job, and write the sentence "if a new animation does not fit one of these, the answer is usually don't" at the top of the file. Check: grep for `.spring(`, `.snappy(`, `.smooth(`, `.easeOut(`; every hit references a named constant.
2. **Scope every `.animation` with `value:`.** A bare `.animation(_)` animates every state change that passes through the view, including ones you never intended, which is the iOS equivalent of `transition: all`. Check: grep `\.animation\([^)]*\)$` for calls with no `value:`; each is a finding.
3. **One datum, one curve.** Everything driven by the same value uses the same `Animation` constant in the same `withAnimation` block. A number, its gauge, and its trend that arrive on three curves read as three objects. Check: for each `@State` that drives visuals, list the views it touches and confirm they share one constant.
4. **Out is faster than in.** Exit at ~0.65× the entrance duration with `bounce: 0`. People have already decided to leave. Sheet: in `0.42 / 0.18`, out `0.32 / 0`. Check: every presented surface has a distinct dismiss animation shorter than its present animation.
5. **The 100× rule.** If someone triggers it 100+ times a day, do not animate it. Tab switches, keyboard focus, arrow selection, list scrolling: instant, or a 0.14–0.16s press curve at most. Check: count how many times a day a heavy user hits each animated interaction.
6. **What follows a finger is linear.** During a drag, scrub, or dial, the view tracks the gesture 1:1 with no animation. A spring starts only on release, seeded with the release velocity. See `references/gestures-and-physics.md`. Check: no `.spring` inside an `.onChanged` handler.
7. **Entrances never `.easeIn`.** An element that starts slow looks reluctant to arrive. Entrances use a spring or `.timingCurve(0.16, 1, 0.3, 1, duration: 0.4)`. Exits may accelerate. Check: grep `.easeIn(` and confirm each is an exit.
8. **Stagger on first appearance only.** 30–80ms per element, at most ~8 items (240ms total). Beyond that the last item arrives after the user has already looked at it. Never re-stagger on scroll or on every data refresh. Check: staggered views carry a `hasAppeared` flag that is set once.
9. **Every changing number is monospaced and content-transitions.** `.monospacedDigit()` stops the layout shifting as 99 becomes 100; `.contentTransition(.numericText(value:))` rolls the digits. One without the other is half a fix. Check: every `Text` bound to a changing number has both modifiers.
10. **Icons morph, they do not breathe.** State changes on symbols use `.contentTransition(.symbolEffect(.replace))`. Idle animation on a symbol (`.breathe`, `.pulse`, `.bounce` on repeat) is the most recognisable template tell. Check: grep `symbolEffect` and confirm every use is a state change or a one-shot event.
11. **Ambient loops use `TimelineView`, never a `Timer`.** A `Timer` at 60fps re-renders the whole tree and drifts; `TimelineView(.animation)` is frame-synchronised and pauses off-screen. Period ≥ 1.2s. Check: grep `Timer.publish` and `repeatForever`; each is either an explicit ambient loop or a finding.
12. **Loops act, rest, then ease home.** A loop that snaps back to its start frame reads as a glitch. Do the thing, park the payoff so it dwells, then ease home. Check: watch any loop at 10% speed and find the snap.
13. **Write the storyboard as a comment above the constants.** Every state of the feature, top to bottom, with ms after trigger. It is the only document that survives refactors because it lives next to the numbers. Check: the motion file opens with the storyboard.
14. **Reduce Motion is a crossfade, not nothing.** Replace travel, scale, and 3D with `.easeInOut(duration: 0.18)` on opacity. Keep haptics. Stripping every animation makes the app feel broken. Check: toggle Reduce Motion in the simulator and walk the primary path.
15. **Interpolate the presentation, never the data.** A number that counts up to a total must pass through values that were never true, so it may only do that where the intermediate values carry no meaning: a confetti-free "1,284 readers" is fine, an account balance, a dose, a score, a countdown to a deadline and a progress figure are not. Never smooth a value by inventing one, never round to make a transition land, and snap the last fraction rather than easing through a number the system does not believe. If a chart's range must grow to fit a new high, expand it instantly so the line is never drawn outside its own axis, and ease it back in when the spike passes. Check: pause the animation mid-flight and read the number on screen; if a person could act on that value and it is wrong, the animation is lying.

## Cheat sheet

| Moment | Default | Note |
|---|---|---|
| Button press (touch-down) | `.spring(duration: 0.16, bounce: 0)` to scale 0.97 | Near-instant; fires hundreds of times a day |
| Button release | `.spring(duration: 0.30, bounce: 0.25)` | The one place a whisper of bounce belongs |
| State change (toggle, tab indicator, chip) | `.snappy(duration: 0.24 to 0.28, extraBounce: 0.08 to 0.12)` | Default for small UI |
| Crossfade (mode, colour, opacity) | `.smooth(duration: 0.22)` or `.easeOut(0.22)` | Opacity never springs |
| Sheet present | `.spring(duration: 0.42, bounce: 0.18)` | Contents +60–80ms |
| Sheet dismiss | `.spring(duration: 0.32, bounce: 0)` | Out faster than in |
| Hero / matched geometry | `.spring(duration: 0.42, bounce: 0.16)` | Radius animates with size |
| Navigation push | `.spring(duration: 0.38, bounce: 0.05)` | Deeper grows in from 0.94; shallower shrinks in from 1.04 |
| Weighted object settling | `.spring(duration: 0.45, bounce: 0.12)` | Cards after a drag |
| Celebration (rare) | `.bouncy(duration: 0.6, extraBounce: 0.3)` | Once per milestone |
| Progress tracking a real value | `.linear(duration: 0.18)` | It is a number |
| Ambient loop | ≥ 1.2s, `TimelineView` | Never on a symbol |
| Reduce Motion fallback | `.easeInOut(duration: 0.18)` | Opacity only |

### Spring notation conversion

| You have | Use | Note |
|---|---|---|
| `response: r, dampingFraction: d` | `.spring(duration: r, bounce: 1 - d)` | Approximate; 0.42/0.82 ≈ duration 0.42, bounce 0.18 |
| `.smooth` | `duration 0.5, bounce 0` | System preset |
| `.snappy` | `duration 0.5, bounce 0.15` | System preset |
| `.bouncy` | `duration 0.5, bounce 0.3` | System preset |
| `stiffness / damping` | Do not translate; re-tune by feel | Different model |

## Code

### A vocabulary file (worked example, shipped in a RAW-extraction utility)

```swift
import SwiftUI

/// The whole motion vocabulary. Seven curves, each with one job. If a new
/// animation does not fit one of these, the answer is usually "don't".
enum Motion {
    /// Weighted objects arriving or returning: a bar, a viewer, a card snapping back.
    static let settle = Animation.spring(duration: 0.42, bounce: 0.16)
    /// Something carrying an image between two places. Better damped: it must not wobble.
    static let fly = Animation.spring(duration: 0.34, bounce: 0.10)
    /// The one deliberate overshoot in the app.
    static let reveal = Animation.spring(duration: 0.55, bounce: 0.32)
    /// Yes/no state: rings, ticks, a tile lifting when selected.
    static let state = Animation.snappy(duration: 0.22)
    /// Mode changes and label crossfades. Nothing travels.
    static let mode = Animation.smooth(duration: 0.22)
    /// Pure opacity: thumbnails arriving, captions, the landing stagger.
    static let fade = Animation.easeOut(duration: 0.3)
    /// A fill that tracks a real number, so it moves linearly.
    static let progress = Animation.linear(duration: 0.18)
    /// Reduce Motion stand-in for anything that would otherwise travel.
    static let reduced = Animation.easeOut(duration: 0.2)
}
```

### The storyboard-as-comment shape (from a control-surface app; values are its own)

```swift
/* MOTION STORYBOARD
 * Read top-to-bottom. Each value is ms after trigger.
 * Motion is earned: the frequent moments are near-instant, the rare ones get the fuller
 * transition. The ceiling is a considered transition, never a set piece.
 *
 * POWER ON (once per connection; rare)
 *     0ms   surface already there, pads at scale 0.92, opacity 0
 *    60ms   rail pills fade in
 *   120ms   pads appear in a diagonal wave (staggered 24ms by row+col)
 *
 * PRESS (hundreds of times a day; near-instant)
 *    70ms   touch confirmed (a swipe would have moved by now)
 *           scale 1.0 -> 0.96, haptic                     (140ms, no bounce)
 *   release scale 0.96 -> 1.0                             (320ms, bounce 0.18)
 *
 * FOLDER OPEN (deeper = grow in from 0.94)   BACK (shallower = shrink in from 1.04)
 *
 * REDUCED MOTION: no scale, no travel, no sweep. Opacity and colour only.
 */
enum Timing {
    static let padStagger   = 24   // ms between diagonal groups
    static let pressCommit  = 70   // touch must hold this long before it counts
}
```

Keep the constants directly under the storyboard. A reader should never have to hunt for the number the comment describes.

### Scoped animation and unified interpolation

```swift
struct Meter: View {
    let value: Double            // one datum
    private let curve = Motion.settle

    var body: some View {
        VStack(spacing: 8) {
            Text(value, format: .number.precision(.fractionLength(0)))
                .monospacedDigit()
                .contentTransition(.numericText(value: value))
            Gauge(value: value, in: 0...100) { EmptyView() }
            Image(systemName: value > 50 ? "arrow.up" : "arrow.down")
                .contentTransition(.symbolEffect(.replace))
        }
        .animation(curve, value: value)   // one curve, three siblings, scoped
    }
}
```

### First-appearance stagger

```swift
struct StaggeredList<Item: Identifiable, Row: View>: View {
    let items: [Item]
    @ViewBuilder let row: (Item) -> Row
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ForEach(Array(items.prefix(8).enumerated()), id: \.element.id) { index, item in
            row(item)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared || reduceMotion ? 0 : 8)
                .animation(
                    (reduceMotion ? Motion.reduced : Motion.fade).delay(Double(index) * 0.04),
                    value: appeared
                )
        }
        ForEach(items.dropFirst(8)) { row($0) }   // no stagger past 8
        .onAppear { appeared = true }              // set once, never reset on refresh
    }
}
```

### Ambient loop with `TimelineView`

```swift
struct Shimmer: ViewModifier {
    func body(content: Content) -> some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { context in
            let t = context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.4) / 1.4
            content.overlay(
                LinearGradient(colors: [.clear, .white.opacity(0.25), .clear], startPoint: .leading, endPoint: .trailing)
                    .offset(x: (t * 2 - 1) * 300)
                    .blendMode(.plusLighter)
            )
            .mask(content)
        }
    }
}
```

### Reduce Motion fallback

```swift
extension Animation {
    /// Use the intended curve, or a short crossfade when Reduce Motion is on.
    static func polished(_ intended: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.18) : intended
    }
}
```

## Checks

- Open the motion file. It begins with a storyboard comment and holds every curve the app uses.
- Grep for spring literals outside the motion file. Expect zero.
- Grep for `.animation(` without `value:`. Expect zero.
- For each presented surface, the dismiss is shorter than the present and has no bounce.
- Record the primary path at 10% speed (Simulator: Debug > Slow Animations). Nothing snaps, nothing overshoots twice, siblings move together.
- Toggle Reduce Motion. Everything still changes state; nothing travels.
- Every `Text` bound to a changing number has `.monospacedDigit()` and `.numericText`.

## Do not

- Add a spring because the surface "feels flat". Ask what the frequency is first.
- Put `.animation` on a container to animate "everything inside". Scope it.
- Use `withAnimation` around state that also drives an unrelated view.
- Animate opacity with a bouncy spring.
- Let a `Timer` drive anything visual.
- Ship a loop that snaps to its first frame.
- Strip all animation under Reduce Motion.
