# Layout and spacing

Use this when you are structuring a page or component, spacing or aligning controls, deciding what collapses at small sizes, handling safe areas or RTL, or auditing hierarchy.
Pair with `references/typography.md` for measure and `references/surfaces-and-depth.md` for radii and elevation.

## Rules

1. **4px grid, 8px rhythm.** Values: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64. Not an 8-only grid; 12 and 20 are load-bearing for control padding and row gaps. Check: every `gap`, `padding`, and `margin` resolves to a grid value or a named token.
2. **Container padding 16px on mobile, 24px from tablet up.** The same on every page. A page whose margin differs from its neighbours reads as a different site.
3. **The one-second test.** The eye lands on the headline, then the primary action, within a second. If it lands somewhere else first, fix hierarchy before spacing.
4. **Group with space, not lines.** Gap between groups is at least twice the gap within a group: 8px inside, 16px or more between. Tailwind: `space-y-2` inside, `space-y-6` or `space-y-8` between. The eye cannot find group boundaries at 1.5×.
5. **Grouping tool order.** Negative space first, a background shape second, a separator line last and only for dense data. Never a separator and a large gap together; one of them is redundant.
6. **Control clearance.** 12px between adjacent bordered or filled controls. 24px around borderless text or icon buttons, because the space itself is the boundary. 24px or more between unrelated groups.
7. **Inset controls from edges.** Buttons stay inside the layout margin with a visible radius. Edge-to-edge belongs to genuine platform chrome (tab bars, headers) and to content (images, maps), not to controls.
8. **Content bleeds; controls float.** A gallery or map may run to the viewport edge. The buttons over it sit inside the margin and above the safe area.
9. **Hint at hidden content.** A horizontal scroller ends with the next item peeking 16–32px past the edge. A row that ends exactly at the edge looks complete, and nobody scrolls it.
10. **Align to shared edges.** Text aligns leading; numbers align trailing to a shared right edge. One spacing step per level of subordination. Mixed alignment inside a group is the most common "something is off" finding.
11. **One primary per view.** Secondary actions move behind a menu once they exceed three. An entry point with five equal buttons has no entry point.
12. **Safe areas are added to padding, never used as padding.** `padding-bottom: calc(16px + env(safe-area-inset-bottom, 0px))`. `viewport-fit=cover` must be set or `env()` returns 0. For sheets, pad the contents, not the position.
13. **Breakpoints come from content, not devices.** Collapse late; hold the structure until it actually breaks. Prefer container queries so a component adapts to the space it has, not the viewport it guesses. Test 320px and the largest size first.
14. **Logical properties by default.** `padding-inline`, `margin-inline-start`, `inset-inline-end`, `text-align: start`, `border-inline-end`. Physical properties only for notch geometry and physical gesture direction.
15. **Plan for i18n.** No fixed widths sized to English. Buttons size from `padding-inline`, never a hardcoded width. `min-height` rather than `height`. No single universal expansion percentage; test with German and Finnish.
16. **Clipping rules.** Nothing critical sits at the bottom of a resizable pane, below the fold of a fixed-height modal, or under the on-screen keyboard. If a modal's content scrolls, its action row does not.
17. **Radii are concentric.** `outerRadius = innerRadius + padding`. A card at 16px with 8px padding holds children at 8px. Above 24px of padding, treat the layers as separate surfaces and stop calculating. See `references/surfaces-and-depth.md`.
18. **Design for two items and for two hundred.** Every list, grid, and tag row is checked empty, with one item, with two, and with an overflowing count. A 60-character title and a four-line description must fit.
19. **A page that anyone will print or save as PDF needs a print stylesheet, and most content pages do.** Receipts, invoices, itineraries, recipes, tickets and documentation all get printed by someone. `@media print`: force a light ground regardless of the theme, because a dark-mode page prints as a solid block of ink; drop the navigation, the cookie bar, the chat widget and anything sticky; set `break-inside: avoid` on cards, tables and figures so nothing is sliced across a page; and expand link destinations with `a[href^="http"]::after { content: " (" attr(href) ")" }` in long-form only, where a URL nobody can click is otherwise lost. Check: print to PDF in dark mode and read the result.
20. **Print reveals what is genuinely fixed.** Anything `position: fixed` renders once, at the top, over the content. This is the usual reason a printed page has a navigation bar stamped across the middle of it. Set `position: static` for print on every fixed element rather than hiding them one at a time as they are discovered. Check: print a long page and look at every page break, not just the first.
21. **Reveal complexity, do not dump it.** One primary action per view; everything a person does not need yet appears when it becomes relevant. A twelve-field form is three steps of four. An advanced section is closed until asked for. This is not about having fewer features, it is about how many of them are on screen at once, and the test is whether someone can tell within a second what to do next. Complexity that is genuinely needed is not hidden behind a gesture nobody will find: progressive disclosure needs a visible affordance, and content with no cue may as well not exist. Check: count the actions competing for attention on the primary screen; if it is more than one, name which is primary and demote the rest.

## Cheat sheet

| Situation | Value |
|---|---|
| Grid step | 4px; rhythm 8px |
| Container padding | 16px mobile, 24px tablet+ |
| Inside a group | 8px |
| Between groups | 16px+ (≥ 2× inside) |
| Adjacent filled controls | 12px |
| Around borderless controls | 24px |
| Between unrelated groups | 24px+ |
| Peek past a scroll edge | 16–32px |
| Prose measure | 65ch |
| Section rhythm | 48px or 64px |

| Physical | Logical |
|---|---|
| `margin-left` | `margin-inline-start` |
| `padding-right` | `padding-inline-end` |
| `left: 0` | `inset-inline-start: 0` |
| `text-align: left` | `text-align: start` |
| `border-right` | `border-inline-end` |
| `float: left` | `float: inline-start` |

## Code

Peeking horizontal scroller:

```css
.scroller {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding-inline: 24px;
  scroll-padding-inline: 24px;
  scroll-snap-type: x mandatory;
  overscroll-behavior-x: contain;
}
.scroller > * {
  flex: 0 0 calc(100% - 72px); /* 24px margin each side + 24px peek */
  scroll-snap-align: start;
}
```

Full-bleed grid:

```css
.page {
  display: grid;
  grid-template-columns: 1fr min(65ch, calc(100% - 48px)) 1fr;
}
.page > * { grid-column: 2; }
.page > .full-bleed { grid-column: 1 / -1; }
```

Safe areas added to padding:

```css
.sticky-actions {
  position: sticky;
  bottom: 0;
  padding: 12px 16px calc(12px + env(safe-area-inset-bottom, 0px));
}
.fab {
  inset-inline-end: calc(16px + env(safe-area-inset-right, 0px));
  bottom: calc(16px + env(safe-area-inset-bottom, 0px));
}
```

```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
```

Container query instead of a viewport breakpoint:

```css
.card-list { container-type: inline-size; }
.card { display: grid; grid-template-columns: 1fr; }
@container (min-width: 480px) {
  .card { grid-template-columns: 96px 1fr; }
}
```

Concentric radii:

```css
.card { --r: 16px; --p: 8px; border-radius: var(--r); padding: var(--p); }
.card > .media { border-radius: calc(var(--r) - var(--p)); }
```

Modal whose actions never scroll away:

```css
.dialog { display: grid; grid-template-rows: auto 1fr auto; max-height: 90dvh; }
.dialog > .body { overflow-y: auto; overscroll-behavior: contain; }
```

Tailwind mapping: `p-4 md:p-6` containers, `space-y-2` inside / `space-y-6` between, `gap-3` between controls, `ps-6 pe-6` for logical padding, `text-start`, `@container` with `@md:` variants, `max-w-prose`.

## Checks

- Every spacing value is a grid step or a token; grep for odd pixel values.
- Container padding identical across pages at each breakpoint.
- Squint test: groups read as groups; no separator sits next to a large gap.
- Every horizontal scroller shows a peek on a 375px viewport.
- Width 320px: single column, no horizontal scroll, buttons fully visible.
- RTL (`dir="rtl"`): chevrons flip, text aligns start, nothing pinned with `left`.
- German labels: no clipped buttons, no wrapped tab labels.
- Modal with long content: action row visible without scrolling.
- Phone with a home indicator: sticky actions clear the safe area.
- Empty, one, two, and two hundred items rendered for every collection.

## Do not

- Use an 8-only grid and then invent 10 and 14 to make things fit.
- Add a divider where a gap already separates.
- Use `env(safe-area-inset-*)` as the whole padding.
- Pick 768 and 1024 because they are familiar.
- Hardcode a button width to fit English.
- Put a submit button at the bottom of a scrolling modal body.
- Let a card's inner radius equal its outer radius.
