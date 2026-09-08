# Gestures and physics

Use this when a view follows a finger: drag to dismiss, swipe to reply, reorder, scrub, pull, pan, or any custom gesture that hands off into an animation.
The difference between "app-like" and "web-like" on iOS is almost entirely whether motion inherits the gesture's velocity and can be interrupted mid-flight.

## Rules

1. **Interruptibility is the single most important principle.** Always animate from the current on-screen value, never from the target you were heading to. If a sheet is halfway closed and the user grabs it, it must be exactly where they see it. In SwiftUI this means state holds the presentation value and gestures write to it directly. Check: grab any animating surface mid-flight; it stops under the finger, not at the destination.
2. **Follow the finger 1:1.** During `.onChanged`, set the offset with no animation. A spring during a drag lags the finger and feels like dragging through syrup. Check: no `withAnimation` and no `.spring` inside any `.onChanged`.
3. **Velocity decides commit, not position.** Read `value.predictedEndTranslation` or `value.velocity` on release. A fast flick past 600pt/s commits regardless of distance; an upward flick always cancels a downward dismiss. Distance threshold is the fallback at 120pt. Check: flick a sheet 30pt fast and it dismisses; drag it 200pt then reverse slowly and it stays.
4. **Hand the velocity into the spring.** On release, start the settle animation with `.interpolatingSpring(..., initialVelocity:)` or `.spring` seeded from the gesture so the object continues on its trajectory. A spring that starts from rest after a flick reads as a brick wall. Check: a flicked card keeps moving in the flick direction before settling.
5. **Rubber-band past the edge with Apple's constant.** `(1 - 1 / (offset / dimension × 0.55 + 1)) × dimension`. It is asymptotic, which is why iOS overscroll feels like elastic and not a wall. Check: dragging past the limit slows smoothly and never stops dead.
6. **Project momentum the way the platform does.** Apple's deceleration is `distance = (v / 1000) × d / (1 − d)` with `d ≈ 0.998` (0.99 for a snappier feel). The textbook `v² / 2a` is not what the OS ships and will feel foreign next to system scroll views. Check: a paged or snapping surface lands where a native scroll view would.
7. **Decompose 2D motion into independent X and Y springs.** One spring on a 2D distance desynchronises the axes and curves the path. Check: a freely dragged object released diagonally travels straight.
8. **Detect every plausible gesture in parallel, then cancel the losers.** A recogniser that waits for a final state feels laggy. Decide direction after ~10pt of travel; a tap survives ~10pt of hysteresis. Check: a slight wobble during a tap still taps; a slow diagonal drag picks one axis and sticks to it.
9. **Commit a press only after it has held ~70ms.** A swipe has moved by then. Without the delay, every scroll across a grid of buttons lights them up. Check: swipe across a button grid; nothing highlights.
10. **Give threshold feedback once.** When a drag crosses the commit threshold, fire one `.soft` impact and change the visual (the reply glyph fills, the backdrop reaches its darkest). Fire it again only if the user crosses back and re-enters. Check: hold the finger at the threshold; the haptic does not repeat.
11. **Progress the backdrop with the drag.** A dismissing surface darkens or scales its backdrop linearly with offset over the first ~200pt so the user sees the consequence of letting go. Check: at half a dismiss, the backdrop is at half opacity.

## Cheat sheet

| Value | Default |
|---|---|
| Drag-dismiss commit | 120pt travel or 600pt/s velocity, whichever first |
| Upward flick during downward dismiss | always cancels |
| Tap hysteresis | ~10pt |
| Direction lock | after ~10pt of travel |
| Press commit delay | ~70ms |
| Rubber-band constant | 0.55 |
| Deceleration rate | 0.998 per ms (0.99 snappier) |
| Backdrop progression | linear over 0–200pt |
| Threshold haptic | `.impact(flexibility: .soft)` once per crossing |
| Settle after release | `.spring(duration: 0.45, bounce: 0.12)` seeded with velocity |
| Swipe-to-reply cap | 80pt offset, threshold 60pt, `minimumDistance: 16` |

## Code

### Rubber-band and momentum projection

```swift
import SwiftUI

enum Physics {
    /// Apple-style elastic resistance past an edge.
    static func rubberBand(_ offset: CGFloat, dimension: CGFloat, c: CGFloat = 0.55) -> CGFloat {
        let sign: CGFloat = offset < 0 ? -1 : 1
        let x = abs(offset)
        return sign * (1 - 1 / (x / dimension * c + 1)) * dimension
    }

    /// Where a flick will come to rest. `velocity` in pt/s, matching DragGesture.Value.velocity.
    static func project(velocity: CGFloat, decelerationRate d: CGFloat = 0.998) -> CGFloat {
        (velocity / 1000) * d / (1 - d)
    }
}
```

### Swipe to dismiss with progressive backdrop, threshold haptic, and velocity handoff

```swift
struct DismissibleCard<Content: View>: View {
    let onDismiss: () -> Void
    @ViewBuilder let content: Content

    @State private var offset: CGFloat = 0
    @State private var crossed = false
    @State private var thresholdTick = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let commitDistance: CGFloat = 120
    private let commitVelocity: CGFloat = 600

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5 * (1 - min(max(offset, 0) / 200, 1)))   // linear over 0–200pt
                .ignoresSafeArea()
            content
                .offset(y: offset)
                .gesture(drag)
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: thresholdTick)
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                let y = value.translation.height
                // Follow the finger 1:1 downward; rubber-band upward.
                offset = y >= 0 ? y : Physics.rubberBand(y, dimension: 300)
                let nowCrossed = y > commitDistance
                if nowCrossed != crossed {
                    crossed = nowCrossed
                    if nowCrossed { thresholdTick += 1 }   // once per crossing
                }
            }
            .onEnded { value in
                let v = value.velocity.height          // pt/s
                let upwardFlick = v < -commitVelocity
                let commit = !upwardFlick && (v > commitVelocity || offset > commitDistance)
                if commit {
                    withAnimation(reduceMotion ? .easeInOut(duration: 0.18) : .spring(duration: 0.32, bounce: 0)) {
                        offset = 900
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: onDismiss)
                } else {
                    // Seed the settle with the release velocity so it continues its trajectory.
                    withAnimation(reduceMotion
                                  ? .easeInOut(duration: 0.18)
                                  : .interpolatingSpring(duration: 0.45, bounce: 0.12, initialVelocity: v / 300)) {
                        offset = 0
                    }
                    crossed = false
                }
            }
    }
}
```

`initialVelocity` is expressed relative to the distance travelled, so divide the pt/s velocity by the remaining distance in points. `v / 300` is a reasonable seed for a 300pt travel; tune by feel, not by formula.

### Two independent axes

```swift
@State private var x: CGFloat = 0
@State private var y: CGFloat = 0

.onEnded { value in
    withAnimation(.interpolatingSpring(duration: 0.45, bounce: 0.12,
                                       initialVelocity: value.velocity.width / 200)) { x = 0 }
    withAnimation(.interpolatingSpring(duration: 0.45, bounce: 0.12,
                                       initialVelocity: value.velocity.height / 200)) { y = 0 }
}
```

### Press that commits after 70ms (so swipes do not light buttons)

```swift
struct CommittedPress: ViewModifier {
    let onPress: () -> Void
    @State private var pending: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard pending == nil else { return }
                    pending = Task {
                        try? await Task.sleep(for: .milliseconds(70))
                        if !Task.isCancelled { onPress() }
                    }
                }
                .onEnded { _ in pending?.cancel(); pending = nil }
        )
    }
}
```

Pair with a scroll view's own gesture; the scroll wins after 10pt of travel and cancels the pending press.

### Swipe to reply (bounded, with a single threshold haptic)

```swift
DragGesture(minimumDistance: 16)
    .onChanged { value in
        let raw = max(0, value.translation.width)
        replyOffset = min(raw, 80)                       // cap at 80pt
        let crossedNow = raw > 60
        if crossedNow != crossed { crossed = crossedNow; if crossedNow { tick += 1 } }
    }
    .onEnded { _ in
        if crossed { onReply() }
        withAnimation(.spring(duration: 0.32, bounce: 0.12)) { replyOffset = 0 }
        crossed = false
    }
```

## Checks

- Drag any dismissible surface halfway, grab it again before it settles. It stops under the finger.
- Flick a sheet 30pt fast: dismisses. Drag 200pt and slowly reverse: stays.
- Flick upward while dismissing downward: cancels every time.
- Drag past a limit: slows smoothly, never stops dead.
- Release diagonally: object travels straight, not in an arc.
- Swipe across a grid of buttons: nothing highlights.
- Hold the finger at a threshold: the haptic fires once.
- With Reduce Motion on: everything still commits and cancels; nothing travels on release.

## Do not

- Animate inside `.onChanged`.
- Decide commit by distance alone.
- Start a settle spring from rest after a flick.
- Use a single spring for a 2D offset.
- Fire the threshold haptic on every frame past the threshold.
- Compute deceleration with `v² / 2a`.
- Use `predictedEndTranslation` as the destination; use it as a signal.
