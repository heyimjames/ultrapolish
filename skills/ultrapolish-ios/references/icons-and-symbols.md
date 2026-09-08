# Icons and SF Symbols

Use this when you are choosing, sizing, colouring, or animating icons, or when a screen has glyphs that do not sit right next to their text.
It does not pick an icon family. It makes whichever family the project uses read as one voice, and it keeps icon motion tied to events.

## Rules

1. **One family, one stroke weight, matched to the adjacent text.** SF Symbols weight-match SF Pro automatically when you pass a `Font`; a custom set needs one stroke (1.5–1.7 in a 24 grid is typical) used everywhere. Check: no row mixes SF Symbols with a custom set, and no icon looks heavier or lighter than its label.
2. **Size icons with the text they sit beside.** `Image(systemName:)` inside a `Label` or with `.font(.body)` scales with Dynamic Type. Fixed frames are for icon-only buttons on the 16 / 20 / 24 / 28 grid. Check: change the text size; inline icons grow with the text.
3. **Rendering mode is a hierarchy tool.** `.monochrome` is the default; `.hierarchical` gives depth from one colour for free and is the first polish win on cards; `.palette` only when two colours carry meaning; `.multicolor` only for system symbols whose designed colours are the meaning (weather, battery). Check: one rendering mode per surface.
4. **State changes morph.** `.contentTransition(.symbolEffect(.replace))` for play ↔ pause, heart ↔ heart.fill, eye ↔ eye.slash. It costs nothing and reads as expensive. Check: every symbol driven by a Bool has the transition.
5. **Fill means selected.** Outline at rest, `.fill` variant when active or chosen. Do not invent a third state with colour alone. Check: tab bar and toggles follow outline → fill.
6. **Event motion only.** `.symbolEffect(.bounce, value:)` on a tap that did something; `.rotate` on refresh; `.wiggle` on a refused drop; `.pulse` or `.variableColor` only while a real process is active and only until it ends. Check: every symbol effect answers "what just happened?" with something other than "nothing".
7. **Never an idle loop.** `.breathe`, a repeating `.pulse`, a repeating scale, or `.variableColor` on an icon that is not doing anything is the single most recognisable template tell. Check: grep `.breathe`, `options: .repeating`, and `repeatForever` near `Image(systemName:`.
8. **Pick three to five symbol moments per app and pair each with a haptic.** More than that and motion stops meaning anything. Check: list them; if the list is longer than five, cut.
9. **Never animate a whole row to point at one icon.** The eye picks up motion, not meaning. Isolate the important one. Check: no `ForEach` applies a symbol effect to every child.
10. **Optical sizing is a manual nudge.** A glyph that is visually heavy (a filled circle) reads 1–2pt larger than a light one (a chevron) at the same frame. Match by eye, then fix with `.imageScale` or a 1–2pt frame change. Check: zoom the row to 400%.
11. **Icon in a circle: the shape is the target, the glyph is smaller.** Circle 44 (or 36 for compact), glyph at about 45–50% of the diameter, square glyphs at 92% of what a circle would get. A play triangle nudges 1–2pt right. Check: the glyph looks centred, not is centred.
12. **Directional icons flip in right-to-left.** Back and forward chevrons, text-block glyphs, send, undo/redo flip; logos, checkmarks, clocks, physical objects, and media playback do not. SF Symbols handle this; custom images need `.flipsForRightToLeftLayoutDirection(true)` on the directional ones only. Check: run with an Arabic locale.
13. **Custom symbols are built as symbols, not PNGs.** Export a template from the SF Symbols app, provide the S / M / L optical sizes and the weights the project uses, and add it to the asset catalog as a Symbol Image. Then it weight-matches, scales, and animates like a system symbol. Check: a custom symbol beside `.body` text at AX5 still matches.
14. **Tab bar icons: outline unselected, fill selected, same visual weight across all tabs, one-word labels.** The selected tab does not bounce. Check: all tab glyphs occupy about the same area.
15. **SF Symbols are functional, not the brand.** App icon, hero art, and onboarding illustration are custom artwork. Check: the app icon contains no SF Symbol.

## Cheat sheet

| Item | Default |
|---|---|
| Inline icon | `.font(matching text style)`, no fixed frame |
| Icon-only button glyph | 16 / 20 / 24 / 28 |
| Circle button | 44 (36 compact); glyph 45–50% of diameter |
| Square in circle | 92% of the circle rule |
| Custom stroke | 1.5–1.7 in a 24 grid, one value |
| Rendering | `.monochrome` default, `.hierarchical` for depth |
| State swap | `.contentTransition(.symbolEffect(.replace))` |
| Event | `.symbolEffect(.bounce, value:)` + `.sensoryFeedback` |
| Active process | `.pulse` / `.variableColor.iterative` with `isActive:` |
| Idle | nothing, ever |
| Symbol moments per app | 3–5 |
| Selected | `.fill` variant |
| RTL | directional glyphs flip, objects do not |

## Code

State morph with a paired haptic and a single bounce.

```swift
Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
    .font(.body)
    .contentTransition(.symbolEffect(.replace))
    .symbolEffect(.bounce, value: isSaved)
    .sensoryFeedback(.impact(weight: .light), trigger: isSaved)
```

Active-state indicator that stops when the state ends.

```swift
Image(systemName: "waveform")
    .symbolRenderingMode(.hierarchical)
    .symbolEffect(.variableColor.iterative, isActive: isListening)
```

Icon-only button with a proper target and an optical nudge.

```swift
Button { play() } label: {
    Image(systemName: "play.fill")
        .font(.system(size: 18, weight: .semibold))
        .offset(x: 1)                      // triangle sits visually left; nudge right
        .frame(width: 44, height: 44)
        .contentShape(Circle())
}
.accessibilityLabel("Play")
```

Variable symbol for a real quantity.

```swift
Image(systemName: "speaker.wave.3.fill", variableValue: volume)   // 0...1
```

Directional custom image that flips in RTL.

```swift
Image("chevron.custom")
    .renderingMode(.template)
    .flipsForRightToLeftLayoutDirection(true)
```

Tab bar: outline when unselected, fill when selected, no motion.

```swift
TabView(selection: $tab) {
    LibraryView()
        .tabItem { Label("Library", systemImage: tab == .library ? "books.vertical.fill" : "books.vertical") }
        .tag(Tab.library)
}
```

## Checks

- No screen mixes two icon families in one row.
- Inline icons scale with Dynamic Type; icon-only buttons sit on the 16 / 20 / 24 / 28 grid.
- Every Bool-driven symbol has `.symbolEffect(.replace)`.
- Every symbol effect answers "what just happened?".
- `grep -n "breathe\|repeating\|repeatForever"` returns nothing near an `Image(systemName:`.
- Symbol moments listed and ≤ 5, each with a haptic.
- 400% zoom: glyphs optically centred in their shapes.
- Arabic locale: only directional glyphs flipped.
- Custom symbols scale and weight-match at AX5.
- The app icon is artwork, not a symbol.

## Do not

- Animate an icon to attract attention. An icon attracts attention by being the only thing that is not moving.
- Use `.multicolor` on a UI glyph to make it "pop".
- Change icon weight on selection; it shifts layout. Change fill.
- Import a custom icon as a single PNG and scale it.
- Put an SF Symbol in the app icon or a hero illustration.
- Use a 16pt glyph with a 16pt hit area. The target is 44.

See also: `references/motion.md` for the event-only motion rule, `references/haptics.md` for pairing, `references/layout-and-spacing.md` for optical alignment, `references/accessibility.md` for labels on icon-only buttons.
