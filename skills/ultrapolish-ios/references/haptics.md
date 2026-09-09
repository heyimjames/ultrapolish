# Haptics

Use this when adding, auditing, or budgeting haptic feedback: which style, on which event, at what frequency, and when to say nothing.
Haptics are punctuation. A full stop, not an exclamation mark. The apps that feel best fire fewer haptics than you expect, and fire them at the exact moment of contact.

## Rules

1. **Press fires on touch-down, never on release.** The user reads a touch-down haptic subconsciously as "the button heard me". On release it arrives after the decision and feels like a delay. Check: press and hold any button; the tick happens immediately.
2. **One `.success` per commit.** Sending, saving, completing: one haptic for the whole batch, never one per item. Check: complete a batch of ten; count the ticks (expect one).
3. **`.selection` on the crossing, not per pixel.** Pickers, segmented controls, detents, week boundaries: fire when the value changes, not while the finger moves. Check: drag slowly across a picker; each tick lines up with a value change.
4. **Prepare before predictable moments.** `prepare()` on a `UIFeedbackGenerator` cuts latency from ~50ms to under 5ms and stays warm for ~2 seconds. Call it on touch-down for the release haptic, or when a countdown enters its last second. With `.sensoryFeedback` the system prepares for you; use the UIKit generator only when you need the timing control. Check: a haptic tied to a visual lands within the same frame.
5. **Anything with a physical metaphor earns a texture.** Not just commits. A toggle flipping, a tab changing, a drag handle picked up and put down, a pull crossing its refresh threshold, a long-press arming, a reordered row crossing its neighbour: each is an object behaving like an object, and each gets one. Use `.impact(.light)` for pick-up and thresholds, `.impact(.rigid)` for a drop, `.impact(.soft)` for arming, and `.selection` for crossings. This widens the budget deliberately; it does not touch the two exclusions, never double-firing what the system already fires and never firing on scroll, launch, timers or per item in a batch, which both still hold. Check: every texture maps to something the user would expect to feel if the object were real, and none of them fires on scroll, on launch, or per item in a batch.
6. **Throttle continuous haptics and scale them with density.** Scrubbing, flipping, ticking: at most one transient per 30ms (45ms when many things move), intensity `0.35 + 0.35 × density`, sharpness `0.5 + 0.4 × density`. The landing is heavier and duller (intensity 0.9, sharpness 0.25). Check: a full-board cascade reads as a flutter, not machine-gun fire.
7. **Never double-fire what the system already fires.** Context-menu open (`.medium`), context-menu select (`.medium`), dismiss-outside (`.soft`), widget button taps, Camera Control half-press, `Toggle`, `Picker`, pull-to-refresh, and `.sensoryFeedback`-backed system controls all fire on their own. Check: strip your haptics from these and compare.
8. **Fire yourself where the system is silent.** Action Button intents, custom buttons, custom sliders, drag thresholds, and completions get nothing from the system. Check: every custom control has a press-down haptic.
9. **Haptic and sound land within 10ms.** Latency between them destroys the illusion of one event. Trigger both from the same line, sound already prepared. Check: record with a high-speed camera or trust the ear; any gap reads as two events.
10. **Guard iPad and Mac.** iPads have no haptic engine; `.sensoryFeedback` is a no-op there, but `CHHapticEngine()` throws. Check `CHHapticEngine.capabilitiesForHardware().supportsHaptics` before building an engine. Check: run on an iPad simulator; nothing crashes, nothing logs.
11. **Budget per session.** A screen that ticks on every state change is noise; the user stops feeling any of them. Decide which three to five moments per app deserve a signature, and give everything else the standard vocabulary or nothing. Check: list every haptic the app fires on the primary path; if it exceeds ~8 distinct moments, cut.
12. **Never haptic** cold launch, list scrolling, foreground notifications, saved settings, read receipts (once per conversation per session at most), loading completions the user did not wait for, or anything on a timer. Check: grep `sensoryFeedback` and `impactOccurred`; each site maps to a user action.

## Cheat sheet

| Moment | `.sensoryFeedback` | Rule |
|---|---|---|
| Button press | `.impact(weight: .light)` | Touch-DOWN, never release |
| Selection change | `.selection` | On the crossing only |
| Commit (send, save, complete) | `.success` | Once per commit |
| Warning state entered | `.warning` | Once on entering |
| Error | `.error` | Paired with inline copy |
| Pick up / drag start | `.impact(flexibility: .soft, intensity: 0.7)` | |
| Land / drop | `.impact(weight: .medium)` | Heavier and duller than pick-up |
| Snap to detent | `.impact(flexibility: .rigid)` | At the detent, not near it |
| Alignment (crop, guides) | `.alignment` | Once per alignment |
| Level change (slider quarter marks) | `.levelChange` | Throttle ≥ 80ms |
| Start / stop (record, timer) | `.start` / `.stop` | |
| Continuous (scrub, flip) | CoreHaptics transient | ≥ 30ms apart, density-scaled |

| CoreHaptics parameter | Tap / click | Soft press | Rumble |
|---|---|---|---|
| Intensity | 0.8–1.0 | 0.4–0.6 | 0.3–0.6 |
| Sharpness | 0.6–1.0 | 0.2–0.4 | 0.0–0.2 |

A transient is ~80ms. Continuous events run up to 30s. A generator stays warm ~2s after `prepare()`.

## Code

### Everyday haptics with `.sensoryFeedback`

```swift
struct SendButton: View {
    @State private var pressTick = 0
    @State private var sentCount = 0
    let send: () async -> Bool

    var body: some View {
        Button("Send") { Task { if await send() { sentCount += 1 } } }
            .buttonStyle(.pressable)   // fires pressTick on touch-down; see assets/PressableButtonStyle.swift
            .sensoryFeedback(.impact(weight: .light), trigger: pressTick)
            .sensoryFeedback(.success, trigger: sentCount)          // once per commit
    }
}

// Selection on the crossing: trigger is the value, so the tick lines up with the change.
Picker("Sort", selection: $sort) { /* ... */ }
    .sensoryFeedback(.selection, trigger: sort)

// Conditional: only when entering the warning state.
.sensoryFeedback(.warning, trigger: isOverLimit) { old, new in !old && new }
```

### Prepared UIKit generator for tight timing

```swift
final class PressHaptics {
    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)

    func touchDown() {
        light.impactOccurred()
        medium.prepare()            // the release haptic is now < 5ms away
    }
    func release(velocity: CGFloat) {
        medium.impactOccurred(intensity: 0.3 + min(velocity / 2000, 1) * 0.7)   // velocity-mapped
    }
}
```

### Density-scaled continuous haptics (CoreHaptics with a fallback)

```swift
import CoreHaptics
import UIKit

final class ContinuousHaptics {
    private var engine: CHHapticEngine?
    private let fallback = UIImpactFeedbackGenerator(style: .rigid)
    private var last: TimeInterval = 0

    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }   // iPad guard
        engine = try? CHHapticEngine()
        engine?.playsHapticsOnly = true
        engine?.isAutoShutdownEnabled = true
        engine?.resetHandler = { [weak self] in try? self?.engine?.start() }
    }

    /// One tick per burst of moving things. Sharpness rises with how much is moving.
    func tick(moving: Int, now: TimeInterval = ProcessInfo.processInfo.systemUptime) {
        let gap: TimeInterval = moving > 30 ? 0.045 : 0.03
        guard now - last >= gap else { return }
        last = now
        let density = min(1, Float(moving) / 50)
        transient(intensity: 0.35 + 0.35 * density, sharpness: 0.5 + 0.4 * density)
    }

    /// The landing: heavier, duller.
    func settle() { transient(intensity: 0.9, sharpness: 0.25) }

    private func transient(intensity: Float, sharpness: Float) {
        guard let engine else { fallback.impactOccurred(intensity: CGFloat(intensity)); return }
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [
            .init(parameterID: .hapticIntensity, value: intensity),
            .init(parameterID: .hapticSharpness, value: sharpness),
        ], relativeTime: 0)
        do {
            try engine.start()
            let player = try engine.makePlayer(with: try CHHapticPattern(events: [event], parameters: []))
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            fallback.impactOccurred(intensity: CGFloat(intensity))
        }
    }
}
```

### A signature: two transients that read as one object materialising

```swift
func materialise(engine: CHHapticEngine) throws {
    let events = [
        CHHapticEvent(eventType: .hapticTransient, parameters: [
            .init(parameterID: .hapticIntensity, value: 0.55),
            .init(parameterID: .hapticSharpness, value: 0.30),
        ], relativeTime: 0),
        CHHapticEvent(eventType: .hapticTransient, parameters: [
            .init(parameterID: .hapticIntensity, value: 0.9),
            .init(parameterID: .hapticSharpness, value: 0.55),
        ], relativeTime: 0.085),
    ]
    try engine.makePlayer(with: try CHHapticPattern(events: events, parameters: [])).start(atTime: CHHapticTimeImmediate)
}
```

Reserve this kind of pattern for the three to five moments per app that deserve a signature. Everything else uses the standard vocabulary.

### AHAP shape (for designers to hand over)

```json
{
  "Version": 1.0,
  "Pattern": [
    { "Event": { "Time": 0.0,   "EventType": "HapticTransient",
                 "EventParameters": [ { "ParameterID": "HapticIntensity", "ParameterValue": 0.55 },
                                      { "ParameterID": "HapticSharpness", "ParameterValue": 0.30 } ] } },
    { "Event": { "Time": 0.085, "EventType": "HapticTransient",
                 "EventParameters": [ { "ParameterID": "HapticIntensity", "ParameterValue": 0.90 },
                                      { "ParameterID": "HapticSharpness", "ParameterValue": 0.55 } ] } }
  ]
}
```

Load with `CHHapticPattern(contentsOf:)`.

## Checks

- Press and hold every button: the tick is on touch-down.
- Complete a batch: exactly one `.success`.
- Drag slowly across each picker and detent: one tick per value change, none between.
- Open a context menu with your own haptic disabled: the system already ticks.
- Run on iPad: no crash, no console noise.
- List every haptic on the primary path: none on scroll, launch, or timers, and none duplicating a system-fired one. The count is not capped, but every entry names the physical event it stands for; a haptic you cannot name that way is decoration.
- Trigger the paired sound and haptic together: they land as one event.

## Do not

- Fire on release.
- Fire once per item in a batch.
- Fire on every pixel of a drag.
- Duplicate system haptics on `Toggle`, `Picker`, context menus, or widget buttons.
- Build a `CHHapticEngine` without checking `supportsHaptics`.
- Tie a haptic to a timer, a fetch completion, or a notification arriving in the foreground.
- Give every state change a signature pattern.
