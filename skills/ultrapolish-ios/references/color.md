# Colour and material

Use this when you are defining, auditing, or fixing colour tokens, dark mode, gradients, shadows, or translucent surfaces in a SwiftUI app.
It does not pick a palette. It makes the project's palette hold together in both appearances and on wide-gamut screens.

## Choosing the palette

The rules below tune a palette. This chooses one. Do it first, and only when the project has no palette already: if it has one, your job is to make it consistent, not to replace it.

**1. Name the subject before you name a hue.** Write one sentence about what the product is for, then pick the hue family a stranger would agree carries it. A tool for photographers wants a ground that does not tint the work, so near-neutral with a trace of warmth and a single decisive accent. A finance tool wants a hue that reads as steady rather than urgent, which rules out anything within about 30 degrees of the danger colour. A product about being outdoors can afford a hue drawn from the thing itself. Write the sentence into the design contract; a palette nobody can justify in one line is a palette that drifts.

**2. Neighbours read as a family, opposites read as an argument.** Hues within about 60 degrees of each other belong to one system. Hues 180 degrees apart read as two systems fighting for the same screen, which is why the complementary pairs that work on a colour wheel usually fail in an interface. Pick a primary, then take the rest of the set as steps around it in one direction. Semantic colours are the exception and must sit at least 25 degrees off the accent, or a success message gets mistaken for a primary action.

**3. Every hue in the set shares one lightness ramp and one chroma percentage.** Not one absolute chroma. Cyan runs out of gamut near C 0.09 at mid lightness where purple is still climbing past 0.29, so identical numbers give wildly unequal colour and the set looks arbitrary. Fix each rung's L (95 / 88 / 75 / 60 / 45 / 30 is a reasonable start), then set each hue's chroma to the same percentage of its own gamut edge at that L. This is the only reason a chart legend reads as one system rather than six unrelated colours.

**4. Muddy is almost always chroma set too low, not too high.** The instinct when a palette looks cheap is to desaturate, and that is the move that made it muddy. A colour at mid lightness with chroma well inside its gamut edge has no identity: it reads as a grey someone tinted by accident. Push chroma to the gamut edge for that lightness, then step back about 5% for safety, and judge it there. Two other things cause mud: interpolating between colours in sRGB rather than OKLCH, which drags saturated pairs through grey at the midpoint, and hues in the 90 to 110 degree band, where yellow-green goes olive fast as lightness drops.

**5. Check the set as a set, not swatch by swatch.** Render every hue at every rung as one grid, in both themes, and look for the one that jumps forward or sinks back. That one is off the shared chroma percentage. Then desaturate the whole grid to greyscale: rungs that were meant to be the same L should now be indistinguishable, and any that are not will be the ones misbehaving in charts and in dark mode.

## Rules

1. **Pick in OKLCH, ship in Display P3, fall back to sRGB automatically.** OKLCH keeps lightness and chroma perceptually honest; P3 is what every iPhone since 7 displays. `Color(red:green:blue:)` with no colour space silently produces sRGB, which is the most common wide-gamut bug. Check: grep for `Color(red:` and `Color(hex:` and confirm each passes `.displayP3`.
2. **Every colour is a light/dark pair, hand-tuned per mode.** A derived dark palette (invert, or multiply) shifts hue and collapses hierarchy. The number: lower L, hold C and H, then adjust by eye in both appearances. Check: toggle appearance on every screen and confirm every text-on-surface pair still reads.
3. **Secondary text is one ink stepped in opacity.** Then dark mode flips one base colour and the whole hierarchy follows. Defaults: primary 1.0, secondary 0.62, tertiary 0.45, quaternary 0.28, hairline 0.10. Check: there is one `ink` token and no second grey text colour.
4. **Contrast targets are numbers, not vibes.** Body ≥ 7:1 (4.5:1 floor), secondary ≥ 4.5:1, tertiary and UI glyphs ≥ 3:1. In dark mode lift accent L by about 0.06 so it holds ≥ 3:1 on the dark base. Check: measure with Xcode's Accessibility Inspector colour contrast calculator on the darkest surface each token appears over.
5. **One accent per view, with one meaning.** A hue within ±15° of the accent on something non-interactive tells users to tap it. Primary colour goes on the background of the primary action, not its label. Check: count filled coloured controls per screen; the answer is one.
6. **Gradients get explicit OKLCH stops.** SwiftUI interpolates in linear RGB; yellow to blue passes through grey, and any two saturated endpoints muddy in the middle. Compute 5–8 stops in OKLCH with the short-way hue and pass them as `colors:`. Check: screenshot the gradient midpoint and compare its chroma to the endpoints.
7. **Grain kills banding.** A flat gradient on OLED shows visible steps. Overlay tileable noise at ≤ 5% opacity with `.blendMode(.overlay)`. If you can see grain, it is too much. Check: view the gradient in a dark room at low brightness.
8. **Shadows are faint and never pure black at full opacity.** Three tiers: subtle `0.06 / radius 8 / y 4`, lift `0.12 / 16 / 8`, floating `0.18 / 24 / 12`. In dark mode shadows vanish into the background; use a 1pt `.white.opacity(0.06)` inner stroke for elevation instead. Check: every `.shadow(` has an opacity ≤ 0.18 and a dark-mode counterpart.
9. **True black is a decision, not a default.** Use `#000000` only for media-first chrome (camera, photo, video) or when the design contract records an OLED decision. Otherwise the dark base is near-black carrying the palette's hue (L ≈ 0.15–0.22). Check: the design contract row 4 says which.
10. **Materials belong on floating chrome only.** A refractive or blurred surface behind a paragraph of text hurts legibility. Content (cards, rows, bubbles) gets a solid fill or a flat translucent fill plus a 0.5pt hairline. Check: no `.ultraThinMaterial` or `glassEffect` behind more than two lines of text.
11. **Test every translucent colour over the lightest and darkest content that can scroll behind it.** A chip that reads over a white list vanishes over a photo. Check: scroll a hero image and a blank list under each floating control.
12. **Extensions need dual-mode tokens too.** Widgets, Live Activities, and Share extensions do not inherit the app's asset catalog unless the catalog is shared. The classic bug is fixed near-black ink on a background the system swaps to dark. Check: run each extension in both appearances.
13. **Meaning never rides on colour alone.** Pair every status colour with a symbol or a word. Check: view the screen in greyscale (Settings › Accessibility › Display › Colour Filters).

## Cheat sheet

| Item | Default | Note |
|---|---|---|
| Colour space | Pick OKLCH, ship `.displayP3` | sRGB fallback is automatic |
| Ink hierarchy | 1.0 / 0.62 / 0.45 / 0.28 / hairline 0.10 | one base per appearance |
| Contrast | body 7:1 (4.5 floor), secondary 4.5:1, UI 3:1 | measure on the darkest surface |
| Dark accent lift | L + 0.06 | holds ≥ 3:1 |
| Dark base lightness | L ≈ 0.15–0.22, hue from the palette | true black only by decision |
| Gradient stops | 5–8, computed in OKLCH | never two-stop RGB |
| Grain | ≤ 5% opacity, `.overlay` | invisible as texture |
| Shadow subtle | `.black.opacity(0.06)`, r 8, y 4 | |
| Shadow lift | `0.12`, r 16, y 8 | |
| Shadow floating | `0.18`, r 24, y 12 | |
| Dark elevation | 1pt `.white.opacity(0.06)` inner stroke | shadows do not read on dark |
| Hairline | 0.5pt at ink 10% | replaces borders on content |
| Accent proximity | ±15° hue | anything closer reads as interactive |
| Materials | floating chrome only, 2–3 per screen | content stays flat |

## Code

Dual-mode Display P3 tokens. Design in OKLCH, bake to hex once, define every colour as a pair.

```swift
import SwiftUI
import UIKit

extension Color {
    /// Display P3 from 0xRRGGBB.
    static func p3(_ hex: UInt32, _ alpha: Double = 1) -> Color {
        Color(.displayP3,
              red: Double((hex >> 16) & 0xFF) / 255,
              green: Double((hex >> 8) & 0xFF) / 255,
              blue: Double(hex & 0xFF) / 255,
              opacity: alpha)
    }

    /// Light/dark pair. Both values are hand-tuned; nothing is derived.
    static func p3d(_ light: UInt32, _ dark: UInt32, _ alpha: Double = 1, darkAlpha: Double? = nil) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(Color.p3(dark, darkAlpha ?? alpha))
                : UIColor(Color.p3(light, alpha))
        })
    }
}

/// Example token set. Values are placeholders; the project supplies its own.
enum Tokens {
    static let base     = Color.p3d(0xFFFFFF, 0x161616)   // example
    static let ink      = Color.p3d(0x1A1A1A, 0xEDEDED)   // example
    static let accent   = Color.p3d(0x2F6FDB, 0x5C8FEB)   // example: dark is L + 0.06
    static let hairline = ink.opacity(0.10)
    static var secondary: Color { ink.opacity(0.62) }
    static var tertiary: Color  { ink.opacity(0.45) }
}
```

OKLCH to `Color`, and a ramp for gradient stops. The maths is the standard OKLab transform; the output is linear sRGB clamped to gamut.

```swift
enum OKLCH {
    /// L 0...1, C roughly 0...0.4, H in degrees.
    static func color(_ L: Double, _ C: Double, _ H: Double, opacity: Double = 1) -> Color {
        let h = H * .pi / 180
        let a = C * cos(h), b = C * sin(h)
        let l_ = L + 0.3963377774 * a + 0.2158037573 * b
        let m_ = L - 0.1055613458 * a - 0.0638541728 * b
        let s_ = L - 0.0894841775 * a - 1.2914855480 * b
        let l = l_ * l_ * l_, m = m_ * m_ * m_, s = s_ * s_ * s_
        let r  =  4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
        let g  = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
        let bl = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
        func clamp(_ x: Double) -> Double { min(1, max(0, x)) }
        return Color(.sRGBLinear, red: clamp(r), green: clamp(g), blue: clamp(bl), opacity: opacity)
    }

    /// Interpolate two OKLCH endpoints into `stops` colours. Hue takes the short way round.
    static func ramp(_ a: (L: Double, C: Double, H: Double),
                     _ b: (L: Double, C: Double, H: Double),
                     stops: Int = 6) -> [Color] {
        var endH = b.H
        if abs(endH - a.H) > 180 { endH += (endH > a.H ? -360 : 360) }
        let n = max(2, stops)
        return (0..<n).map { i in
            let t = Double(i) / Double(n - 1)
            return color(a.L + (b.L - a.L) * t, a.C + (b.C - a.C) * t, a.H + (endH - a.H) * t)
        }
    }
}

// LinearGradient(colors: OKLCH.ramp((0.70, 0.12, 40), (0.55, 0.14, 300)), startPoint: .top, endPoint: .bottom)
```

Grain overlay and dark-mode elevation.

```swift
extension View {
    /// Tileable noise at 4% to stop OLED banding. `noise` is a 256×256 asset.
    func grain(_ opacity: Double = 0.04) -> some View {
        overlay(
            Image("noise")
                .resizable(resizingMode: .tile)
                .opacity(opacity)
                .blendMode(.overlay)
                .allowsHitTesting(false)
        )
    }

    /// Shadow in light, hairline in dark. Pass the project's radius.
    func elevated(radius: CGFloat, scheme: ColorScheme) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        return self
            .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.06), radius: 8, y: 4)
            .overlay(shape.stroke(.white.opacity(scheme == .dark ? 0.06 : 0), lineWidth: 1))
    }
}
```

Flat translucent content surface (the alternative to a material behind text).

```swift
extension View {
    func contentSurface(_ shape: some Shape, fill: Color, hairline: Color) -> some View {
        background(fill, in: shape)
            .overlay(shape.stroke(hairline, lineWidth: 0.5))
    }
}
```

## Checks

- Every `Color(` literal names `.displayP3` or goes through `p3` / `p3d`.
- One `ink` token; secondary and tertiary are opacities of it.
- Contrast measured on the darkest surface each token appears over, in both appearances.
- Every gradient has ≥ 5 stops and a grain overlay.
- Every `.shadow(` opacity ≤ 0.18 and paired with a dark-mode hairline.
- No material or glass behind more than two lines of text.
- Each extension target compiled and viewed in both appearances.
- Greyscale pass: every status still readable.

## Do not

- Derive dark mode by inversion or by multiplying the light palette.
- Use `.gray`, `.secondary`, and a custom muted token in the same app; pick one system.
- Put two filled accent controls on one screen.
- Use a two-stop gradient between saturated colours.
- Use a warm or cool tinted shadow at opacity above 0.18; it reads as dirt.
- Ship true black without writing the decision into the design contract.
- Tint a material grey when the project's palette has a hue; the fill should carry the hue.

See also: `references/typography.md` for text colour hierarchy, `references/liquid-glass.md` for iOS 26 materials, `references/widgets-and-live-activities.md` for render modes that override your colours.
