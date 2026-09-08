# Liquid Glass (iOS 26)

Use this when the project targets iOS 26 and you are adopting, auditing, or restraining Liquid Glass on toolbars, floating buttons, sheets, chips, or custom surfaces.
It does not make an app "glassy". It puts glass exactly where the system puts it and keeps content solid so it stays legible.

## Rules

1. **Glass is for floating controls only.** Toolbars, floating action buttons, chip rows, a composer, a mini player: things that sit above content. Content shows through glass; if the content is also glass, there is nothing to show. Check: every `glassEffect` is on something that floats over scrolling content.
2. **Content stays solid or flat translucent.** Cards, rows, bubbles, and anything with more than two lines of text get an opaque fill or a flat translucent fill with a 0.5pt hairline. A refractive surface behind a paragraph hurts legibility. Check: no `glassEffect` behind body text.
3. **Tint the one primary action.** `.glassEffect(.regular.tint(accent))` on the primary; secondary glass stays clear `.glassEffect(.regular)`. When everything is tinted nothing stands out. Check: one tinted glass control per screen.
4. **`.interactive()` replaces your press style.** It supplies the scale and shimmer on touch. Stacking a custom `ButtonStyle` scale on top doubles the motion. Check: glass buttons use `.buttonStyle(.plain)` or the default, never a scale style.
5. **Never glass on glass.** A glass button inside a glass toolbar inside a glass sheet is mush. One glass layer per stack. Check: walk the view hierarchy; at most one `glassEffect` between content and the finger.
6. **Overlapping or adjacent glass goes in a `GlassEffectContainer`.** It shares blur, lighting direction, and refraction so the pieces read as one material and can merge as they move. Check: any two glass views within about 40pt of each other share a container.
7. **Shape the glass to the control.** `in: .capsule` for bars and pills, `in: .circle` for FABs, `in: .rect(cornerRadius:style: .continuous)` for panels. The default is a capsule. Check: glass shape matches the project's radius ladder.
8. **Let the system do the chrome.** On iOS 26 `TabView`, toolbars, `NavigationStack` bars, and sheets adopt glass automatically. Do not re-implement them with custom blur views. Check: no `UIVisualEffectView` or `.background(.ultraThinMaterial)` on system chrome.
9. **Remove what glass replaces.** Custom blur backgrounds, hand-tuned shadows under floating bars, and press-scale styles on glass controls come out when glass goes in. Check: diff shows deletions, not only additions.
10. **Wrap in availability with a material fallback.** iOS 17–18 get `.regularMaterial` or the project's flat translucent fill in the same shape. Check: build with a deployment target below 26 and run both.
11. **Reduce Transparency gets a solid fill.** Read `accessibilityReduceTransparency` and swap glass for an opaque surface. Check: toggle the setting; every glass control becomes solid and stays legible.
12. **Widgets do not get app glass.** The system renders widget backgrounds on the Home Screen; use `.containerBackground(for: .widget)` and let it decide. Check: no `glassEffect` inside a widget extension.
13. **The app icon is not glass.** The system applies the icon material. Ship flat layered artwork (Icon Composer) and let it render. Check: no baked-in glass highlight in the icon assets.
14. **Glass carries the palette.** Tint faintly toward the project's hue rather than leaving cold grey when the rest of the app is warm, or the reverse. Check: a glass bar over a neutral photo reads as the same family as the cards beneath it.

## Cheat sheet

| Surface | Treatment |
|---|---|
| Floating toolbar, tab bar, nav bar | system glass, automatic |
| FAB, floating chip row, composer | `glassEffect`, one tinted primary |
| Card, row, bubble, sheet body | solid fill or flat translucent + 0.5pt hairline |
| Sheet chrome | system glass, automatic |
| Two glass buttons side by side | inside one `GlassEffectContainer` |
| Widget | `containerBackground(for: .widget)`, no glass |
| App icon | layered artwork, system applies material |
| iOS 17–18 | `.regularMaterial` in the same shape |
| Reduce Transparency | opaque fill |

| Variant | Use |
|---|---|
| `.regular` | default frosted glass |
| `.clear` | mostly transparent, for glass over rich imagery |
| `.identity` | animation endpoint, no-op |
| `.tint(color)` | the one primary |
| `.interactive()` | tappable glass; replaces press styles |

## Code

Glass for floating chrome with a material fallback, and a flat surface for content.

```swift
import SwiftUI

extension View {
    /// Floating chrome. Glass on iOS 26, material before that, solid under Reduce Transparency.
    @ViewBuilder
    func floatingChrome(_ shape: some Shape, tint: Color? = nil, interactive: Bool = false,
                        reduceTransparency: Bool, fallbackFill: Color) -> some View {
        if reduceTransparency {
            self.background(fallbackFill, in: shape)
        } else if #available(iOS 26.0, *) {
            let base = tint.map { Glass.regular.tint($0) } ?? Glass.regular
            self.glassEffect(interactive ? base.interactive() : base, in: shape)
        } else {
            self.background(.regularMaterial, in: shape)
        }
    }

    /// Content surface. Never glass. Flat fill plus a hairline for definition.
    func contentSurface(_ shape: some Shape, fill: Color, hairline: Color) -> some View {
        self.background(fill, in: shape)
            .overlay(shape.stroke(hairline, lineWidth: 0.5))
    }
}
```

A floating bar with one tinted primary, grouped so the pieces share a material.

```swift
struct FloatingBar: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        let chrome = { (view: AnyView, tint: Color?, interactive: Bool) in
            view.floatingChrome(.capsule, tint: tint, interactive: interactive,
                                reduceTransparency: reduceTransparency, fallbackFill: .surfaceFill)
        }
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 12) {
                    HStack(spacing: 12) {
                        chrome(AnyView(secondaryButton), nil, true)
                        chrome(AnyView(primaryButton), .accentColor, true)
                    }
                }
            } else {
                HStack(spacing: 12) {
                    chrome(AnyView(secondaryButton), nil, true)
                    chrome(AnyView(primaryButton), .accentColor, true)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private var primaryButton: some View {
        Button("New") { }
            .padding(.horizontal, 20).padding(.vertical, 12)
            .frame(minHeight: 44)
    }

    private var secondaryButton: some View {
        Button { } label: { Image(systemName: "line.3.horizontal.decrease") }
            .frame(width: 44, height: 44)
    }
}
```

What to delete when adopting glass on a floating control.

```swift
// Before
Button("New") { }
    .padding()
    .background(.ultraThinMaterial, in: Capsule())
    .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
    .buttonStyle(PressableButtonStyle())      // custom 0.97 scale

// After (iOS 26)
Button("New") { }
    .padding()
    .glassEffect(.regular.tint(.accentColor).interactive(), in: .capsule)
// No shadow. No custom press style. The material and .interactive() supply both.
```

## Checks

- Every `glassEffect` sits on something that floats over scrolling content.
- No glass behind more than two lines of text.
- One tinted glass control per screen.
- No custom scale style on a glass button.
- Adjacent glass views share a `GlassEffectContainer`.
- No `UIVisualEffectView` or custom material on system bars.
- Deployment target below 26 builds and looks right with the material fallback.
- Reduce Transparency: every glass surface becomes opaque.
- Widget extension contains no `glassEffect`.
- Icon assets contain no baked highlight.

## Do not

- Make a card, list row, or message bubble glass.
- Tint every glass control; tint one.
- Keep the old shadow under a bar that is now glass.
- Wrap glass in a second blur to "soften" it.
- Put glass over glass to build depth; use spacing and a single hairline.
- Treat glass as a brand feature. It is the system's material; your brand is in the content it floats over.

See also: `references/color.md` for the flat translucent content surface, `references/buttons-and-controls.md` for press styles on non-glass buttons, `references/sheets-and-navigation.md` for what sheets do automatically, `references/accessibility.md` for Reduce Transparency.
