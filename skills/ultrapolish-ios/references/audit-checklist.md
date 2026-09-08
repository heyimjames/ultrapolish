# Audit checklist

Use this when running a quick or full audit, or as the definition of done before a release. Every row says how to verify it in under a minute. ★ marks the quick-audit set.

## The one-hour audit, in order

1. 5 min: intake table (see SKILL.md §1.1). Grep for tokens, springs, radii, padding.
2. 5 min: run at AX5 in German; screenshot every screen.
3. 5 min: toggle Reduce Motion and Reduce Transparency; walk the primary path.
4. 10 min: VoiceOver swipe pass on the three most-used screens.
5. 10 min: force every state: empty, loading (throttle network), error (airplane mode), success, overflow (200 items).
6. 10 min: motion pass at 10% speed (Debug > Slow Animations in the simulator); watch sheet in/out, push/pop, and the hero.
7. 5 min: dark mode pass on every screen; check shadows and hairlines.
8. 5 min: tap every icon button in its padding; press every button and feel for the haptic.
9. 3 min: read every button label, error, and empty state aloud.
10. 2 min: write the findings table, grouped by root cause.

## States

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Empty state exists for every list, search, and filter, with one action | Clear data; search for "zzz"; apply a filter with no matches | HIGH |
| ★ Loading follows the ladder; nothing spins under 500ms | Network Link Conditioner at 3G; time the first spinner | MEDIUM |
| ★ Error appears in context with the last good value still visible | Airplane mode mid-fetch; look where the error lands | HIGH |
| Success is acknowledged once, where the result appears | Complete an action; count feedback events | LOW |
| Offline state exists and cached content stays usable | Airplane mode, relaunch | MEDIUM |
| First-run state differs from the empty state | Fresh install vs deleted content | LOW |
| Overflow: 200 items, 60-character title, 4-line description all hold | Seed data via a debug launch argument | MEDIUM |
| Permission denied has its own screen with a path to Settings | Deny the permission in Settings; open the feature | HIGH |

## Motion and continuity

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Every `.animation` has a `value:` | `grep -rn "\.animation(" Sources/ \| grep -v "value:"` | MEDIUM |
| ★ Persistent chrome survives transitions in a parent | Push a detail; watch the title and toolbar at 10% speed | HIGH |
| ★ Exit durations shorter than entrances, no bounce | Compare present and dismiss constants; watch at 10% speed | MEDIUM |
| One `Animation` constant per datum; siblings animate together | Change a value; watch number, gauge, and label move as one | MEDIUM |
| Stagger only on first appearance, 30–80ms, ≤ 8 items | Scroll away and back; rows must not re-cascade | LOW |
| Nothing that follows a finger uses a spring | Drag a slider slowly; the thumb must track exactly | MEDIUM |
| Hero transitions animate radius with size | Open a card at 10% speed; corners must interpolate | LOW |
| Ambient loops use `TimelineView`, ≥ 1.2s, stop off-screen | `grep -rn "Timer.publish\|repeatForever" Sources/` | MEDIUM |
| Reduce Motion swaps to an 180ms crossfade; haptics remain | Toggle the setting; walk the path | HIGH |
| Numbers use `.numericText` + `.monospacedDigit()` | Change a count from 99 to 100; nothing shifts | MEDIUM |

## Hierarchy and layout

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Eye lands on headline then primary action within a second | Show the screen to someone for one second; ask what to tap | HIGH |
| ★ One primary action per view | Count filled buttons per screen | MEDIUM |
| ★ Same screen margin on every screen | `grep -rn "padding(.horizontal" Sources/` and list distinct values | MEDIUM |
| Spacing values come from the grid | `grep -rn "padding(\|spacing:" Sources/` and list distinct numbers | LOW |
| Group gaps ≥ 2× intra-group gaps; no separator plus large gap | Measure in the view debugger | LOW |
| Hero numerals have 24pt of air | Measure above and below the largest number | LOW |
| At most three radii; nested = outer − padding; all `.continuous` | `grep -rn "cornerRadius" Sources/` and list distinct values | MEDIUM |
| Optical nudges on icons and squares-in-circles | Zoom the screenshot to 400%; look for visual imbalance | LOW |
| Critical actions never under the keyboard or below a fixed sheet's fold | Open every form with the keyboard up | HIGH |
| Safe areas added to padding, not used as padding | Run on a device with a home indicator; nothing touches it | MEDIUM |

## Typography

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Three sizes carry the hierarchy; weight and opacity do the rest | List distinct font sizes per screen | MEDIUM |
| ★ AX5 does not clip; `ViewThatFits` where strings vary | Launch with `-UIPreferredContentSizeCategoryName UICTContentSizeCategoryAccessibilityXXXL` | HIGH |
| Body is leading-aligned | `grep -rn "multilineTextAlignment(.center)" Sources/` | LOW |
| No weight under `.regular` below 18pt | `grep -rn "\.light\|\.thin\|\.ultraLight" Sources/` | LOW |
| Tracking untouched except all-caps and 60pt+ display | `grep -rn "\.tracking(\|kerning(" Sources/` | LOW |
| Prose line height ≥ 1.45× | Measure a three-line paragraph | LOW |
| Changing numbers are monospaced | Watch a counter tick | MEDIUM |
| German and Finnish do not break any label | Scheme language: German; screenshot | MEDIUM |

## Colour and material

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Every colour has a light and dark pair, hand-checked in both | Toggle appearance on every screen | HIGH |
| ★ Body ≥ 7:1; secondary ≥ 4.5:1; UI ≥ 3:1 | Accessibility Inspector colour contrast on each screen | HIGH |
| Every literal specifies `.displayP3` | `grep -rn "Color(red:" Sources/ \| grep -v displayP3` | LOW |
| Gradients use explicit OKLCH stops and ≤ 5% grain | Screenshot on an OLED device; look for bands | LOW |
| Shadows tinted and faint; dark mode uses a hairline instead | Dark mode screenshot; shadows should be invisible, edges visible | LOW |
| Materials only on floating chrome; content stays legible | Scroll bright content under every material | MEDIUM |
| Meaning never carried by colour alone | Greyscale screenshot; every status still reads | HIGH |
| One accent per view; primary colour sits on the CTA background | Count accent-coloured elements per screen | MEDIUM |

## Controls

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Every tap target ≥ 44pt with `.contentShape` | Tap 10pt outside every icon glyph | HIGH |
| ★ Press-down haptic + 0.97 scale on every button | Press and hold; feel and watch | MEDIUM |
| ★ Loading buttons lock their width | Tap; watch neighbours for movement | MEDIUM |
| Disabled is transparency plus a reason | Find each disabled control; read the nearby text | MEDIUM |
| Success reverts after 1.5s | Time it | LOW |
| Destructive actions name the noun and use `role: .destructive` | `grep -rn "Are you sure" Sources/` | HIGH |
| Sheets use named detents and the project radius; stacked sheets differ ≥ 25% | Open every sheet; open any sheet from a sheet | MEDIUM |
| Sheets inherit tint and scheme from the presenter | Present from a themed screen | LOW |
| Drag-dismiss commits on 120pt or 600pt/s; upward flick cancels | Slow drag, fast flick, flick up | MEDIUM |
| Sliders and dials are linear; `.selection` at detents only | Drag slowly across a detent | MEDIUM |

## Haptics and sound

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Nothing fires on scroll, launch, or foreground notifications | Scroll a long list; launch cold; receive a push | MEDIUM |
| One `.success` per commit | Complete a batch action; count pulses | LOW |
| Generators prepared before predictable moments | `grep -rn "prepare()" Sources/` near long-press and capture | LOW |
| Sound cues < 200ms, `.ambient` + `.mixWithOthers`, toggle in Settings | Play music, trigger a cue; music must not duck; flip the ringer | MEDIUM |
| Haptic and sound land within 10ms | Trigger with both on; no perceptible gap | LOW |
| Nothing double-fires a system haptic | Open a context menu; count pulses | LOW |

## Icons

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ One family, one stroke weight, matched to text weight | Screenshot a toolbar; compare stroke to adjacent text | MEDIUM |
| State changes use `.symbolEffect(.replace)` | Toggle a favourite at 10% speed | LOW |
| No idle animation on any symbol | `grep -rn "symbolEffect(.breathe\|.pulse" Sources/` | MEDIUM |
| Selected = `.fill`; unselected = outline | Select a tab | LOW |

## Copy and naming

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Buttons verb-first and name the noun | Read every button label aloud | MEDIUM |
| ★ Errors say what happened and what to do | `grep -rni "oops\|something went wrong\|try again later" Sources/` | HIGH |
| One capitalisation policy per element type | List titles, buttons, labels; compare case | LOW |
| An action keeps its name across the flow | Follow a button to its success message | LOW |
| Navigation named by contents | Read the tab bar | LOW |
| Empty states invite; they do not apologise | Read each empty state | LOW |
| Toggles label the ON state | Read each toggle | LOW |
| Emoji and dash policy matches the design contract | Grep for emoji ranges and the em dash character in string literals | LOW |

## Accessibility

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ VoiceOver reads every screen in a sensible order | Swipe through each screen | HIGH |
| ★ Reduce Motion, Reduce Transparency, Increase Contrast each tested | Toggle each; walk the primary path | HIGH |
| Custom controls carry traits and values | Accessibility Inspector audit | HIGH |
| Progress dots hidden; container carries "Step n of m" | VoiceOver on the onboarding flow | MEDIUM |
| Focus lands sensibly after a sheet or destructive confirm | Open each with VoiceOver on | MEDIUM |

## Onboarding, paywall, widgets (when present)

| Check | How to verify | Severity if failed |
|---|---|---|
| Onboarding ≤ 5 rooms; dots not bars; CTA pinned | Count screens; watch the CTA position across pages | MEDIUM |
| Permission primer only where the next step needs it; one button | Read each primer | HIGH |
| Paywall: Close visible from frame one, price plain, one CTA, restore link, no urgency theatre | Screenshot the paywall at 0ms; read it | HIGH |
| Widgets: `ContainerRelativeShape`, content margins, three render modes tested, StandBy red tint tested | Preview each mode | MEDIUM |
| Live Activity ≤ 160pt; compact ≤ 5 characters; ends with a summary | Preview; read the compact strings | MEDIUM |

## Before you ship

- [ ] AX5 in German: no clipping
- [ ] Reduce Motion: crossfades, haptics intact
- [ ] VoiceOver: every screen, sensible order
- [ ] Dark mode: every screen, every pair
- [ ] Every list has empty, loading, error
- [ ] No `.animation` without `value:`
- [ ] No spinner on a button; nothing spins under 500ms
- [ ] Every icon button is 44pt with `.contentShape`
- [ ] Every destructive action names its noun
- [ ] No "Oops"; no "Are you sure?"
- [ ] No idle symbol animation
- [ ] Sheets use the project's radius and named detents
