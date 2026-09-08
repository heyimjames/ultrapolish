# Accessibility as polish

Use this when auditing or building any screen. The apps people describe as "beautifully made" are the ones that still hold together at the largest Dynamic Type, with Reduce Motion on, in Increase Contrast, and under VoiceOver. These four settings are the polish test most apps never run.

## Rules

1. **Test four settings before calling anything done:** Dynamic Type at `.accessibility5`, Reduce Motion, Increase Contrast, VoiceOver. Why: each one exposes a different class of shortcut. Check: a launch scheme exists for each (see Code).
2. **Dynamic Type to AX5 without clipping.** Use semantic `Font` styles. Wrap any row with a variable string in `ViewThatFits` with a tighter variant. Let `VStack`s replace `HStack`s at large sizes with `@Environment(\.dynamicTypeSize)`. Cap scaling only on chrome that must not grow (`.dynamicTypeSize(...DynamicTypeSize.xxxLarge)`), never on body content. Why: about a third of users run larger-than-default text; AX sizes are common among older users. Check: run at AX5; every label readable, no overlapping, no truncated buttons.
3. **Reduce Motion means crossfade, not nothing.** Replace travel, scale, and 3D with an 180ms `.easeInOut` opacity change. Keep haptics and functional feedback. Replace `matchedGeometryEffect` with a fast crossfade. Stop ambient loops. Why: stripping all animation makes the app feel broken; iOS itself substitutes crossfades. Check: `@Environment(\.accessibilityReduceMotion)` is read in every custom transition; toggling it changes behaviour.
4. **Reduce Transparency means solid fills.** Every `Material` gets a solid fallback via `@Environment(\.accessibilityReduceTransparency)`. Why: blurred surfaces are unreadable for many low-vision users. Check: toggle the setting; no blur remains.
5. **Increase Contrast is a real pass, not a hope.** Read `@Environment(\.colorSchemeContrast)`; when `.increased`, lift secondary text to at least 4.5:1 and borders to 3:1. Why: your muted tertiary text at 3:1 is invisible to a meaningful share of users. Check: toggle; secondary and tertiary text darken.
6. **VoiceOver reads every screen in a sensible order.** Group rows with `.accessibilityElement(children: .combine)`. Give every image a label or hide it with `.accessibilityHidden(true)` if decorative. Never let the reading order differ from the visual order without a reason. Why: a card that reads "image, 12, chevron, Bank transfer" is not usable. Check: swipe through the screen with VoiceOver; every element says what it is and what it does.
7. **Custom controls carry traits and values.** `.accessibilityAddTraits(.isButton)` on tappable non-buttons; `.accessibilityValue` on anything with a state; `.accessibilityRepresentation { Slider(...) }` on custom sliders and dials so VoiceOver gets the real gestures. Why: a gesture-driven dial is invisible to a screen reader without a representation. Check: every `onTapGesture` on a non-Button has a trait.
8. **Progress dots are hidden; the container carries the value.** `.accessibilityHidden(true)` on the dots, `.accessibilityValue("Step 2 of 4")` on the flow container. Why: five unlabeled circles read as "button, button, button". Check: VoiceOver says "Step 2 of 4" once.
9. **Move focus after a sheet opens or a destructive confirm appears.** `@AccessibilityFocusState` bound to the sheet title or the least destructive action. Why: without it VoiceOver stays on the element behind the sheet. Check: open a sheet with VoiceOver on; the first announcement is the sheet's title.
10. **44×44pt targets.** A 24pt glyph gets padding to 44 and `.contentShape(Rectangle())`. Why: without `.contentShape` only the glyph is tappable. Check: tap the padding around every icon button; it responds.
11. **Colour never carries meaning alone.** Pair with a symbol, a label, or a shape. Honour `@Environment(\.accessibilityDifferentiateWithoutColor)` by adding shapes or labels when it is on. Why: about 8% of men cannot separate red from green. Check: view the screen in greyscale; every status still reads.
12. **Voice Control names match visible labels.** If a button shows "Save", its accessibility label starts with "Save". Why: users say what they see. Check: no `.accessibilityLabel` that renames a visible label.
13. **Bold Text and Button Shapes are supported, not fought.** Read `@Environment(\.legibilityWeight)`; do not hard-code `.regular` on body. With Button Shapes on, plain-text buttons gain an underline; make sure that reads fine. Why: these are system promises; overriding them breaks trust. Check: toggle both; nothing looks broken.
14. **Photos and artwork ignore Smart Invert.** `.accessibilityIgnoresInvertColors()` on images, video, and colour swatches. Why: an inverted photo is an error, not a preference. Check: Smart Invert on; photos stay natural.
15. **Assistive Access is a distinct shape.** If the app opts in, provide a simplified scene with large controls; do not just ship the default. Check: `UISupportsFullScreenInAssistiveAccess` and a tested layout.
16. **Announce what changes off-screen.** `AccessibilityNotification.Announcement("Saved").post()` for outcomes the user cannot see; use it sparingly and never for every keystroke. Check: a save with VoiceOver on says "Saved" once.
17. **Haptics are not gated by motion settings.** Reduce Motion does not turn off haptics; keep firing them. Check: with Reduce Motion on, the press haptic still fires.

## Cheat sheet

| Setting | Environment key | Your response |
|---|---|---|
| Dynamic Type | `dynamicTypeSize` | `ViewThatFits`, stack switch at `.accessibility1`+ |
| Reduce Motion | `accessibilityReduceMotion` | 180ms crossfade, keep haptics, stop loops |
| Reduce Transparency | `accessibilityReduceTransparency` | solid fills replace materials |
| Increase Contrast | `colorSchemeContrast == .increased` | secondary ≥ 4.5:1, borders ≥ 3:1 |
| Differentiate Without Colour | `accessibilityDifferentiateWithoutColor` | add shapes and labels to status |
| Bold Text | `legibilityWeight` | let it flow; no hard-coded regular |
| Smart Invert | none | `.accessibilityIgnoresInvertColors()` on media |
| VoiceOver running | `accessibilityVoiceOverEnabled` | move focus, group rows, announce outcomes |

Targets: 44×44pt. Contrast: body 7:1 (4.5 floor), secondary 4.5:1, UI 3:1.

## Code

Launch arguments for a fast audit scheme:

```
-UIPreferredContentSizeCategoryName UICTContentSizeCategoryAccessibilityXXXL
-UIAccessibilityReduceMotionEnabled 1     // simulator only; prefer Settings on device
```

Reduce Motion aware transition:

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var arrive: Animation { reduceMotion ? .easeInOut(duration: 0.18) : Motion.settle }
var transition: AnyTransition { reduceMotion ? .opacity : .move(edge: .bottom).combined(with: .opacity) }
```

Solid fallback for a material:

```swift
@Environment(\.accessibilityReduceTransparency) private var reduceTransparency

var body: some View {
    content.background {
        if reduceTransparency { Color(.secondarySystemBackground) } else { Rectangle().fill(.regularMaterial) }
    }
}
```

Focus after a sheet opens:

```swift
struct EditSheet: View {
    @AccessibilityFocusState private var titleFocused: Bool
    var body: some View {
        VStack {
            Text("Edit habit").font(.title2.bold()).accessibilityFocused($titleFocused)
            // ...
        }
        .onAppear { titleFocused = true }
    }
}
```

Progress dots:

```swift
HStack(spacing: 8) { ForEach(0..<count, id: \.self) { i in dot(i) } }
    .accessibilityHidden(true)
// on the flow container:
.accessibilityElement(children: .contain)
.accessibilityValue("Step \(index + 1) of \(count)")
```

Custom slider representation:

```swift
CustomDial(value: $ev)
    .accessibilityRepresentation {
        Slider(value: $ev, in: -2...2, step: 0.5) { Text("Exposure") }
    }
```

Row grouping:

```swift
HStack { icon; VStack { title; subtitle }; Spacer(); amount }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(title), \(subtitle), \(amount)")
    .accessibilityAddTraits(.isButton)
```

## Checks

- Run the app at AX5 in German; every screen scrolls, nothing overlaps, every button is reachable.
- Toggle Reduce Motion: transitions crossfade in ~180ms; haptics still fire; ambient loops stop.
- Toggle Reduce Transparency: no blurred surface remains.
- Toggle Increase Contrast: secondary text darkens; hairlines strengthen.
- VoiceOver swipe pass on each screen: order matches visual, every element has a name and a role, sheets take focus.
- Xcode Accessibility Inspector audit on each screen: zero "element has no description" and zero "hit region too small".
- Greyscale screenshot of every status view: all statuses still distinguishable.
- Smart Invert on: photos and swatches unchanged.

## Do not

- Cap Dynamic Type on body content to protect a layout.
- Turn off all animation under Reduce Motion.
- Rename a visible label in `.accessibilityLabel`.
- Ship an `onTapGesture` without a button trait.
- Rely on the default reading order of a custom card.
- Use `accessibilityHidden` to hide something because it was awkward to label.
- Announce every keystroke or every scroll position.
