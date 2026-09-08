# Typography

Use this when you are setting up a type scale, auditing text hierarchy, fixing truncation or clipping, or making numbers and labels behave under Dynamic Type.
It does not choose a typeface. It makes whatever face the project uses read as one system at every size.

## Rules

1. **Use the Dynamic Type styles; hard-code sizes only for hero numerals and non-scaling chrome.** Semantic styles scale with the user's setting and stay consistent across screens. Check: grep for `.system(size:` and justify each one.
2. **Three sizes carry the hierarchy.** The spine for most apps is 17 / 22 / 28 (`.body`, `.title2`, `.title`). Weight and opacity do the rest. More sizes means more decisions per screen and less rhythm. Check: count distinct sizes on one screen; four or more is a finding.
3. **Emphasis within a role is one weight step, not a size change.** Body regular to body semibold, never body to headline-sized. Check: emphasised words share the size of the text around them.
4. **Do not override SF Pro tracking.** Apple tunes it per size. Exceptions: all-caps labels +1.2 to +2.0pt; display text at 60pt and above −0.5 to −1.5pt. Check: grep `.tracking(` and `.kerning(`; each use is one of the two exceptions.
5. **Line height by role.** Body 1.3–1.4×, prose paragraphs 1.45–1.5× and never tighter than 1.45 for three or more lines, headlines 1.15×, display 28pt+ 1.1–1.2×. In SwiftUI set `.lineSpacing(size × (multiplier − 1.2))` since the default already sits near 1.2. Check: a three-line paragraph does not feel cramped.
6. **Body text is leading-aligned.** Centre only single-line headlines and hero numerals. Centred paragraphs make every line start in a different place. Check: no `.multilineTextAlignment(.center)` on text that can wrap past two lines.
7. **Weight floors.** Nothing below `.regular` under 18pt. Weights under `.regular` are display-only at 28pt and above. Thin text at small sizes breaks up on the screen. Check: `.light`, `.thin`, `.ultraLight` appear only with sizes ≥ 28.
8. **Changing numbers are monospaced.** `.monospacedDigit()` on every counter, timer, price, and score, plus `.contentTransition(.numericText(value:))`. Otherwise the layout shifts when 99 becomes 100. Check: watch a number change; nothing around it moves.
9. **Hero numerals get `.minimumScaleFactor(0.7)` and `lineLimit(1)`.** A 48pt figure that reads "1,240" in English reads "1 240 000" elsewhere. Check: set the largest plausible value and Dynamic Type AX5.
10. **Variable strings get `ViewThatFits`.** Offer the full label, a shorter variant, then a symbol. Truncation with an ellipsis is the last resort, not the plan. Check: run in German and Finnish with AX5.
11. **Custom faces keep Dynamic Type.** `.font(.custom("Name", size: 17, relativeTo: .body))`. A custom font with a fixed size is an accessibility failure and a visual one. Check: change the text size setting and confirm the custom face scales.
12. **Cap scaling only on chrome.** `.dynamicTypeSize(...DynamicTypeSize.xxxLarge)` belongs on tab labels and toolbar items that would break layout, never on content. Check: content views have no cap.
13. **Never rasterise text.** Text inside an `Image`, a `Canvas`, or a `drawingGroup()` does not scale, select, or read to VoiceOver. Check: hero art that contains words is built from `Text`.
14. **All-caps is a house choice.** If the contract uses it: 11–13pt, `.semibold` or `.medium`, tracking +1.2 to +2.0pt, secondary colour. If the contract does not mention it, do not introduce it. Check: design contract row 2.
15. **Readouts that update rapidly use tabular or mono digits.** ISO, shutter, timers, and any value that ticks jitter with proportional digits. Check: watch the readout during change.
16. **Optical sizes matter above 20pt.** SF Pro switches from Text to Display automatically in the system font; custom faces with `opsz` axes need `font-optical-sizing` equivalents or separate files. Check: the same face at 13 and 34 does not look like two fonts.

## Cheat sheet

| Style | Size | Weight | Role |
|---|---|---|---|
| `.largeTitle` | 34 | bold | Screen title at top level |
| `.title` | 28 | bold | Section hero |
| `.title2` | 22 | bold | Card and sheet titles |
| `.title3` | 20 | semibold | Sub-sections |
| `.headline` | 17 | semibold | Row titles, emphasis |
| `.body` | 17 | regular | Prose, row content |
| `.callout` | 16 | regular | Secondary prose |
| `.subheadline` | 15 | regular | Supporting text |
| `.footnote` | 13 | regular | Metadata, timestamps |
| `.caption` | 12 | regular | Labels |
| `.caption2` | 11 | regular | Floor |

| Rule | Value |
|---|---|
| Spine | 17 / 22 / 28 |
| Emphasis | one weight step |
| Tracking | untouched; caps +1.2 to +2.0; 60pt+ −0.5 to −1.5 |
| Line height | body 1.3–1.4×, prose ≥ 1.45×, headline 1.15×, display 1.1–1.2× |
| Weight floor | `.regular` under 18pt; light weights only ≥ 28pt |
| Hero numeral | `.monospacedDigit()`, `.minimumScaleFactor(0.7)`, `lineLimit(1)` |
| Alignment | leading; centre only single-line headlines and numerals |
| Test sizes | `.accessibility5`, German, Finnish |

## Code

Mixed-weight headline with one emphasised phrase. Concatenation keeps it one `Text`, so it wraps and reads as one line.

```swift
Text("Your week, ")
    .font(.title)
    .fontWeight(.regular)
+ Text("in one place")
    .font(.title)
    .fontWeight(.semibold)
```

Hero numeral that never shifts layout or clips.

```swift
Text(total, format: .number)
    .font(.system(size: 48, weight: .semibold))
    .monospacedDigit()
    .lineLimit(1)
    .minimumScaleFactor(0.7)
    .contentTransition(.numericText(value: Double(total)))
    .animation(.snappy(duration: 0.24), value: total)
```

Variable-length label with graceful fallbacks.

```swift
ViewThatFits(in: .horizontal) {
    Label("Mark as complete", systemImage: "checkmark.circle")
    Label("Complete", systemImage: "checkmark.circle")
    Image(systemName: "checkmark.circle")
        .accessibilityLabel("Mark as complete")
}
```

Custom face with Dynamic Type, and a cap for chrome only.

```swift
extension Font {
    static func brand(_ style: Font.TextStyle, size: CGFloat) -> Font {
        .custom("ProjectFace-Regular", size: size, relativeTo: style)   // example name
    }
}

// Tab bar label: cap so the bar never breaks. Content is never capped.
Text("Library")
    .font(.caption)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
```

Line height for prose.

```swift
Text(paragraph)
    .font(.body)                 // 17pt
    .lineSpacing(17 * 0.28)      // roughly 1.48× total
    .multilineTextAlignment(.leading)
```

Preview at the sizes that break things.

```swift
#Preview("AX5, German") {
    ContentView()
        .environment(\.dynamicTypeSize, .accessibility5)
        .environment(\.locale, Locale(identifier: "de"))
}
```

## Checks

- Distinct sizes on one screen ≤ 3 plus captions.
- No `.tracking` outside the two exceptions.
- Every changing number is `.monospacedDigit()`.
- AX5 preview: nothing clips, nothing overlaps, every label still fits or falls back.
- German preview: no truncated button.
- Custom fonts scale with the text size setting.
- No text baked into images.
- Paragraphs are leading-aligned and have ≥ 1.45× line height.

## Do not

- Introduce a second face because a heading "needs character". That is a design contract decision, not a polish decision.
- Use `.system(size:)` for anything a Dynamic Type style could express.
- Use `.bold` on body text for emphasis when `.semibold` is the project's heaviest weight.
- Centre a paragraph.
- Fix a truncation by shrinking the whole label with `minimumScaleFactor` below 0.7; write a shorter variant.
- Use letter-spacing to fit text; cut words instead.

See also: `references/color.md` for the ink hierarchy, `references/layout-and-spacing.md` for margins and air around text, `references/copy-and-naming.md` for the words themselves.
