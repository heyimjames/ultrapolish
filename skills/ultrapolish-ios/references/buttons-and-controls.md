# Buttons and controls

Use this when you are building or reviewing any tappable thing: buttons, CTAs, chips, rows, toggles, segmented controls, sliders, floating actions.
Buttons are the most-pressed surface in the app. Their press feel, state handling, and hierarchy do more for "considered" than almost anything else.

## Rules

1. **Tap target is 44×44pt, always.** The visual can be smaller; the hit area cannot. Why: below 44pt, miss rates climb fast on a moving thumb. Check: every control has `.frame(minHeight: 44)` and `.contentShape(Rectangle())`, or is a system control that already does.
2. **`.contentShape` is the part people forget.** Why: without it, only the drawn glyph registers taps; the padding is dead. Check: tap the empty space next to a 24pt icon button and it fires.
3. **Press-down haptic, never on release.** `.impact(weight: .light)` the instant the finger lands. Why: the user reads it as "the button heard me"; on release it reads as an echo. Check: the `.sensoryFeedback` closure returns feedback only when `pressed == true`.
4. **Press scale follows the ladder.** Rows 0.99, surfaces and CTAs 0.97, small icon buttons 0.94, floor 0.90. Opacity 0.9 while pressed. `.spring(duration: 0.16, bounce: 0)`. Why: it fires hundreds of times a day; near-instant is correct. Check: nothing scales below 0.90.
5. **Release may overshoot; press may not.** Release with `.spring(duration: 0.30, bounce: 0.25)`. Why: the one place a whisper of bounce belongs. Check: press-down curve has bounce 0.
6. **Loading locks width.** Measure the label once, pin `minWidth`, swap the label for `ProgressView()` in the same frame. Why: a button that resizes when it starts working reads as broken. Check: tap, watch the edges; nothing moves.
7. **Disabled is transparency plus a reason.** Never grey, never silent. Why: a grey button with no explanation is hostile. Check: every disabled control has an adjacent line saying what will enable it.
8. **Success reverts after 1.5s.** Symbol swaps with `.symbolEffect(.replace)`, label goes past tense, then returns to rest. Why: long enough to read, short enough to not trap the control. Check: the `.task(id:)` sleeps 1.5s.
9. **Errors are inline, under the control.** Never an alert for a recoverable failure. Why: an alert stops the world for something the user can fix in place. Check: failure copy appears within 12pt of the control and names the fix.
10. **One primary per view.** The primary carries the accent on its background. Secondary is tinted-transparent or text. Why: when everything is tinted, nothing is. Check: count filled accent buttons on screen; the answer is one.
11. **Destructive is visually distinct and names the noun.** Red fill or red text, `role: .destructive`, "Delete photo" not "Delete". Check: no destructive button is styled like the primary.
12. **Sliders and dials follow the finger linearly.** No spring while dragging; `.selection` haptic at detents only, never per pixel. Why: springs fight the finger. Check: drag a slider slowly; the thumb is exactly under the finger.
13. **Sticky CTAs use the safe-area inset.** `.safeAreaInset(edge: .bottom)` with `.background(.bar)`. Why: content scrolls under it correctly and the bar adapts to the system material. Check: the last row of content is fully visible above the bar.
14. **A row with an inner button captures the inner tap first.** Use a real `Button` inside; the outer tap only fires outside it. Check: tapping "Follow" does not open the profile.

## Cheat sheet

| Size | Height | H-pad | Font | Radius | Use |
|---|---|---|---|---|---|
| xs | 28 | 12 | 13 semibold | 8 | Chips, filters |
| sm | 32 | 16 | 14 semibold | 8 | Toolbar, inline secondary |
| md | 44 | 20 | 15 semibold | 12 | Standard, forms |
| lg | 52 | 24 | 17 semibold | 14 | Section CTAs |
| xl | 60 | 28 | 17 bold | 16 | Paywall, onboarding primary |

Radii are defaults; the project's own ladder wins. All radii `.continuous`. Full-width primaries may use the project's capsule if that is its language.

| State | Visual | Motion | Feedback |
|---|---|---|---|
| Rest | as designed | | |
| Pressed | scale 0.97, opacity 0.9 | `.spring(duration: 0.16, bounce: 0)` | `.impact(weight: .light)` on touch-down |
| Released | scale 1.0 | `.spring(duration: 0.30, bounce: 0.25)` | none |
| Loading | label swapped for `ProgressView`, width locked | `.snappy(duration: 0.22)` crossfade | none |
| Disabled | opacity 0.35, reason line adjacent | `.easeOut(0.2)` | none |
| Success | checkmark via `.symbolEffect(.replace)`, past-tense label | `.snappy` | `.success` once |
| Error | inline message under the control, "Try again" label | `.snappy` | `.error` once |

| Control | Motion | Haptic |
|---|---|---|
| Toggle thumb | `.snappy(duration: 0.24, extraBounce: 0.2)` | `.selection` |
| Segmented / tab indicator | `.snappy(duration: 0.28, extraBounce: 0.12)` | `.selection` on change |
| Chip select | `.snappy(duration: 0.24)` | `.selection` |
| Slider, scrubber, dial | `.linear` or none while dragging | `.selection` at detents; `.rigid` at centre detent |
| Stepper | instant | `.increase` / `.decrease` |
| Floating action button | press 0.94 | `.impact(weight: .medium)` |

## Code

Press style with touch-down haptic and a static escape for controls that must not scale (dense tools, keyboard-driven lists).

```swift
struct PressableButtonStyle: ButtonStyle {
    var feedback: SensoryFeedback? = .impact(weight: .light)
    var scale: CGFloat = 0.97
    var isStatic = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !isStatic ? scale : 1)
            .opacity(configuration.isPressed && !isStatic ? 0.9 : 1)
            .animation(.spring(duration: 0.16, bounce: 0), value: configuration.isPressed)
            .sensoryFeedback(trigger: configuration.isPressed) { _, pressed in
                pressed ? feedback : nil      // touch-down only
            }
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { .init() }
    static func pressable(_ feedback: SensoryFeedback?, scale: CGFloat = 0.97) -> PressableButtonStyle {
        .init(feedback: feedback, scale: scale)
    }
}
```

Loading that locks its width, and success that reverts.

```swift
struct LoadingButton: View {
    let label: String
    let action: () async throws -> Void

    @State private var stableWidth: CGFloat?
    @State private var isLoading = false
    @State private var showSuccess = false

    var body: some View {
        Button {
            Task {
                isLoading = true
                defer { isLoading = false }
                if (try? await action()) != nil { showSuccess = true }
            }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView().controlSize(.small)
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: showSuccess ? "checkmark" : "arrow.up")
                            .contentTransition(.symbolEffect(.replace))
                        Text(showSuccess ? "Sent" : label)
                    }
                    .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { w in
                        if stableWidth == nil { stableWidth = w }
                    }
                }
            }
            .frame(minWidth: stableWidth, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.pressable)
        .disabled(isLoading)
        .animation(.snappy(duration: 0.22), value: isLoading)
        .sensoryFeedback(.success, trigger: showSuccess) { _, new in new }
        .task(id: showSuccess) {
            guard showSuccess else { return }
            try? await Task.sleep(for: .seconds(1.5))
            showSuccess = false
        }
    }
}
```

Sticky CTA that respects the safe area and reacts to scroll direction.

```swift
@State private var ctaVisible = true
@State private var lastOffset: CGFloat = 0

ScrollView { content }
    .onScrollGeometryChange(for: CGFloat.self) { $0.contentOffset.y } action: { _, y in
        let delta = y - lastOffset
        guard abs(delta) > 8 else { return }
        withAnimation(.spring(duration: 0.32, bounce: 0)) { ctaVisible = delta < 0 }
        lastOffset = y
    }
    .safeAreaInset(edge: .bottom) {
        if ctaVisible {
            Button("Continue") { next() }
                .buttonStyle(.pressable)
                .frame(maxWidth: .infinity, minHeight: 52)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(.bar)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
```

Row with a primary tap and an inner button that captures its own tap.

```swift
HStack {
    profileSummary
    Spacer()
    Button("Follow") { follow() }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
}
.padding()
.contentShape(Rectangle())
.onTapGesture { openProfile() }
```

Disabled with a reason.

```swift
VStack(spacing: 8) {
    Button("Continue") { next() }
        .buttonStyle(.pressable)
        .disabled(email.isEmpty)
        .opacity(email.isEmpty ? 0.35 : 1)
    if email.isEmpty {
        Text("Enter your email to continue")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
}
.animation(.easeOut(duration: 0.2), value: email.isEmpty)
```

## Checks

- Tap the padding of every icon button; it fires.
- Press and hold: scale 0.97, haptic fired once on the way down, nothing on the way up.
- Start a load: measure the button before and after; identical width.
- Disable a control: a reason is visible without tapping anything.
- Count filled accent buttons per screen: one.
- Drag a slider slowly; the thumb never lags or overshoots the finger.
- Trigger a failure: the message is inline, under the control, with a "Try again" path.
- Turn on Reduce Motion: press feedback still works (it is 0.16s and small; keep it).

## Do not

- Put `.sensoryFeedback` on release.
- Scale a row or list cell below 0.99.
- Use a custom spinner inside a button; `ProgressView()` adapts to scheme and Reduce Motion.
- Ship two filled buttons side by side.
- Style a destructive action like the primary.
- Use "Submit", "OK", or "Yes / No" as labels (see `references/copy-and-naming.md`).
- Let a floating action button cover the last row; move it out of the way on scroll.
- Spring a slider thumb.
- Wrap glass buttons (iOS 26) in your own scale style; `.interactive()` already does it (see `references/liquid-glass.md`).
