---
name: ultrapolish-ios
description: Universal polish for native Swift/SwiftUI apps. Takes a competent app to a beloved one within its own visual style; never introduces a palette, typeface, or motion personality. Use whenever the user is building, reviewing, auditing, or refining an iOS app and wants it to feel considered, cohesive, premium, and detailed. Covers motion and springs, gestures, colour (OKLCH, Display P3, dark mode), typography and Dynamic Type, 4pt layout, hierarchy, buttons, sheets, navigation, haptics, sound, SF Symbols, copy, forms and text input, lists and search, empty/loading/error states, onboarding, paywalls, StoreKit, widgets, Live Activities, Dynamic Island, Liquid Glass, accessibility. Triggers on polish, feels generic, audit UI, spring, sheet, detent, haptic, sensoryFeedback, button, CTA, SF Symbol, microcopy, glassEffect, Dynamic Type, VoiceOver, Reduce Motion, tap target, design tokens, TextField, autofill, textContentType, searchable, swipe actions, Table, app icon, notifications, badge, AVPlayer, Now Playing.
---

# ultrapolish-ios

Universal polish for native Swift/SwiftUI apps. Any app, its own style, from 6/10 to 11/10 on detail, UX, and cohesion.

This is not a visual style. It is a craft standard and a procedure. It works with cream-and-serif, with true-black-and-mono, with system-default blue. It makes what is already there feel considered, continuous, and alive.

## 0. The universality guard

Read this before touching a pixel.

1. **Read before you write.** Find the project's own rules: `DESIGN.md`, `AGENTS.md`, `CLAUDE.md` design sections, a `DesignSystem.swift`, `Theme`, `Tokens`, `Motion`, `Haptics` files, asset catalog colours, existing springs, radii, and spacing constants. Grep for `cornerRadius`, `.spring(`, `.snappy(`, `.padding(`, `sensoryFeedback`, `Font.`. Build the intake table (section 1) before proposing anything.
2. **Never introduce what the project does not have.** No new typeface, no new palette, no new radius language, no new motion personality. If the app is flat and sharp, polish it flat and sharp. If it is warm and rounded, polish it warm and rounded.
3. **Numbers here are defaults for projects without an established value.** The project's own constant wins whenever it is used consistently. Inconsistency is the finding; the value is not.
4. **The anti-pattern list is a negative list.** It says what reads as generic or careless. It does not imply a positive style.
5. **No system? Build one with them before polishing.** Do not hand over the technical template: it asks for Display P3 values and spring constants, and someone without a design system cannot fill that in. Run the six plain-language questions in `references/finding-the-vibe.md`, derive the numbers yourself, and show them what you derived in words they can push back on. The result is the 15-line contract in `references/design-contract-template.md`, agreed and committed before any pixel moves. Polishing without a contract produces a second, competing style.
6. **Restraint is a deliverable.** The right change is often "remove", "align", or "reuse". Every finding must name what the user gains. If you cannot, it is not a finding.

7. **Look at it.** Reading the code tells you what was intended; only the rendered result tells you what happened. Render the screen, screenshot it, and play any motion back at a tenth speed before writing a finding about it. Half the findings worth having are invisible in the source: the thing that lands a frame late, the two greys that turned out identical, the row that reflows at the second breakpoint, the state nobody wired up. A finding you have not seen is a guess, and it belongs in the output marked as one.
## 1. Workflow

### 1.1 Intake (always, ~2 minutes)

Produce this table first. It anchors every later decision and proves you read the project.

| Dimension | What the project already does | Source |
|---|---|---|
| Type | Faces, weights, Dynamic Type usage, largest and smallest sizes | `Font` usages, `.font(` |
| Colour | Token names, light/dark pairs, accent(s), how disabled and secondary are made | asset catalog, `Color` extensions |
| Radii | Distinct values in use, `.continuous` or circular | `cornerRadius`, `RoundedRectangle` |
| Spacing | Grid step, screen margins, card padding | `.padding(`, `spacing:` |
| Motion | Named presets, most-used springs, durations, stagger | `.spring(`, `.snappy(`, `.animation(` |
| Haptics | Where they fire, which styles | `sensoryFeedback`, `UIImpactFeedbackGenerator` |
| Sound | Cues, volumes, toggle | `AVAudioPlayer`, `AudioServicesPlaySystemSound` |
| Sheets | Detents, radius, drag indicator, background | `.presentationDetents` |
| States | Which of empty / loading / error / success / offline exist | `ContentUnavailableView`, `ProgressView` |
| Copy | Case, voice, emoji, punctuation, verb-first or not | strings, `Text(` |

A row can end in three states, and they are not the same finding:

- **A value.** Record it. It now outranks every default in this skill.
- **A rule instead of a token.** "Nested radius is always outer minus padding", applied at each site, is a system. Do not file it as a gap because it has no token file.
- **Genuinely absent, or not applicable.** Absent is a finding. Not applicable is not: an app with no forms has no form system to miss. Write "n/a" and move on.

Read the project's own rules before the code, but do not read all of them. A mature `CLAUDE.md` can run to a hundred kilobytes. In quick mode take the headings first (`grep '^#'`), then the design, theming and token sections, then the token file itself. Reading the whole document is a full-audit cost, not a two-minute one.


The table above is what the project already does. Two things about the *work* decide how the defaults apply, and neither is visible in the code, so ask or infer them before proposing anything:

- **How often is this used?** Once ever, a few times a session, or a hundred times a day. Frequency is the input to half the motion rules here, and a screen nobody has told you the frequency of will get the wrong answer from all of them.
- **What is the person feeling when they arrive?** Someone filing a complaint, cancelling a subscription, or looking at an error is not in the same state as someone browsing. Care that reads as delight on a calm screen reads as flippancy on a stressful one.
### 1.2 Mode

- **build**: you are writing the feature. Apply the standard as you go. The output table becomes the change log.
- **quick audit**: primary user path only, HIGH and MEDIUM findings, cap 8.
- **full audit**: every screen and every state (empty, loading, error, success, offline, first-run, overflow, permission denied, AX5 type, Reduce Motion, dark mode), cap 20.

State the mode in the first line of the output.

### 1.3 Sweep order

Foundational first, because a token fix upstream removes five leaf findings downstream.

1. States (does every state exist and get equal care)
2. Motion and continuity (what animates together, what leaves and comes back)
3. Hierarchy and layout (what the eye lands on first, second, third)
4. Typography
5. Colour and material
6. Controls (buttons, sheets, inputs, gestures)
7. Copy and naming
8. Accessibility (as polish, not as a separate pass)

### 1.4 Output format

Always this shape. Group by root cause: a token or shared-component fix outranks the same symptom in five views, and is one row listing every location.

```
Mode: full audit · Screens: 6 · States checked: 9

| # | Sev | Location | Where else | What is wrong, and what it should be | What this changes for the user |
|---|-----|----------|-----------|--------------------------------------|--------------------------------|
| 1 | HIGH | ListView.swift:42 | DetailView.swift:18, SettingsView.swift:64 | The title unmounts and remounts across the push, so a persistent element animates out and back in. Render it in the NavigationStack parent and transition only the content | The screen feels like one place that changed, not two screens swapped |

Considered but rejected
| Candidate | Why not |
|---|---|
| Add spring to tab switch | Seen 200+ times a day; instant is correct here |

Verified how
- Ran on simulator with `-UIPreferredContentSizeCategoryName UICTContentSizeCategoryAccessibilityXXXL`
- Toggled Reduce Motion; confirmed 180ms crossfade fallback

Verdict: Needs changes (2 HIGH, 5 MEDIUM)
```

Severity: **HIGH** blocks a task, misleads, hides content, or loses data. **MEDIUM** harms comprehension, efficiency, or consistency. **LOW** isolated polish, full mode only.

**Systemic raises severity by one step; it is not a severity of its own.** A shared component or token defect that is otherwise MEDIUM becomes HIGH. This keeps HIGH meaning "someone is blocked or misled" while still making the upstream fix outrank the leaf symptoms it causes.

Verdict vocabulary: `Ship` (no HIGH, no MEDIUM), `Needs changes`, `Block` (any HIGH).

The "What this changes for the user" column is mandatory. It is the test of whether a finding is real.

### 1.5 When two findings disagree

They will. A transition that makes a flow continuous costs a frame. A denser table fits more rows and shrinks the target. A softer grey is calmer and fails contrast. Resolve in this order, and a lower concern never overrides a higher one.

1. **Correctness.** The interface tells the truth about the data and the state. Nothing is invented to make a transition smoother or a number rounder.
2. **Reach.** Everyone can operate it: keyboard, screen reader, largest type, reduced motion, one hand, 200% zoom.
3. **Comprehension.** A person can tell what this is, what happened, and what to do next.
4. **The project's own conventions.** Consistency inside the product beats a better idea applied in one place. This is the same reason the intake outranks the defaults here.
5. **Responsiveness.** It answers immediately, and only then is it allowed to take its time.
6. **Continuity.** Things move from somewhere to somewhere, and what persists is not rebuilt.
7. **Character.** Everything above is intact and there is budget left.

The order maps onto severity, which is why it is worth stating rather than assuming: a finding that breaches 1, 2 or 3 is HIGH. One that breaches 4 or 5 is MEDIUM. One that breaches 6 or 7 is LOW, before the systemic step is applied.

It also settles the argument the other way. **Character that costs anything above it is a defect, not a feature**, and should be reported as one. An animation that delays a destructive confirmation, a hover that makes a dense table jitter, a celebration that blocks the next action: each of those is a finding, not a flourish, and the row says so.

### 1.6 Asking, rather than guessing

Most of this skill is answerable from the code. A few things are not, and guessing at those is where an audit goes wrong quietly: how often a screen is used, who is using it and under what pressure, whether a colour is a brand constraint or an accident, whether a dense table is a deliberate choice or neglect, and everything in `references/finding-the-vibe.md` when there is no system to read.

When the answer changes the work and is not in the repo, ask.

- **Use the host's structured question tool if there is one.** In Claude Code that is AskUserQuestion, which takes up to four questions at once and renders the options as choices. Elsewhere, ask numbered questions in a single message.
- **Batch them.** One question per turn is exhausting and people start answering to make it stop, which is worse than not asking.
- **Always offer options, and mark one as your recommendation.** A blank question is work handed back. Three named choices with a sentence each is a decision someone makes in ten seconds. Put the recommendation first and say that it is one.
- **Never ask for a value you should derive.** Not a hex code, not a duration, not a radius. Ask about the feeling and the frequency; the numbers are your job.
- **Do not ask what you can measure.** Anything visible in a token file, a screenshot, or a computed style is not a question.
- **Ask before the work, not after.** A question that arrives with the findings is a finding that was written on an assumption.

Two or three well-chosen questions before an audit routinely change more of the output than an extra hour of reading.

## 2. The ten laws

These hold in every style. Break one only with a written reason.

1. **One datum, one curve.** Everything driven by the same value animates on the same `Animation` constant, together. A number, its gauge, and its trend arrive as one thing breathing, not a bag of parts.
2. **Out is faster than in.** Exit at about 0.65× the entrance duration, with zero bounce. People want out faster than they wanted in.
3. **The 100× rule.** If someone sees an interaction 100 times a day, do not animate it. Tab switches, keyboard focus, list scrolling, arrow selection: instant.
4. **What follows a finger is linear.** Sliders, scrubbers, crop dials, drag tracking: `.linear` or no animation. Springs begin only when the finger lets go, and they inherit its velocity.
5. **The spinner travels.** Loading appears where the result will appear, not only on the control that was tapped. A sent message shows progress in its bubble; a captured photo shows progress on the thumbnail. The control may also carry progress once the result has a home of its own; it may never be the only place it appears.
6. **Every state gets equal care.** Empty, loading, error, success, offline, first-run, overflow, permission denied, largest Dynamic Type, Reduce Motion, dark mode. The empty state is the first impression for every new user. Space reserved so the container never resizes is a hole in every state that does not fill it: each one either fills the box or centres in it.
7. **Persistent elements never leave and come back.** If a title, toolbar, pill, or hero exists on both sides of a transition, render it in a parent that survives the transition.
8. **A disabled control says why; a destructive action names its noun.** Never a grey button with no explanation. Never "Are you sure?" with Yes/No. "Delete project" and "Cancel".
9. **One accent per view.** The primary action carries the colour on its background, not on its label. Selected states may tint a glyph; that is state, not emphasis.
10. **Every number that can change is monospaced and content-transitions.** `.monospacedDigit()` plus `.contentTransition(.numericText(value:))`. Otherwise the layout shifts as 99 becomes 100.

## 3. Cheat sheets

Defaults for projects without an established value. The project's own constant wins.

### 3.1 Motion

| Moment | Default | Note |
|---|---|---|
| Button press (touch-down) | `.spring(duration: 0.16, bounce: 0)` to scale 0.97 | Fires hundreds of times a day; near-instant |
| Button release | `.spring(duration: 0.30, bounce: 0.25)` | The one place a whisper of bounce belongs |
| State change (toggle, tab indicator, chip) | `.snappy(duration: 0.24 to 0.28, extraBounce: 0.08 to 0.12)` | Default for small UI |
| Crossfade (mode, colour, opacity) | `.smooth(duration: 0.22)` or `.easeOut(0.22)` | Opacity never springs |
| Sheet present | `.spring(duration: 0.42, bounce: 0.18)` | Contents arrive 60–80ms after the container |
| Sheet dismiss | `.spring(duration: 0.32, bounce: 0)` | Out faster than in |
| Hero / matched geometry | `.spring(duration: 0.42, bounce: 0.16)` | Corner radius animates with size |
| Navigation push | `.spring(duration: 0.38, bounce: 0.05)` | Deeper grows in from 0.94; shallower shrinks in from 1.04 |
| Weighted object settling | `.spring(duration: 0.45, bounce: 0.12)` | Cards, sheets after a drag |
| Celebration (rare) | `.bouncy(duration: 0.6, extraBounce: 0.3)` | Once per milestone, never per save |
| Progress tracking a real value | `.linear(duration: 0.18)` | It is a number; it moves linearly |
| Ambient loop (shimmer, breathing wash) | 1.2s or longer, `TimelineView`, never a `Timer` | Never on a symbol |
| Reduce Motion fallback | `.easeInOut(duration: 0.18)` crossfade | No travel, no scale, no 3D |

Conversion from legacy notation: `duration ≈ response`, `bounce ≈ 1 − dampingFraction`. A 0.42/0.82 spring is roughly `.spring(duration: 0.42, bounce: 0.18)`.

Stagger: 30–80ms per element on first appearance only. Cap around 8 items (240ms total); beyond that the last item arrives after the user has already looked. Never re-stagger on scroll.

Golden non-spring curve for anything that must not overshoot: `.timingCurve(0.16, 1, 0.3, 1, duration: 0.4)`. Never `.easeIn` on an entering element; it reads as reluctance. Exits may ease in.

### 3.2 Haptics (`.sensoryFeedback`)

| Moment | Feedback | Rule |
|---|---|---|
| Button press | `.impact(weight: .light)` on touch-DOWN | Never on release |
| Selection change (picker, segmented, detent crossed) | `.selection` | On the crossing, not per pixel |
| Commit (send, save, complete) | `.success` | Once per commit, never per item |
| Warning state (over limit, drag past cancel) | `.warning` | Once on entering the state |
| Error | `.error` | Paired with inline copy, never alone |
| Pick up / drag start | `.impact(flexibility: .soft, intensity: 0.7)` | |
| Land / drop | `.impact(weight: .medium)` or `.rigid` at a detent | Heavier and duller than pick-up |
| Continuous (scrub, flip, tick) | throttle ≥ 30ms, scale intensity with density | `0.35 + 0.35 × density` |

Never haptic: cold launch, list scrolling, foreground notifications, every read receipt, saved settings, anything the system already fires (context menu open, widget button, Camera Control half-press). `prepare()` a generator ~1 second before a predictable moment; it cuts latency from ~50ms to under 5ms. iPads have no haptic engine; guard with `UIDevice.current.userInterfaceIdiom`.

### 3.3 Typography

Dynamic Type spine. Use the semantic styles; hard-code sizes only for hero numerals and chrome that must not scale.

| Style | Size | Weight | Use |
|---|---|---|---|
| `.largeTitle` | 34 | bold | Top-level screen titles |
| `.title` | 28 | bold | Section heroes |
| `.title2` | 22 | bold | Card titles, sheet titles |
| `.title3` | 20 | semibold | Sub-sections |
| `.headline` | 17 | semibold | Row titles, emphasis inside body |
| `.body` | 17 | regular | Prose, row content |
| `.callout` | 16 | regular | Secondary prose |
| `.subheadline` | 15 | regular | Supporting text |
| `.footnote` | 13 | regular | Metadata, timestamps |
| `.caption` | 12 | regular | Labels |
| `.caption2` | 11 | regular | Floor; nothing smaller |

- Spine for most apps: **17 / 22 / 28**. Three sizes carry 90% of hierarchy; weight and colour carry the rest.
- Emphasis within a role is one weight step, not a size change.
- Do not override SF Pro tracking. Exceptions: all-caps labels +1.2 to +2.0pt; 60pt+ display −0.5 to −1.5pt.
- Line height: body 1.3–1.4×, display 28pt+ 1.1–1.2×, prose paragraphs 1.45–1.5× (never tighter than 1.45 for 3+ lines).
- Body text is leading-aligned. Centre only single-line headlines and hero numerals.
- Weights under `.regular` are display-only, 28pt and above. Nothing under 18pt goes below `.regular`.
- Every changing number: `.monospacedDigit()`. Hero numerals may use `.rounded` if the project already does.
- Test at `.accessibility5` and in German. If a label truncates, use `ViewThatFits` with a shorter variant.

### 3.4 Layout and spacing

- **4pt grid, 8pt rhythm.** Values: 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64. Not an 8-only grid; 12 and 20 are load-bearing.
- **Screen margins 16–24pt** (20 is the most common). Content inside cards 12–16. Keep the same margin on every screen.
- **Hero numbers want 24pt above and below.** Not 12, not 16.
- **Grouping by space, not lines.** Gap between groups ≥ 2× gap within a group (8 inside, 16+ between). Separators are for dense data only, and never combined with a large gap.
- **Controls**: 12pt between adjacent filled controls; 24pt clearance around borderless icon buttons.
- **Radii ladder**: pick 3 values at most (e.g. 8 / 14 / 24). Nested corner = outer − padding. Above 24pt of padding, treat layers as separate surfaces. Always `.continuous`. Capsule for pills and full-width CTAs.
- **Optical alignment**: a square renders at 92% of a circle's diameter to look equal. Icons next to text nudge 0.5–1pt. A play triangle in a circle sits 1–2pt right.
- **Safe areas are added to padding, never used as padding.** `.safeAreaInset(edge: .bottom)` for sticky CTAs; `.contentMargins` for scroll content under floating chrome.
- **Full-bleed content, floating controls.** Content may bleed to the edge; buttons stay inside the margin with a visible radius.

### 3.5 Buttons and controls

| Size | Height | H-pad | Font | Radius |
|---|---|---|---|---|
| xs | 28 | 12 | 13 semibold | 8 |
| sm | 32 | 16 | 14 semibold | 8 |
| md | 44 | 20 | 15 semibold | 12 |
| lg | 52 | 24 | 17 semibold | 14 |
| xl | 60 | 28 | 17 bold | 16 |

- Tap target ≥ 44×44pt always, via `.frame(minHeight: 44).contentShape(Rectangle())`. Without `.contentShape` only the glyph is tappable.
- Six states: rest, pressed (0.97, opacity 0.9, touch-down haptic), loading (width locked; label swaps for `ProgressView` in the same frame; nothing moves), disabled (transparency, not grey; paired with a reason), success (symbol replace, auto-revert after 1.5s), error (inline copy under the control, never an alert).
- Press scale ladder: rows 0.99, surfaces and CTAs 0.97, small icon buttons 0.94, floor 0.90.
- One primary per view, full width on phones, capsule or the project's large radius.
- Secondary is text-only or outlined. Never two filled buttons side by side.

### 3.6 Sheets and detents

| Job | Detents | Extras |
|---|---|---|
| Quick confirm, 1–2 actions | `.height(220)` or `.fraction(0.25)` | Drag indicator visible |
| Picker, short list | `.medium` | |
| Filter, browse | `[.medium, .large]` | `.presentationBackgroundInteraction(.enabled(upThrough: .medium))` for map/chart/player behind |
| Form, compose | `.large` | Drag indicator hidden if there is a Close button |
| Full takeover | `.large` + `.presentationDragIndicator(.hidden)` | |

- `.presentationCornerRadius`: the project's large radius (system default is 10pt; 20–36 is common). Name it once as a constant.
- Stacked sheets must differ in height by ≥ 25%, or the user loses spatial orientation.
- Trays adopt the environment: `.preferredColorScheme`, `.tint`, `.presentationBackground` inherit from the presenting surface.
- Contents arrive 60–80ms after the container, staggered 30ms. That offset is why system sheets feel like containers arriving with things inside.
- Drag-dismiss: commit at 120pt travel or 600pt/s velocity, whichever first. Velocity beats position.

### 3.7 Colour

- **Pick in OKLCH, ship in Display P3, fall back to sRGB automatically.** `Color(.displayP3, red:green:blue:)`. `Color(red:green:blue:)` silently gives sRGB.
- **Dark mode lowers L only.** Hold C and H. Never mirror a light palette; re-check every pair in both appearances.
- **Contrast targets**: body ≥ 7:1 (4.5 floor), secondary ≥ 4.5:1, tertiary and UI ≥ 3:1. In dark mode lift accent L by ~0.06 to hold ≥ 3:1.
- **Secondary text is one ink stepped in opacity** (e.g. 1 / 0.62 / 0.45 / 0.28), so dark mode flips one base and the hierarchy follows.
- **Gradients** interpolate in linear RGB in SwiftUI; yellow to blue passes through grey. Pass explicit OKLCH-computed stops. Add ≤ 5% noise with `.blendMode(.overlay)` to stop banding on OLED.
- **Shadows**: subtle `.black.opacity(0.06), radius 8, y 4`; lift `0.12 / 16 / 8`; floating `0.18 / 24 / 12`. Never pure black at full opacity. In dark mode, shadows vanish: use a 1pt `.white.opacity(0.06)` inner stroke for elevation.
- **True black** only when the project is media-first (camera, photo, video) or has made an OLED decision. Otherwise near-black carrying the palette's hue.
- **One colour, one meaning.** A hue used within ±15° of the accent on something non-interactive tells users to tap it.

### 3.8 States and loading

| Elapsed | Show |
|---|---|
| 0–500ms | Nothing. Optimistic result if possible |
| 500ms–2s | Subtle inline progress where the result will appear |
| 2s+ | Explicit progress with a label, cancel if possible |
| 10s+ | Live Activity or notification on completion |

- Skeletons structurally match the real content: same bar count, widths, positions. Shimmer 1.2–1.5s, `TimelineView`, subtle.
- Optimistic pending state is a ghost at opacity 0.6, not a spinner.
- Empty state = symbol or small illustration + one warm line of why + one action. Never "No items". Never park crucial persistent information in an empty state.
- Errors appear in context, rising from the thing that failed, with the last good value still visible. A toast in the sky is for reversible, minor, global outcomes only.
- Undo must actually reverse the effect.

### 3.9 Hit areas and accessibility as polish

- 44×44pt touch targets; a 24pt glyph gets padding to 44 and `.contentShape`.
- Reduce Motion: replace travel, scale, and 3D with an 180ms crossfade. Keep haptics and functional feedback. Do not strip all animation; a broken-feeling app is worse.
- Reduce Transparency: materials become solid fills.
- Dynamic Type to AX5 without clipping; `ViewThatFits` for anything with a variable string.
- VoiceOver: every image has a label or is hidden; progress dots are `.accessibilityHidden(true)` with `.accessibilityValue("Step 2 of 4")` on the container; custom controls have `.accessibilityAddTraits(.isButton)`.
- Colour never carries meaning alone: pair with a symbol or a label.

## 4. Topics

Each topic below is the 30-second version. The reference has the full rules, numbers, code, and checks.

### Motion and transitions → `references/motion.md`

Scope every `.animation` with `value:`; a bare `.animation` is the iOS `transition: all`. Build a named motion vocabulary (5–8 curves, each with a stated job) and add the line "if a new animation does not fit one of these, the answer is usually don't". Write the storyboard as a comment above the constants: every state, top to bottom, with ms after trigger. Content transitions: `.numericText` for numbers, `.symbolEffect(.replace)` for icons, `.interpolate` for shapes. Loops must act, rest, then ease home; never snap.

### Gestures and physics → `references/gestures-and-physics.md`

Interruptibility is the single most important principle: always animate from the current on-screen value, never the target. Decide reverse-vs-commit by velocity sign, not position. Apple's momentum projection is `(v / 1000) × d / (1 − d)` with `d ≈ 0.998`, not the textbook `v² / 2a`. Rubber-band: `(1 − 1 / (offset / dimension × 0.55 + 1)) × dimension`. Decompose 2D motion into independent X and Y springs. Detect all plausible gestures in parallel from the first move, then cancel the losers.

### Colour and material → `references/color.md`

Light/dark token pairs hand-tuned per mode, not derived. One accent per view. Materials for floating chrome only, never behind a wall of text; content gets a flat translucent fill plus a 0.5pt hairline. Test every colour on a translucent surface over the lightest and darkest content that can scroll behind it.

### Typography → `references/typography.md`

Three sizes carry the hierarchy. Weight and opacity do the rest. Never rasterise text. Hero numerals `.monospacedDigit()` with `.minimumScaleFactor(0.7)`. Mixed-weight concatenated `Text` for a headline with one emphasised phrase. All-caps labels are a house choice, not a default; if used, +1.2pt tracking and 11–13pt.

### Layout, spacing and hierarchy → `references/layout-and-spacing.md`

The eye should land on the headline, then the primary action, within a second. If it does not, the hierarchy is off. One primary action per view. Group secondary actions behind a menu once they exceed three. Design for two items and for two hundred. Never park a critical action below the fold of a fixed-height sheet or behind the keyboard.

### Buttons and controls → `references/buttons-and-controls.md`

The press-down haptic is non-negotiable: the button heard you. Loading locks its width. Disabled is transparency with a reason. Success reverts in 1.5s. A row with an inner button captures the inner tap first. Sticky CTAs use `.safeAreaInset(edge: .bottom)` with `.background(.bar)` and scroll-react via `.onScrollGeometryChange`.

### Lists, search and working with many things → `references/data-and-density.md`

`List` for reading down, `Table` for comparing across and only at a regular width, with the compact fallback designed rather than accepted. One primary line per row and at most two supporting ones, checked at AX5. Compared figures are `.monospacedDigit()` and trailing-aligned. A dense row may be shorter than 44pt only if its tap target is not. Search results update in place and never blank the list; a no-results state names the query. Selection puts the count in the title, and "select all" meaning every match is a separate explicit choice. Bulk actions name the verb, the count and the noun. Swipe holds the one or two constant actions with full swipe off unless undoable; everything rarer is in a context menu that also exists somewhere without a long press. On iPad the hardware keyboard is a real input.

### Forms and text input → `references/forms-and-inputs.md`

Most of what makes a form feel careless is invisible in a screenshot. `.textContentType` is what turns autofill, QuickType, strong passwords and one-time codes on, and nothing works without it. The keyboard matches the content and the return key names its action. `@FocusState` advances on return and moves to whatever failed. Never disable submit until valid: validate on submit, then per keystroke only for a field that has already failed. Errors sit under their field, in words, with the value kept. Nothing important hides under the keyboard, and a number pad needs a Done button because it has no return key. One `TextField` with `.oneTimeCode`, never six boxes.

### Sheets, navigation and trays → `references/sheets-and-navigation.md`

Directional continuity: forward enters from the trailing edge, back returns to it. Deeper grows in from 0.94; shallower shrinks in from 1.04. Titles live in the parent. Hero transitions use `matchedGeometryEffect` with the radius animating (18 → 38 → 0 on drag-dismiss). Persistent chrome survives the push.

### Haptics → `references/haptics.md`

Haptics are punctuation, a full stop, not an exclamation mark. Budget them: one success per commit, one selection per detent, light on press-down, nothing on scroll. CoreHaptics for the 10% that deserves a signature: two transients (0.55 sharp 0.30, then 0.9 sharp 0.55 at +85ms) reads as a card materialising. Never double-fire what the system already fires.

### Sound → `references/sound.md`

Three to five cues, each under 200ms, each with its own volume (celebrate 0.5, success 0.34). `.ambient` category with `.mixWithOthers` so the Ring/Silent switch is respected and music never ducks. Within 10ms of its haptic. Always a settings toggle. Synthesised sound (filtered noise + ring + thud with per-play randomisation) costs zero bundle weight and never repeats exactly.

### The app icon → `references/app-icon.md`

The only part of the product seen before anyone decides to open it. Design at 60pt and check at 29pt; delivering a 1024 master nobody ever looked at small is how a good mark becomes a texture in Settings. One idea, no text, no transparency, no baked corners or gloss, because the system applies the mask and on iOS 26 the material too. Author all three appearances: the tinted one is generated from a greyscale reading, so a flat single-colour icon collapses and a design separated only by hue loses everything. The dark variant is not the light one inverted. Test on a photographic wallpaper next to Mail and Settings, matching their optical fill rather than a margin you invented, and make the first frame of the app share the icon's colour so the launch zoom is continuous.

### Icons and SF Symbols → `references/icons-and-symbols.md`

One family, one stroke weight, matched to the adjacent text weight. `.symbolEffect(.replace)` for state swaps. Pick 3–5 symbol moments per app and pair each with a haptic. Do morph, do not breathe: `.breathe` and `.pulse` on idle icons are the number-one AI-template tell. Never mix SF Symbols and a custom set in the same row.

### Copy and naming → `references/copy-and-naming.md`

Verb-first buttons that name the noun ("Delete project", not "OK"). Sentence case by default. An action keeps its name through the whole flow: "Publish" produces "Published". Name navigation by contents ("Library", "Progress"), not by umbrella ("Home"). Errors say what happened and what to do, never apologise, never "Oops". Defaults: no emoji in interface chrome, no em-dashes in UI copy (house style may override both; write the override into the design contract).

### States → `references/states.md`

The ladder (silent → inline → explicit → Live Activity). Skeletons match structure. Optimistic first, ghost while pending, revert with an inline reason on failure. Feedback taxonomy: minor reversible → capsule toast ~2.2s with Undo; important → inline at the thing that changed; the app acted on your behalf → an action receipt card; destructive → confirm with the noun, then resolve in place.

### Onboarding → `references/onboarding.md`

Value in three seconds. Four or five rooms, one purpose each: value moment, the one input, the payoff, a permission primer only if the very next thing needs it, a handoff. Sign-in and the paywall are not rooms. Progress is dots, never a bar; the active dot is a capsule 2.5–3× wider that glides. The CTA is pinned a fixed distance from the bottom safe area; body copy grows upward. The launch screen is not a design canvas and contains no text.

### Paywalls and pricing → `references/paywalls.md`

Value before wall. Real localised price always on screen, both total and per-month. One paid tier (or annual plus monthly). A full-size Close from frame one. Exactly one CTA. Placement: after a value moment, at a metered limit, in onboarding only after a value preview, never on cold launch, never to an existing subscriber. The honesty test: would this still work if the person understood it completely? Nothing on a paywall pulses, throbs, or counts down.

### Notifications → `references/notifications.md`

The only part of a product that appears on someone's screen without being asked for. Never request permission at launch: prime it yourself, after they have done something that implies wanting it, and use `.provisional` for anything non-urgent so it costs no prompt at all. The first line is the whole notification, so front-load the noun and the change and never lead with the app's name. Almost nothing is `.timeSensitive`. Group with a `threadIdentifier` or the app becomes a wall. Put the two likely responses on the notification itself. The badge counts things needing action or it does not exist. Reuse the identifier to update in place rather than stacking five notifications about one order, suppress what is already on screen, cancel reminders whose reason has gone, and give settings a toggle per category rather than one switch for everything.

### Widgets, Live Activities and Dynamic Island → `references/widgets-and-live-activities.md`

Content margins, not safe areas: the system hands you about 16pt, but 24pt is the target and 16 the floor, because a widget is read at arm's length and wants more air than a screen. 11pt only in a tight accessory. `ContainerRelativeShape()` for every nested corner; never a literal radius. `.containerBackground(for: .widget)` is required. Three render modes are three designs: `.accented` renders from alpha and ignores hue; `.vibrant` hierarchy uses opaque greys, never white at opacity. 11pt floor, no Light weights. A widget's only life is a wash healing across the day and a number rolling when it changes. Dynamic Island compact regions hold ≤ 5 characters; the minimal is a 22×22pt glyph. `Text(timerInterval:)` ticks for free. No confetti, no breathing, no faked press states.

### Liquid Glass (iOS 26) → `references/liquid-glass.md`

Glass for floating controls only. Tint the one primary action. `.interactive()` instead of your own scale style. Never glass on glass; `GlassEffectContainer` for overlapping surfaces. Content (cards, rows, bubbles) stays solid or gets a flat translucent fill; a refractive card behind a paragraph hurts legibility. Wrap in availability with a material fallback. Do not put glass on the app icon.

### Video and audio playback → `references/media-playback.md`

Playback is where the app stops being alone on the device: it shares the audio session, the Lock Screen, Control Centre, CarPlay and headphone buttons. Declare `.playback` for content and `.ambient` with `.mixWithOthers` for interface sound, or the app cuts someone's podcast to play a click. Fill in `MPNowPlayingInfoCenter` or the Lock Screen is blank. Wire only the remote commands that work and disable the rest. Headphones unplugged means pause; a call ending means resume only if the system says so. Scrubbing follows the finger linearly with a `.selection` haptic on markers, not pixels. Time is `.monospacedDigit()` at a reserved width. Buffering does not look like paused. `AVPlayerViewController` unless you will rebuild PiP, AirPlay and subtitles yourself.

### Accessibility as polish → `references/accessibility.md`

The apps people love are the ones that hold together at AX5, with Reduce Motion, in Increase Contrast, and under VoiceOver. Test those four before calling anything done. Reduce Motion means crossfade, not nothing.

## 5. Anti-patterns and AI tells

Reject on sight. Each of these reads as "made by nobody in particular".

- A symbol that breathes, pulses, or bounces while idle
- Purple → blue → pink gradient; any gradient interpolated in RGB (grey in the middle)
- Confetti or a particle burst anywhere; a set piece standing in for craft in the ordinary interactions around it
- A state that teleports: value changes with no `.animation(_, value:)`
- `.animation(...)` with no `value:`; `withAnimation` wrapping unrelated state
- `Color(red:green:blue:)` without `.displayP3`; a hex literal with no light/dark pair
- Disabled as grey instead of transparency; disabled with no reason
- A toast in the sky for an error that belongs next to the field
- A spinner on the button that was tapped; a spinner under 500ms
- Skeleton with three bars for content that has five
- Paywall on cold launch; a pulsing PRO badge; a fake countdown; monthly hidden or greyed
- True black background in a non-media app with no OLED decision written down
- An 8pt-only grid that leaves 12 and 20 unavailable
- Four hardcoded day-phase colour buckets where a continuous wash was intended
- Launch screen with text or a logo that is not on the first real screen
- `Timer` at 60fps driving UI; `repeatForever` on anything that is not an explicit ambient loop
- Title animates out on push and back in on the destination
- Two filled buttons side by side; two identical-height stacked sheets
- Center-aligned form fields; center-aligned body paragraphs
- "Are you sure?" with Yes / No; "Oops! Something went wrong."
- Emoji in navigation titles, button labels, or error copy (unless the design contract says so)
- Haptic on every scroll tick, every read receipt, every foreground notification

## 6. The 6 → 11 checklist
### States
- [ ] ★ Empty state exists for every list, search, and filter, with one action
- [ ] ★ Loading follows the ladder; nothing spins under 500ms
- [ ] ★ Error appears in context with the last good value still visible

### Motion and continuity
- [ ] ★ Every `.animation` has a `value:`
- [ ] ★ Persistent chrome survives transitions in a parent
- [ ] ★ Exit durations are shorter than entrances and have no bounce

### Hierarchy and layout
- [ ] ★ Eye lands on headline then primary action within a second
- [ ] ★ One primary action per view
- [ ] ★ Same screen margin on every screen

### Typography
- [ ] ★ Three sizes carry the hierarchy; weight and opacity do the rest
- [ ] ★ AX5 does not clip; `ViewThatFits` where strings vary

### Colour and material
- [ ] ★ Every colour has a light and dark pair, hand-checked in both
- [ ] ★ Body contrast ≥ 7:1; secondary ≥ 4.5:1; UI ≥ 3:1

### Controls
- [ ] ★ Every tap target ≥ 44pt with `.contentShape`
- [ ] ★ Press-down haptic + 0.97 scale on every button
- [ ] ★ Loading buttons lock their width

### Haptics and sound
- [ ] ★ Nothing fires on scroll, launch, or foreground notifications

### Icons
- [ ] ★ One family, one stroke weight, matched to text weight

### Copy and naming
- [ ] ★ Buttons are verb-first and name the noun
- [ ] ★ Errors say what happened and what to do

### Accessibility
- [ ] ★ VoiceOver reads every screen in a sensible order
- [ ] ★ Reduce Motion, Reduce Transparency, Increase Contrast each tested

The starred set above is quick mode: the twenty or so that catch most of what is wrong
on a primary path. The full list, every item with a column for how to verify it and what
severity to file it at, is `references/audit-checklist.md`, along with the one-hour audit
running order. Read that file for a full audit rather than working from this one.

## 7. Decisions register

Where sources disagree, this skill takes these positions. Change them only in the project's design contract.

| Topic | Decision |
|---|---|
| Exit curve | Accelerating exit at ~0.65× entrance, bounce 0; entrances never `.easeIn` |
| Spring notation | `.spring(duration:bounce:)`; `bounce ≈ 1 − dampingFraction` |
| Springs vs curves | Springs for gesture-driven, interruptible, or weighted objects; curves for colour and opacity; opacity never springs |
| Press scale | Rows 0.99 · surfaces 0.97 · small icons 0.94 · floor 0.90; opacity 0.9 |
| Stagger | 30–80ms, first appearance only, cap ~8 |
| Dark mode black | Near-black carrying the palette's hue; true black only for media-first chrome or a written OLED decision |
| Hit area | 44pt; macOS pointer 24pt |
| Reduce Motion | 180ms crossfade; keep haptics and functional feedback |
| Long-press | 0.45s reactions, 0.5s system, 0.7s destructive |
| Celebration | No particles, no set pieces, at any frequency. The budget goes into every ordinary interaction instead: things land, settle, roll, and morph rather than appearing and cutting |
| Widget padding | 24pt target, 16pt floor (the system default), 11pt tight accessory; `ContainerRelativeShape` |
| Onboarding length | 4–5 rooms; longer only when each step builds toward one payoff |
| Emoji / em-dash | Defaults: none in chrome, none in UI copy; house style may override in the design contract |
| Icons | Two states (outline, fill), not three |
| Toasts | Only for minor, reversible, global outcomes; ~2.2s with Undo; anything with an action persists |
| Haptic budget | Anything with a physical metaphor earns a texture: toggles, tab changes, drag pick-up and drop, pull thresholds, long-press arming, reorder crossings. Never on scroll, launch, timers, per item in a batch, or duplicating a system-fired one |
| Empty states | Show the destination, not just the door: name, one line, a ghosted preview of the filled state, one action |
| Onboarding indicator | Equal dots that never move or stretch; only the fill changes, over 180ms |
| Palette choice | Justify the hue family in one sentence about the product. Neighbours within 60 degrees read as one family; semantic colours sit 25 degrees off the accent. One L ramp and one chroma percentage across every hue. Muddy is chroma too low, not too high |
| Type detail | Ligatures off wherever a character must be transcribed; slashed zero on codes only; lining and oldstyle figures never mixed in a view; real small caps or none; stylistic sets declared once at the root |
| Grid | 4pt base, 8pt rhythm, 16 to 24 margins. Not 8-only |
| Icon states | Two: outline at rest, filled when selected. Never a third that is only a colour |
| Conflicting findings | Correctness, reach, comprehension, the project's conventions, responsiveness, continuity, character, in that order. A lower concern never overrides a higher one, and the order maps onto severity |
| Data in motion | Interpolate the presentation, never the value. A number a person could act on is never smoothed through figures that were not true |
| Icon transitions | Rotate when it is the same shape at another angle; only morph or replace when the drawings genuinely differ |
| Asking the user | Ask when the answer changes the work and is not in the repo: frequency, who it is for, brand constraints, and anything in the vibe interview. Batch the questions, always offer options with a recommendation marked, never ask for a value you should derive |
| No design system | The six plain-language questions in `references/finding-the-vibe.md` first, then derive the contract yourself and show it back in words they can argue with |

## 8. Further reading inside this skill

- `references/anti-patterns.md` for the long-form tells with the fix for each
- `references/audit-checklist.md` for the printable checklist with the "how to check" column
- `references/design-contract-template.md` for the 15-line contract and a filled example
- `assets/` for drop-in Swift: `Motion.swift`, `Haptics.swift`, `PressableButtonStyle.swift`, `DisplayP3Color.swift`, `LoadingButton.swift`, `OnboardingDots.swift`, `Shimmer.swift`, `SheetPresets.swift`
