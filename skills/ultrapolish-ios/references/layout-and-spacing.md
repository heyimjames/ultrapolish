# Layout, spacing and hierarchy

Use this when you are placing things on a screen: margins, gaps, radii, alignment, what goes first, what hides behind a menu, and what happens at the edges.
It does not pick a density. It makes the project's density consistent and its hierarchy legible in one glance.

## Rules

1. **4pt grid, 8pt rhythm.** Every spacing value comes from 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64. Not an 8-only grid: 12 is the natural gap inside a control and 20 is the most common screen margin. Check: grep `.padding(` and `spacing:` for values off the list.
2. **One screen margin, everywhere.** Pick 16, 20, or 24 and use it on every screen. Content that starts at a different x on each screen reads as several apps. Check: overlay two screenshots; the left edges of content align.
3. **Hero numbers want 24pt of air above and below.** Not 12, not 16. Large figures need room or they crowd their labels. Check: measure the gap around the biggest number on screen.
4. **Group by space, not lines.** The gap between groups is at least 2× the gap within a group: 8 inside, 16 or more between. A separator is for dense data only, and never combined with a large gap. Check: find every `Divider()` and ask whether space would do.
5. **Controls get clearance.** 12pt between adjacent filled controls; 24pt around borderless icon buttons; 24pt or more between unrelated groups. The space is the boundary. Check: no two tappable things closer than 12pt.
6. **Three radii at most, all `.continuous`.** Small (chips, inputs), medium (cards, sheets), large (hero surfaces). A nested corner is `outer − padding`. Above 24pt of padding, stop calculating and treat the layers as separate surfaces. Check: list every `cornerRadius:` value; three distinct numbers.
7. **Optical alignment beats mathematical alignment.** A square inside a circle renders at 92% of the circle's diameter to look equal. Icons next to text nudge 0.5–1pt. A play triangle in a circle sits 1–2pt right. A numeral in a circular gauge sits slightly high. Check: zoom the screenshot to 400% and look.
8. **Safe areas are added to padding, never used as padding.** `.safeAreaInset(edge: .bottom)` for sticky CTAs so content scrolls under them; `.contentMargins` for scroll content under floating chrome. Check: rotate to landscape and switch to an SE-sized device; nothing touches the edge or hides behind the home indicator.
9. **Content bleeds, controls float.** A horizontal strip may run edge to edge; buttons stay inside the margin with a visible radius. Check: no button touches a screen edge.
10. **One primary action per view.** The eye lands on the headline, then the primary, within a second. If it does not, the hierarchy is wrong. Check: squint at the screen; the first two things you see are the headline and the primary.
11. **Secondary actions go behind a menu once they exceed three.** A row of five icon buttons is a puzzle. Check: count visible actions per view.
12. **Design for two items and for two hundred.** Lists that look right with six items must also look right empty, with one, and with a thousand. Check: run with a fake data flag at 1, 2, and 200.
13. **Nothing critical under the keyboard or below a fixed sheet's fold.** If a sheet's content scrolls, its action row does not. Check: open every form with the keyboard up.
14. **Widths come from content, not from English.** Buttons size from padding, never a fixed width. Use `minHeight` not `height`. Check: German and Finnish previews.
15. **Density is per platform.** iPhone tap targets are 44pt; iPad pointer and Mac targets can drop to 24pt, and inspector panes run tighter (12pt padding). Check: the same view on iPhone and Mac uses the platform's density, not the phone's.

## Cheat sheet

| Item | Default |
|---|---|
| Grid | 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64 |
| Screen margin | 20 (16–24 acceptable), same everywhere |
| Card padding | 16 (12–16) |
| In-row spacing | 8–12 |
| Section gap | 24–32 |
| Hero air | 24 above and below |
| Group rule | between ≥ 2× within |
| Control clearance | 12 filled / 24 borderless |
| Radii | ≤ 3 values, `.continuous`, nested = outer − padding |
| Radius cap for nesting | stop above 24pt padding |
| Square in circle | 92% of diameter |
| Icon nudge | 0.5–1pt |
| Play triangle | 1–2pt right |
| Tap target | 44 iPhone / 24 pointer |
| Sticky CTA | `.safeAreaInset(edge: .bottom)` + `.background(.bar)` |

## Code

Named spacing so the grid is enforced by the compiler, not by memory.

```swift
enum Space {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let section: CGFloat = 32
    static let screen: CGFloat = 20     // the one margin
}

enum Radius {
    static let small: CGFloat = 10
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static func nested(in outer: CGFloat, padding: CGFloat) -> CGFloat {
        padding > 24 ? small : max(2, outer - padding)
    }
}
```

Concentric card with a nested image.

```swift
VStack(spacing: Space.m) {
    image
        .clipShape(RoundedRectangle(cornerRadius: Radius.nested(in: Radius.large, padding: Space.l), style: .continuous))
    Text(title).font(.headline)
}
.padding(Space.l)
.background(Color.cardFill, in: RoundedRectangle(cornerRadius: Radius.large, style: .continuous))
```

Full-bleed strip inside a padded screen, with the scroll content still inset.

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: Space.m) { cards }
}
.contentMargins(.horizontal, Space.screen, for: .scrollContent)
.padding(.horizontal, -Space.screen)   // cancels the parent's margin so the strip bleeds
```

Sticky CTA that content scrolls under, with the safe area added.

```swift
ScrollView { content }
    .safeAreaInset(edge: .bottom) {
        Button("Continue") { next() }
            .buttonStyle(.primary)
            .padding(.horizontal, Space.screen)
            .padding(.top, Space.m)
            .background(.bar)
    }
```

Scroll content that starts below floating chrome.

```swift
ScrollView { rows }
    .contentMargins(.top, topBarHeight, for: .scrollContent)
```

Optical alignment of a square glyph in a circle.

```swift
ZStack {
    Circle().fill(.tint)
    Image(systemName: "square.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 44 * 0.92 * 0.5)   // 92% rule, then the glyph's own inset
        .offset(x: 0.5)
}
.frame(width: 44, height: 44)
```

Stress preview.

```swift
#Preview("200 items") {
    ListView(items: Item.fakes(200))
}
#Preview("2 items, SE") {
    ListView(items: Item.fakes(2))
        .previewDevice("iPhone SE (3rd generation)")
}
```

## Checks

- Every spacing value is on the grid.
- Left edge of content aligns across every screen.
- The biggest number has 24pt above and below.
- Group gaps ≥ 2× inner gaps; each `Divider()` justified.
- ≤ 3 radii; nested corners computed.
- Zoom to 400%: icons and squares sit optically centred.
- SE-sized device, landscape, keyboard up: nothing hidden, nothing touching an edge.
- 1, 2, and 200 items all look designed.
- One primary per view; secondary actions ≤ 3 visible.

## Do not

- Add a fourth radius because one component "needs" it. Reuse the nearest.
- Use `Spacer()` where a named gap would do; spacers hide intent.
- Put a hairline and a 24pt gap between the same two groups.
- Use `.ignoresSafeArea()` on content; only on backgrounds.
- Fix a layout at one text size with `.frame(width:)`.
- Copy iPhone margins and 44pt targets into an iPad sidebar or a Mac inspector.

See also: `references/typography.md` for the type spine, `references/buttons-and-controls.md` for sizes and hit areas, `references/sheets-and-navigation.md` for sheet radii and detents.
