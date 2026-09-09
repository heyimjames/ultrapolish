# ultrapolish-ios: universal polish for Swift / SwiftUI apps

_Universal polish for native Swift/SwiftUI apps. Takes a competent app to a beloved one within its own visual style; never introduces a palette, typeface, or motion personality. Use whenever the user is building, reviewing, auditing, or refining an iOS app and wants it to feel considered, cohesive, premium, and detailed. Covers motion and springs, gestures, colour (OKLCH, Display P3, dark mode), typography and Dynamic Type, 4pt layout, hierarchy, buttons, sheets, navigation, haptics, sound, SF Symbols, copy, empty/loading/error states, onboarding, paywalls, StoreKit, widgets, Live Activities, Dynamic Island, Liquid Glass, accessibility. Triggers on polish, feels generic, premium, craft, cohesive, make it better, audit UI, spring, .snappy, sheet, detent, haptic, sensoryFeedback, sound effect, button, CTA, SF Symbol, symbolEffect, microcopy, empty state, skeleton, onboarding, paywall, widget, Live Activity, glassEffect, Dynamic Type, VoiceOver, Reduce Motion, tap target, dark mode, OKLCH, design tokens._

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
5. **No system? Propose one before polishing.** Offer the 15-line design contract from the design-contract-template reference below, get it agreed, then work inside it. Polishing without a contract produces a second, competing style.
6. **Restraint is a deliverable.** The right change is often "remove", "align", or "reuse". Every finding must name what the user gains. If you cannot, it is not a finding.

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

## 2. The ten laws

These hold in every style. Break one only with a written reason.

1. **One datum, one curve.** Everything driven by the same value animates on the same `Animation` constant, together. A number, its gauge, and its trend arrive as one thing breathing, not a bag of parts.
2. **Out is faster than in.** Exit at about 0.65× the entrance duration, with zero bounce. People want out faster than they wanted in.
3. **The 100× rule.** If someone sees an interaction 100 times a day, do not animate it. Tab switches, keyboard focus, list scrolling, arrow selection: instant.
4. **What follows a finger is linear.** Sliders, scrubbers, crop dials, drag tracking: `.linear` or no animation. Springs begin only when the finger lets go, and they inherit its velocity.
5. **The spinner travels.** Loading appears where the result will appear, not only on the control that was tapped. A sent message shows progress in its bubble; a captured photo shows progress on the thumbnail. The control may also carry progress once the result has a home of its own; it may never be the only place it appears.
6. **Every state gets equal care.** Empty, loading, error, success, offline, first-run, overflow, permission denied, largest Dynamic Type, Reduce Motion, dark mode. The empty state is the first impression for every new user.
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

### Motion and transitions → the motion reference below

Scope every `.animation` with `value:`; a bare `.animation` is the iOS `transition: all`. Build a named motion vocabulary (5–8 curves, each with a stated job) and add the line "if a new animation does not fit one of these, the answer is usually don't". Write the storyboard as a comment above the constants: every state, top to bottom, with ms after trigger. Content transitions: `.numericText` for numbers, `.symbolEffect(.replace)` for icons, `.interpolate` for shapes. Loops must act, rest, then ease home; never snap.

### Gestures and physics → the gestures-and-physics reference below

Interruptibility is the single most important principle: always animate from the current on-screen value, never the target. Decide reverse-vs-commit by velocity sign, not position. Apple's momentum projection is `(v / 1000) × d / (1 − d)` with `d ≈ 0.998`, not the textbook `v² / 2a`. Rubber-band: `(1 − 1 / (offset / dimension × 0.55 + 1)) × dimension`. Decompose 2D motion into independent X and Y springs. Detect all plausible gestures in parallel from the first move, then cancel the losers.

### Colour and material → the color reference below

Light/dark token pairs hand-tuned per mode, not derived. One accent per view. Materials for floating chrome only, never behind a wall of text; content gets a flat translucent fill plus a 0.5pt hairline. Test every colour on a translucent surface over the lightest and darkest content that can scroll behind it.

### Typography → the typography reference below

Three sizes carry the hierarchy. Weight and opacity do the rest. Never rasterise text. Hero numerals `.monospacedDigit()` with `.minimumScaleFactor(0.7)`. Mixed-weight concatenated `Text` for a headline with one emphasised phrase. All-caps labels are a house choice, not a default; if used, +1.2pt tracking and 11–13pt.

### Layout, spacing and hierarchy → the layout-and-spacing reference below

The eye should land on the headline, then the primary action, within a second. If it does not, the hierarchy is off. One primary action per view. Group secondary actions behind a menu once they exceed three. Design for two items and for two hundred. Never park a critical action below the fold of a fixed-height sheet or behind the keyboard.

### Buttons and controls → the buttons-and-controls reference below

The press-down haptic is non-negotiable: the button heard you. Loading locks its width. Disabled is transparency with a reason. Success reverts in 1.5s. A row with an inner button captures the inner tap first. Sticky CTAs use `.safeAreaInset(edge: .bottom)` with `.background(.bar)` and scroll-react via `.onScrollGeometryChange`.

### Sheets, navigation and trays → the sheets-and-navigation reference below

Directional continuity: forward enters from the trailing edge, back returns to it. Deeper grows in from 0.94; shallower shrinks in from 1.04. Titles live in the parent. Hero transitions use `matchedGeometryEffect` with the radius animating (18 → 38 → 0 on drag-dismiss). Persistent chrome survives the push.

### Haptics → the haptics reference below

Haptics are punctuation, a full stop, not an exclamation mark. Budget them: one success per commit, one selection per detent, light on press-down, nothing on scroll. CoreHaptics for the 10% that deserves a signature: two transients (0.55 sharp 0.30, then 0.9 sharp 0.55 at +85ms) reads as a card materialising. Never double-fire what the system already fires.

### Sound → the sound reference below

Three to five cues, each under 200ms, each with its own volume (celebrate 0.5, success 0.34). `.ambient` category with `.mixWithOthers` so the Ring/Silent switch is respected and music never ducks. Within 10ms of its haptic. Always a settings toggle. Synthesised sound (filtered noise + ring + thud with per-play randomisation) costs zero bundle weight and never repeats exactly.

### Icons and SF Symbols → the icons-and-symbols reference below

One family, one stroke weight, matched to the adjacent text weight. `.symbolEffect(.replace)` for state swaps. Pick 3–5 symbol moments per app and pair each with a haptic. Do morph, do not breathe: `.breathe` and `.pulse` on idle icons are the number-one AI-template tell. Never mix SF Symbols and a custom set in the same row.

### Copy and naming → the copy-and-naming reference below

Verb-first buttons that name the noun ("Delete project", not "OK"). Sentence case by default. An action keeps its name through the whole flow: "Publish" produces "Published". Name navigation by contents ("Library", "Progress"), not by umbrella ("Home"). Errors say what happened and what to do, never apologise, never "Oops". Defaults: no emoji in interface chrome, no em-dashes in UI copy (house style may override both; write the override into the design contract).

### States → the states reference below

The ladder (silent → inline → explicit → Live Activity). Skeletons match structure. Optimistic first, ghost while pending, revert with an inline reason on failure. Feedback taxonomy: minor reversible → capsule toast ~2.2s with Undo; important → inline at the thing that changed; the app acted on your behalf → an action receipt card; destructive → confirm with the noun, then resolve in place.

### Onboarding → the onboarding reference below

Value in three seconds. Four or five rooms, one purpose each: value moment, the one input, the payoff, a permission primer only if the very next thing needs it, a handoff. Sign-in and the paywall are not rooms. Progress is dots, never a bar; the active dot is a capsule 2.5–3× wider that glides. The CTA is pinned a fixed distance from the bottom safe area; body copy grows upward. The launch screen is not a design canvas and contains no text.

### Paywalls and pricing → the paywalls reference below

Value before wall. Real localised price always on screen, both total and per-month. One paid tier (or annual plus monthly). A full-size Close from frame one. Exactly one CTA. Placement: after a value moment, at a metered limit, in onboarding only after a value preview, never on cold launch, never to an existing subscriber. The honesty test: would this still work if the person understood it completely? Nothing on a paywall pulses, throbs, or counts down.

### Widgets, Live Activities and Dynamic Island → the widgets-and-live-activities reference below

Content margins, not safe areas (16pt default, 11 tight). `ContainerRelativeShape()` for every nested corner; never a literal radius. `.containerBackground(for: .widget)` is required. Three render modes are three designs: `.accented` renders from alpha and ignores hue; `.vibrant` hierarchy uses opaque greys, never white at opacity. 11pt floor, no Light weights. A widget's only life is a wash healing across the day and a number rolling when it changes. Dynamic Island compact regions hold ≤ 5 characters; the minimal is a 22×22pt glyph. `Text(timerInterval:)` ticks for free. No confetti, no breathing, no faked press states.

### Liquid Glass (iOS 26) → the liquid-glass reference below

Glass for floating controls only. Tint the one primary action. `.interactive()` instead of your own scale style. Never glass on glass; `GlassEffectContainer` for overlapping surfaces. Content (cards, rows, bubbles) stays solid or gets a flat translucent fill; a refractive card behind a paragraph hurts legibility. Wrap in availability with a material fallback. Do not put glass on the app icon.

### Accessibility as polish → the accessibility reference below

The apps people love are the ones that hold together at AX5, with Reduce Motion, in Increase Contrast, and under VoiceOver. Test those four before calling anything done. Reduce Motion means crossfade, not nothing.

## 5. Anti-patterns and AI tells

Reject on sight. Each of these reads as "made by nobody in particular".

- A symbol that breathes, pulses, or bounces while idle
- Purple → blue → pink gradient; any gradient interpolated in RGB (grey in the middle)
- Confetti on save; a celebration for an ordinary act; silence on a real milestone
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

Each item is checkable in under a minute. Full mode runs the whole list; quick mode runs the starred items.

### States
- [ ] ★ Empty state exists for every list, search, and filter, with one action
- [ ] ★ Loading follows the ladder; nothing spins under 500ms
- [ ] ★ Error appears in context with the last good value still visible
- [ ] Success is acknowledged once, where the result appears
- [ ] Offline state exists and cached content stays usable
- [ ] First-run state differs from the empty state (it invites; it does not apologise)
- [ ] Overflow: 200 items, a 60-character title, a 4-line description all hold
- [ ] Permission denied has its own screen with a path to Settings

### Motion and continuity
- [ ] ★ Every `.animation` has a `value:`
- [ ] ★ Persistent chrome survives transitions in a parent
- [ ] ★ Exit durations are shorter than entrances and have no bounce
- [ ] One `Animation` constant per datum; siblings animate together
- [ ] Stagger only on first appearance, 30–80ms, ≤ 8 items
- [ ] Nothing that follows a finger uses a spring
- [ ] Hero transitions animate radius with size
- [ ] Ambient loops use `TimelineView`, ≥ 1.2s period, and stop when off-screen
- [ ] Reduce Motion swaps to an 180ms crossfade; haptics remain
- [ ] Numbers use `.numericText` + `.monospacedDigit()`

### Hierarchy and layout
- [ ] ★ Eye lands on headline then primary action within a second
- [ ] ★ One primary action per view
- [ ] ★ Same screen margin on every screen
- [ ] Spacing values come from the grid (4/8/12/16/20/24/32)
- [ ] Group gaps ≥ 2× intra-group gaps; no separator plus large gap
- [ ] Hero numerals have 24pt of air
- [ ] At most three radii; nested radius = outer − padding; all `.continuous`
- [ ] Optical nudges on icons and squares-in-circles
- [ ] Critical actions are never under the keyboard or below the fold of a fixed sheet
- [ ] Safe areas are added to padding, not used as padding

### Typography
- [ ] ★ Three sizes carry the hierarchy; weight and opacity do the rest
- [ ] ★ AX5 does not clip; `ViewThatFits` where strings vary
- [ ] Body is leading-aligned
- [ ] No weight under `.regular` below 18pt
- [ ] Tracking untouched except all-caps and 60pt+ display
- [ ] Prose line height ≥ 1.45×
- [ ] Changing numbers are monospaced
- [ ] German and Finnish do not break any label

### Colour and material
- [ ] ★ Every colour has a light and dark pair, hand-checked in both
- [ ] ★ Body contrast ≥ 7:1; secondary ≥ 4.5:1; UI ≥ 3:1
- [ ] Every literal specifies `.displayP3`
- [ ] Gradients use explicit OKLCH stops and ≤ 5% grain
- [ ] Shadows are tinted and faint; dark mode uses a hairline instead
- [ ] Materials only on floating chrome; content stays legible
- [ ] Meaning never carried by colour alone
- [ ] One accent per view; primary colour sits on the background of the CTA

### Controls
- [ ] ★ Every tap target ≥ 44pt with `.contentShape`
- [ ] ★ Press-down haptic + 0.97 scale on every button
- [ ] ★ Loading buttons lock their width
- [ ] Disabled is transparency plus a reason
- [ ] Success reverts after 1.5s
- [ ] Destructive actions name the noun and use `role: .destructive`
- [ ] Sheets use named detents and the project's radius; stacked sheets differ ≥ 25%
- [ ] Sheets inherit tint and scheme from the presenter
- [ ] Drag-dismiss commits on 120pt or 600pt/s; upward flick cancels
- [ ] Sliders and dials are linear; `.selection` haptic at detents only

### Haptics and sound
- [ ] ★ Nothing fires on scroll, launch, or foreground notifications
- [ ] One `.success` per commit
- [ ] Generators are prepared before predictable moments
- [ ] Sound cues < 200ms, `.ambient` + `.mixWithOthers`, toggle in Settings
- [ ] Haptic and sound land within 10ms of each other
- [ ] Nothing double-fires a system haptic

### Icons
- [ ] ★ One family, one stroke weight, matched to text weight
- [ ] State changes use `.symbolEffect(.replace)`
- [ ] No idle animation on any symbol
- [ ] Selected = `.fill` variant; unselected = outline

### Copy and naming
- [ ] ★ Buttons are verb-first and name the noun
- [ ] ★ Errors say what happened and what to do
- [ ] One capitalisation policy per element type
- [ ] An action keeps its name across the flow
- [ ] Navigation named by contents
- [ ] Empty states invite; they do not apologise
- [ ] Toggles label the ON state
- [ ] Emoji and dash policy matches the design contract

### Accessibility
- [ ] ★ VoiceOver reads every screen in a sensible order
- [ ] ★ Reduce Motion, Reduce Transparency, Increase Contrast each tested
- [ ] Custom controls carry traits and values
- [ ] Progress dots hidden; container carries "Step n of m"
- [ ] Focus lands sensibly after a sheet opens or a destructive confirm appears

### Onboarding, paywall, widgets (when present)
- [ ] Onboarding ≤ 5 rooms; dots not bars; CTA pinned
- [ ] Permission primer only where the next step needs it; one button
- [ ] Paywall: Close visible from frame one, price plain, one CTA, restore link, no urgency theatre
- [ ] Widgets: `ContainerRelativeShape`, content margins, three render modes tested, StandBy red tint tested
- [ ] Live Activity ≤ 160pt; compact ≤ 5 characters; ends with a short summary

## 7. Decisions register

Where sources disagree, this skill takes these positions. Change them only in the project's design contract.

| Topic | Decision |
|---|---|
| Grid | 4pt base, 8pt rhythm, 16/20/24 margins |
| Exit curve | Accelerating exit at ~0.65× entrance, bounce 0; entrances never `.easeIn` |
| Spring notation | `.spring(duration:bounce:)`; `bounce ≈ 1 − dampingFraction` |
| Springs vs curves | Springs for gesture-driven, interruptible, or weighted objects; curves for colour and opacity; opacity never springs |
| Press scale | Rows 0.99 · surfaces 0.97 · small icons 0.94 · floor 0.90; opacity 0.9 |
| Stagger | 30–80ms, first appearance only, cap ~8 |
| Dark mode black | Near-black carrying the palette's hue; true black only for media-first chrome or a written OLED decision |
| Hit area | 44pt; macOS pointer 24pt |
| Reduce Motion | 180ms crossfade; keep haptics and functional feedback |
| Long-press | 0.45s reactions, 0.5s system, 0.7s destructive |
| Confetti | Rare milestones only, ≤ 1 per session, 60–120 particles, ≤ 3s, never in widgets |
| Widget margins | 16pt default / 11pt tight; `ContainerRelativeShape` |
| Onboarding length | 4–5 rooms; longer only when each step builds toward one payoff |
| Emoji / em-dash | Defaults: none in chrome, none in UI copy; house style may override in the design contract |
| Icons | Two states (outline, fill), not three |
| Toasts | Only for minor, reversible, global outcomes; ~2.2s with Undo; anything with an action persists |

## 8. Further reading inside this skill

- the anti-patterns reference below for the long-form tells with the fix for each
- the audit-checklist reference below for the printable checklist with the "how to check" column
- the design-contract-template reference below for the 15-line contract and a filled example
- `assets/` for drop-in Swift: `Motion.swift`, `Haptics.swift`, `PressableButtonStyle.swift`, `DisplayP3Color.swift`, `LoadingButton.swift`, `OnboardingDots.swift`, `Shimmer.swift`, `SheetPresets.swift`

---

# References

Claude Code loads these on demand. In this build they are inlined in full.

<!-- references/audit-checklist.md -->

## Audit checklist

Use this when running a quick or full audit, or as the definition of done before a release. Every row says how to verify it in under a minute. ★ marks the quick-audit set.

### The one-hour audit, in order

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

### States

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

### Motion and continuity

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

### Hierarchy and layout

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

### Typography

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

### Colour and material

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

### Controls

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

### Haptics and sound

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ Nothing fires on scroll, launch, or foreground notifications | Scroll a long list; launch cold; receive a push | MEDIUM |
| One `.success` per commit | Complete a batch action; count pulses | LOW |
| Generators prepared before predictable moments | `grep -rn "prepare()" Sources/` near long-press and capture | LOW |
| Sound cues < 200ms, `.ambient` + `.mixWithOthers`, toggle in Settings | Play music, trigger a cue; music must not duck; flip the ringer | MEDIUM |
| Haptic and sound land within 10ms | Trigger with both on; no perceptible gap | LOW |
| Nothing double-fires a system haptic | Open a context menu; count pulses | LOW |

### Icons

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ One family, one stroke weight, matched to text weight | Screenshot a toolbar; compare stroke to adjacent text | MEDIUM |
| State changes use `.symbolEffect(.replace)` | Toggle a favourite at 10% speed | LOW |
| No idle animation on any symbol | `grep -rn "symbolEffect(.breathe\|.pulse" Sources/` | MEDIUM |
| Selected = `.fill`; unselected = outline | Select a tab | LOW |

### Copy and naming

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

### Accessibility

| Check | How to verify | Severity if failed |
|---|---|---|
| ★ VoiceOver reads every screen in a sensible order | Swipe through each screen | HIGH |
| ★ Reduce Motion, Reduce Transparency, Increase Contrast each tested | Toggle each; walk the primary path | HIGH |
| Custom controls carry traits and values | Accessibility Inspector audit | HIGH |
| Progress dots hidden; container carries "Step n of m" | VoiceOver on the onboarding flow | MEDIUM |
| Focus lands sensibly after a sheet or destructive confirm | Open each with VoiceOver on | MEDIUM |

### Onboarding, paywall, widgets (when present)

| Check | How to verify | Severity if failed |
|---|---|---|
| Onboarding ≤ 5 rooms; dots not bars; CTA pinned | Count screens; watch the CTA position across pages | MEDIUM |
| Permission primer only where the next step needs it; one button | Read each primer | HIGH |
| Paywall: Close visible from frame one, price plain, one CTA, restore link, no urgency theatre | Screenshot the paywall at 0ms; read it | HIGH |
| Widgets: `ContainerRelativeShape`, content margins, three render modes tested, StandBy red tint tested | Preview each mode | MEDIUM |
| Live Activity ≤ 160pt; compact ≤ 5 characters; ends with a summary | Preview; read the compact strings | MEDIUM |

### Before you ship

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

<!-- references/design-contract-template.md -->

## Design contract template (iOS)

Use this when the project has no written design system, or when the intake table has empty rows. Fill it in with the project owner, commit it as `DESIGN.md` (or a section of `AGENTS.md`), and polish inside it. Fifteen lines is the target. If it needs more, the project has more than one style.

### Why a contract before polish

Polish applied without a contract produces a second style that competes with the first. Every later contributor (human or agent) will guess again. Fifteen lines stop the guessing.

### The template

```
## Design contract

1. Purpose: <one sentence: who this is for and the feeling it should leave>
2. Type: <faces by role; e.g. "SF Pro only. Rounded for glanceable numerals. No serif."> Spine: <e.g. 17 / 22 / 28>. Heaviest weight: <e.g. semibold>.
3. Colour: <base pair light/dark, ink pair, ONE accent and what it means>. Pick in OKLCH, ship in Display P3. Muted text = ink at <0.62 / 0.45 / 0.28>.
4. Dark mode: <"lower L, hold C and H" or "hand-tuned pairs in Assets">. True black: <yes for media chrome only / no>.
5. Grid: 4pt. Screen margin <20>. Card padding <16>. Hero air <24>.
6. Radii: <e.g. 8 / 14 / 24>, all .continuous. Pills are Capsule. Nested = outer minus padding.
7. Depth: <"no shadows; hairline 0.5pt at ink 10%" or "shadow 0.06/8/4 light, 1pt white 6% stroke dark">.
8. Motion: named presets in <Motion.swift>: press <0.16/0>, state <.snappy 0.24>, arrive <0.42/0.16>, calm <.smooth 0.3>, follow-finger <.linear>. Exits at 0.65x. Stagger <40ms>, first appearance only. Reduce Motion = 180ms crossfade.
9. Haptics: press-down .light; one .success per commit; .selection at detents; nothing on scroll. Signature moment: <one, or none>.
10. Sound: <none / 3-5 cues under 200ms, .ambient, toggle in Settings>.
11. Sheets: radius <28>, detents <.medium/.large by job>, drag indicator <visible unless Close exists>, inherit tint and scheme.
12. Icons: <SF Symbols, one weight matched to text> or <custom family, stroke 1.7 at 24>. Never both in one row. Fill = selected.
13. Copy: sentence case. Verb-first buttons naming the noun. Emoji in chrome: <no>. Em-dashes: <no>. Voice: <two adjectives>.
14. States: every list has empty, loading, error. Spinner after 500ms, where the result lands. Errors inline; toasts only for reversible global outcomes.
15. Not allowed: <three things this project will never do, e.g. "breathing icons, confetti on save, purple gradients">.
```

### A filled example (a fictional habit tracker, to show the density expected)

```
## Design contract

1. Purpose: a quiet daily companion for people who want to keep one habit. It should feel like a well-made notebook, not a dashboard.
2. Type: SF Pro only. Rounded for the streak numeral. Spine 17 / 22 / 28. Heaviest weight semibold.
3. Colour: base #FFFFFF / #141414 (P3), ink #1A1A1A / #EDEDED, one accent: moss (OKLCH 0.62 0.11 145) meaning "done". Muted = ink at 0.62 / 0.45 / 0.28.
4. Dark mode: lower L, hold C and H. True black: no.
5. Grid: 4pt. Screen margin 20. Card padding 16. Hero air 24.
6. Radii: 10 / 16 / 24, all .continuous. Pills are Capsule. Nested = outer minus padding.
7. Depth: no shadows. Hairline 0.5pt at ink 10%. Dark elevation = 1pt white 6% stroke.
8. Motion: Motion.swift presets: press 0.16/0, state .snappy(0.24), arrive 0.42/0.14, calm .smooth(0.3), follow-finger .linear. Exits 0.65x. Stagger 40ms on first appearance. Reduce Motion = 180ms crossfade.
9. Haptics: press-down .light; .success once when the day is marked; .selection crossing week boundaries. Signature: a soft two-tap when the streak rolls over.
10. Sound: none.
11. Sheets: radius 24, .medium for the picker, .large for edit, drag indicator visible, inherit tint.
12. Icons: SF Symbols, regular weight beside body, semibold beside headlines. Fill = selected.
13. Copy: sentence case. Verb-first ("Mark today", "Edit habit"). Emoji: no. Em-dashes: no. Voice: calm, plain.
14. States: empty invites ("Start with one habit"), loading is a matching skeleton after 500ms, errors inline under the field.
15. Not allowed: breathing icons, confetti, streak-loss guilt copy, any second accent.
```

### Checks

- Every row has a value, not a question.
- Row 3 has exactly one accent with a stated meaning.
- Row 8 names a file. If the file does not exist, create it from `assets/Motion.swift`.
- Row 15 lists things the project is actually tempted by, not generic sins.
- The contract is committed before the first polish change lands.

### Do not

- Write a contract longer than a screen. Split styles, do not merge them.
- Fill rows with "TBD". An empty row is a finding; a TBD row is a lie.
- Let the contract restate this skill. It records the project's choices, not the skill's defaults.

<!-- references/anti-patterns.md -->

## Anti-patterns and AI tells

Use this when a screen "feels generic" and you cannot say why, or as the last pass before shipping. Every entry names why it reads as careless, the fix, and a way to find it in code. The list is negative: removing these does not impose a style, it removes the smell of no style.

### Motion

#### The breathing symbol
An SF Symbol that pulses, breathes, or bounces while nothing is happening.
Why it reads as careless: it is the default "make it feel alive" move from every template. It also lies; nothing is happening.
Fix: remove the idle effect. Keep `.symbolEffect(.replace)` for state changes and one `.bounce` on a real event.
Spot it: `grep -rn "symbolEffect(.breathe\|symbolEffect(.pulse\|repeatForever" Sources/`

#### The teleport
A value changes and the view jumps to its new state with no transition.
Why: the eye loses the object; it looks like a bug or a reload.
Fix: `.animation(Motion.state, value: model.value)` on the container, `.contentTransition(.numericText())` on numbers.
Spot it: state-bearing views with no `.animation(_:value:)` nearby; toggle the state in a preview and watch.

#### The unscoped animation
`.animation(.default)` with no `value:`, or `withAnimation` wrapping a big state change.
Why: everything animates, including things that should not, and unrelated layout jitters.
Fix: every `.animation` gets a `value:`; `withAnimation` wraps only the assignment it is about.
Spot it: `grep -rn "\.animation(\.[a-zA-Z]*)" Sources/ | grep -v "value:"`

#### Springs on the finger
A slider, scrubber, or drag that lags behind the touch.
Why: the finger is the truth; a spring argues with it.
Fix: `.linear` or no animation while dragging; spring only on release, seeded with the gesture velocity.
Spot it: `DragGesture` bodies that call `withAnimation(.spring`.

#### Exit that lingers or bounces
The sheet takes as long to leave as it took to arrive, and overshoots on the way.
Why: people want out faster than they wanted in; a bouncy exit feels needy.
Fix: exit at ~0.65× the entrance duration with `bounce: 0`.
Spot it: the same `Animation` constant used for present and dismiss.

#### Everything staggers, always
List rows cascade in every time the view appears or scrolls.
Why: the second time it is a delay, not a delight.
Fix: stagger on first appearance only (a `hasAppeared` flag), 30–80ms, cap ~8 items.
Spot it: `.delay(Double(index)` without a guard.

#### The 60fps Timer
A `Timer.publish(every: 1/60)` driving UI.
Why: it burns battery, drifts, and fights the display refresh rate.
Fix: `TimelineView(.animation)` for ambient loops; `Text(timerInterval:)` for clocks.
Spot it: `grep -rn "Timer.publish\|Timer.scheduledTimer" Sources/`

#### Title in, title out
On push, the title animates out of the source and back into the destination.
Why: the same object leaves and returns; the screen reads as two places instead of one that changed.
Fix: render persistent chrome in a parent that survives the transition (`NavigationStack` title, toolbar).
Spot it: the same `Text(title)` inside both source and destination bodies.

### Colour

#### The template gradient
Purple to blue to pink, or any gradient interpolated in RGB with a grey trough in the middle.
Why: it is the most-shipped AI colour choice of the decade, and the RGB lerp is muddy.
Fix: compute stops in OKLCH and pass explicit `stops:`; add ≤ 5% grain to stop banding.
Spot it: `LinearGradient(colors: [.purple, .blue` or any two-colour gradient across hues.

#### sRGB by accident
`Color(red:green:blue:)` with no colour space.
Why: it silently produces sRGB on a P3 display; the accent looks dull next to system colours.
Fix: `Color(.displayP3, red:green:blue:)` or a P3 hex helper.
Spot it: `grep -rn "Color(red:" Sources/ | grep -v displayP3`

#### One hex, no pair
A colour literal with no dark-mode counterpart.
Why: it either glares or vanishes in the other appearance.
Fix: light/dark pairs via the asset catalog or `Color.pair(light:dark:)`.
Spot it: hex literals outside the token file.

#### True black by default
`Color.black` as the app background in a non-media app.
Why: pure black makes every shadow disappear and every surface float; it is a media decision, not a default.
Fix: near-black carrying the palette's hue; elevation via a 1pt white 6% stroke.
Spot it: `.background(.black)` or `Color.black` at the root.

#### Disabled means grey
`.opacity(0.4)` or a grey fill for a disabled control, with no explanation.
Why: grey reads as broken; opacity fails contrast unpredictably.
Fix: transparency with the control's own colour, plus a reason string next to it.
Spot it: `.disabled(` with no adjacent explanatory `Text`.

#### Colour alone carries meaning
A red row means overdue; nothing else says so.
Why: 8% of men cannot see it.
Fix: pair with a symbol or a label.
Spot it: status views with `foregroundStyle` and no `Image` or text.

### States

#### Spinner on the button
Tap a button and it spins in place.
Why: progress belongs where the result will appear; the button is where the action was.
Fix: the spinner travels: into the bubble, the thumbnail, the row.
Spot it: `ProgressView()` inside a `Button` label.

#### Spinner under 500ms
Every fetch shows a spinner immediately.
Why: it flashes, and a flash reads as instability.
Fix: nothing before 500ms (optimistic if possible), then a matching skeleton.
Spot it: `isLoading` bound directly to a `ProgressView` with no delay.

#### Skeleton that lies
Three grey bars for content that will have five lines and an image.
Why: the swap is a layout shift; the illusion breaks.
Fix: skeletons mirror the real layout exactly.
Spot it: compare the skeleton view and the loaded view side by side.

#### Toast in the sky
A field fails validation and a toast appears at the top of the screen.
Why: the error is far from its cause; the user looks at the field, not the sky.
Fix: inline, under the field, rising from it; toasts only for reversible global outcomes.
Spot it: a single global `ToastView` bound to every error.

#### "No items."
An empty list says "No items" and nothing else.
Why: it is the first impression for every new user, and it apologises.
Fix: a symbol, one warm line of why, one action.
Spot it: `ContentUnavailableView` with no `actions:`; `Text("No ` in empty states.

#### Undo that only hides the toast
"Undo" dismisses the message and leaves the deletion in place.
Why: it is a lie with a button on it.
Fix: undo reverses the effect; otherwise do not offer it.
Spot it: the undo closure touches only UI state.

### Controls

#### The glyph-only target
An icon button whose tappable area is the icon itself.
Why: a 24pt target misses half the time.
Fix: `.frame(minWidth: 44, minHeight: 44).contentShape(Rectangle())`.
Spot it: icon `Button`s with no `contentShape`.

#### The silent press
A button with no touch-down feedback.
Why: the user cannot tell whether the app heard them.
Fix: `PressableButtonStyle` (0.97 scale, light haptic on touch-down).
Spot it: `Button` with `.buttonStyle(.plain)` and nothing else.

#### Loading that reflows
The button label becomes a spinner and the button changes width.
Why: everything beside it jumps.
Fix: lock the width before swapping the label.
Spot it: `if isLoading { ProgressView() } else { Text(` inside a button with no fixed frame.

#### Two filled buttons
Primary and secondary both filled, side by side.
Why: there is no primary any more.
Fix: one filled, one text or outlined.
Spot it: two `.borderedProminent` in one `HStack`.

#### "Are you sure?" with Yes / No
Why: it names nothing; the user has to reconstruct what will happen.
Fix: "Delete project?" with "Delete project" (`role: .destructive`) and "Cancel".
Spot it: `grep -rn "Are you sure" Sources/`

#### Identical stacked sheets
A sheet presents a sheet of the same height.
Why: the user sees one layer swap and loses depth.
Fix: heights differ by ≥ 25%.
Spot it: nested `.sheet` with the same `presentationDetents`.

#### The wrong sheet radius
System 10pt corners on an app whose cards are 24pt.
Why: the sheet is the only surface in the app with a different language.
Fix: `.presentationCornerRadius(project.largeRadius)`.
Spot it: `.sheet` with no `presentationCornerRadius`.

### Copy

#### Oops
"Oops! Something went wrong."
Why: it apologises, explains nothing, and offers nothing.
Fix: "Unable to save. Check your connection and try again."
Spot it: `grep -rni "oops\|something went wrong" Sources/`

#### Emoji in chrome
Emoji in navigation titles, buttons, or error text (when the design contract does not ask for them).
Why: it reads as a template and it does not localise.
Fix: SF Symbols in chrome; emoji only where the contract allows.
Spot it: emoji ranges in string literals inside `Text(` of titles and buttons.

#### The renaming action
"Publish" produces "Your post has been shared successfully!"
Why: the user pressed Publish; the outcome should say Published.
Fix: an action keeps its name through the flow.
Spot it: success strings that do not contain the verb of the button that caused them.

#### Home
A tab named "Home" for a screen that is a feed of the user's progress.
Why: it names nothing; the user learns nothing from the label.
Fix: name navigation by contents: "Progress", "Library", "Inbox".
Spot it: `Label("Home"`.

#### Centred body text
Paragraphs centred under a headline.
Why: the eye cannot find the start of the next line.
Fix: `.multilineTextAlignment(.leading)` for anything over one line.
Spot it: `.multilineTextAlignment(.center)` on multi-line `Text`.

### Structure

#### The 8pt-only grid
Every padding is 8, 16, 24, 32.
Why: 12 and 20 are the values that make rows breathe; without them everything is either cramped or loose.
Fix: 4pt base with 8 as the rhythm.
Spot it: no 12 or 20 anywhere in `.padding(`.

#### Four-bucket daypart
Morning / afternoon / evening / night colours switched at fixed hours.
Why: the wash jumps at 6pm; a continuous interpolation was the whole point.
Fix: interpolate by minutes of day, ease over ~1.6s when it changes.
Spot it: a `switch hour` returning colours.

#### Launch screen with text
A logo and a tagline on the launch storyboard.
Why: it cannot localise, it flashes, and it delays the first real frame.
Fix: the launch screen matches the first screen's chrome and has no text.
Spot it: `LaunchScreen.storyboard` with a `UILabel`.

#### Confetti on save
A particle burst on an ordinary action.
Why: the inversion: theatre for the routine, silence for the milestone.
Fix: rare milestones only, ≤ 1 per session, 60–120 particles, ≤ 3s.
Spot it: confetti calls in save or complete handlers.

#### Haptic spam
`.selection` on every scroll tick; `.success` on every read receipt.
Why: haptics are punctuation; a page of full stops is noise.
Fix: one per commit, one per detent, nothing on scroll.
Spot it: `sensoryFeedback` inside `onScrollGeometryChange` or a `ForEach` body.

### Widgets and paywalls

#### The shrunk screen
A widget that is a miniature of the app's home view.
Fix: one number, one label, one wash. See `widgets-and-live-activities.md`.
Spot it: a widget view that reuses the app's screen view.

#### The paywall on cold launch
Why: the user has received nothing yet; the ask is pure friction.
Fix: after a value moment or at a metered limit.
Spot it: paywall presentation in `onAppear` of the root view.

#### The breathing PRO badge
A badge or CTA that pulses to create pressure.
Why: calm converts and keeps; pulsing reads as manipulation.
Fix: static badge, one clear CTA.
Spot it: `repeatForever` in the paywall.

#### Hidden monthly
Only the annual price shown, monthly greyed out or missing.
Why: it is a dark pattern, and App Review knows it.
Fix: both prices, annual preselected is fine, both readable.
Spot it: a product list filtered to one option.

<!-- references/accessibility.md -->

## Accessibility as polish

Use this when auditing or building any screen. The apps people describe as "beautifully made" are the ones that still hold together at the largest Dynamic Type, with Reduce Motion on, in Increase Contrast, and under VoiceOver. These four settings are the polish test most apps never run.

### Rules

1. **Test four settings before calling anything done:** Dynamic Type at `.accessibility5`, Reduce Motion, Increase Contrast, VoiceOver. Why: each one exposes a different class of shortcut. Check: a launch scheme exists for each (see Code).
2. **Dynamic Type to AX5 without clipping.** Use semantic `Font` styles. Wrap any row with a variable string in `ViewThatFits` with a tighter variant. Let `VStack`s replace `HStack`s at large sizes with `@Environment(\.dynamicTypeSize)`. Cap scaling only on chrome that must not grow (`.dynamicTypeSize(...DynamicTypeSize.xxxLarge)`), never on body content. Why: about a third of users run larger-than-default text; AX sizes are common among older users. Check: run at AX5; every label readable, no overlapping, no truncated buttons.
3. **Reduce Motion means crossfade, not nothing.** Replace travel, scale, and 3D with an 180ms `.easeInOut` opacity change. Keep haptics and functional feedback. Replace `matchedGeometryEffect` with a fast crossfade. Stop ambient loops. Why: stripping all animation makes the app feel broken; iOS itself substitutes crossfades. Check: `@Environment(\.accessibilityReduceMotion)` is read in every custom transition; toggling it changes behaviour.
4. **The environment value does not reach every kind of motion.** `@Environment(\.accessibilityReduceMotion)` and `UIAccessibility.isReduceMotionEnabled` change nothing on their own; they are values you must read. Four kinds of motion live outside the SwiftUI transition system and keep moving unless you guard them by hand: a `CADisplayLink` or `Timer` render loop, `TimelineView(.animation)`, a SpriteKit, SceneKit, or Metal scene, and an autoplaying `AVPlayer` or looping `VideoMaterial`. Why: this is the single most common Reduce Motion bug, because the rest of the app looks correct while the largest movement on screen carries on. Check: `grep -rn "TimelineView(.animation)\|CADisplayLink\|\.autoplay\|SKView\|MTKView" Sources` and confirm each hit reads the value; then turn Reduce Motion on and watch the screen for five seconds with your hands off the device.
5. **Reduce Transparency means solid fills.** Every `Material` gets a solid fallback via `@Environment(\.accessibilityReduceTransparency)`. Why: blurred surfaces are unreadable for many low-vision users. Check: toggle the setting; no blur remains.
6. **Increase Contrast is a real pass, not a hope.** Read `@Environment(\.colorSchemeContrast)`; when `.increased`, lift secondary text to at least 4.5:1 and borders to 3:1. Why: your muted tertiary text at 3:1 is invisible to a meaningful share of users. Check: toggle; secondary and tertiary text darken.
7. **VoiceOver reads every screen in a sensible order.** Group rows with `.accessibilityElement(children: .combine)`. Give every image a label or hide it with `.accessibilityHidden(true)` if decorative. Never let the reading order differ from the visual order without a reason. Why: a card that reads "image, 12, chevron, Bank transfer" is not usable. Check: swipe through the screen with VoiceOver; every element says what it is and what it does.
8. **Custom controls carry traits and values.** `.accessibilityAddTraits(.isButton)` on tappable non-buttons; `.accessibilityValue` on anything with a state; `.accessibilityRepresentation { Slider(...) }` on custom sliders and dials so VoiceOver gets the real gestures. Why: a gesture-driven dial is invisible to a screen reader without a representation. Check: every `onTapGesture` on a non-Button has a trait.
9. **Audit the custom controls by counting them.** Every control you build by hand owes VoiceOver what the system control would have given for free: a label, a role, and a value. The fastest way to find the gaps is to count the two sides and compare. Run `grep -rc "onTapGesture" Sources` against `grep -rc "accessibilityAddTraits" Sources`, and `grep -rc "DragGesture" Sources` against `grep -rc "accessibilityRepresentation" Sources`. Why: a tap gesture with no trait is a control VoiceOver cannot see is a control, and this is invisible in every visual review. Check: the counts are close, and each unmatched hit is a deliberate decision you can name.
10. **Progress dots are hidden; the container carries the value.** `.accessibilityHidden(true)` on the dots, `.accessibilityValue("Step 2 of 4")` on the flow container. Why: five unlabeled circles read as "button, button, button". Check: VoiceOver says "Step 2 of 4" once.
11. **Move focus after a sheet opens or a destructive confirm appears.** `@AccessibilityFocusState` bound to the sheet title or the least destructive action. Why: without it VoiceOver stays on the element behind the sheet. Check: open a sheet with VoiceOver on; the first announcement is the sheet's title.
12. **44×44pt targets.** A 24pt glyph gets padding to 44 and `.contentShape(Rectangle())`. Why: without `.contentShape` only the glyph is tappable. Check: tap the padding around every icon button; it responds.
13. **Colour never carries meaning alone.** Pair with a symbol, a label, or a shape. Honour `@Environment(\.accessibilityDifferentiateWithoutColor)` by adding shapes or labels when it is on. Why: about 8% of men cannot separate red from green. Check: view the screen in greyscale; every status still reads.
14. **Voice Control names match visible labels.** If a button shows "Save", its accessibility label starts with "Save". Why: users say what they see. Check: no `.accessibilityLabel` that renames a visible label.
15. **Bold Text and Button Shapes are supported, not fought.** Read `@Environment(\.legibilityWeight)`; do not hard-code `.regular` on body. With Button Shapes on, plain-text buttons gain an underline; make sure that reads fine. Why: these are system promises; overriding them breaks trust. Check: toggle both; nothing looks broken.
16. **Photos and artwork ignore Smart Invert.** `.accessibilityIgnoresInvertColors()` on images, video, and colour swatches. Why: an inverted photo is an error, not a preference. Check: Smart Invert on; photos stay natural.
17. **Assistive Access is a distinct shape.** If the app opts in, provide a simplified scene with large controls; do not just ship the default. Check: `UISupportsFullScreenInAssistiveAccess` and a tested layout.
18. **Announce what changes off-screen.** `AccessibilityNotification.Announcement("Saved").post()` for outcomes the user cannot see; use it sparingly and never for every keystroke. Check: a save with VoiceOver on says "Saved" once.
19. **Haptics are not gated by motion settings.** Reduce Motion does not turn off haptics; keep firing them. Check: with Reduce Motion on, the press haptic still fires.

### Cheat sheet

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

| Motion that the environment value does not stop by itself | Guard |
|---|---|
| `CADisplayLink` or `Timer` render loop | read the value; do not start, or render the settled frame |
| `TimelineView(.animation)` | swap the schedule for `.everyMinute` or a static value |
| SpriteKit, SceneKit, Metal scene | pause the scene, or set it to its resting state |
| Autoplaying `AVPlayer`, looping video | do not autoplay; show a poster and a play control |

Targets: 44×44pt. Contrast: body 7:1 (4.5 floor), secondary 4.5:1, UI 3:1.

### Code

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

Motion that lives outside the transition system, guarded by hand:

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

// TimelineView: swap the schedule, do not just change the body.
TimelineView(reduceMotion ? .everyMinute : .animation) { context in
    Wash(date: context.date)
}

// Display link: never start it.
.onAppear { if !reduceMotion { link.add(to: .main, forMode: .common) } }
.onChange(of: reduceMotion) { _, reduce in reduce ? link.invalidate() : link.add(to: .main, forMode: .common) }

// Video: a poster and a control, not autoplay.
if reduceMotion { PosterFrame(asset: asset) } else { LoopingPlayer(asset: asset) }
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

### Checks

- Run the app at AX5 in German; every screen scrolls, nothing overlaps, every button is reachable.
- Toggle Reduce Motion: transitions crossfade in ~180ms; haptics still fire; ambient loops stop.
- With Reduce Motion on, put your hands down and watch each screen for five seconds; nothing moves on its own, including video, particles, and any Metal or SpriteKit surface.
- Compare `grep -rc "onTapGesture"` with `grep -rc "accessibilityAddTraits"`; every unmatched hit is a decision you can defend.
- Toggle Reduce Transparency: no blurred surface remains.
- Toggle Increase Contrast: secondary text darkens; hairlines strengthen.
- VoiceOver swipe pass on each screen: order matches visual, every element has a name and a role, sheets take focus.
- Xcode Accessibility Inspector audit on each screen: zero "element has no description" and zero "hit region too small".
- Greyscale screenshot of every status view: all statuses still distinguishable.
- Smart Invert on: photos and swatches unchanged.

### Do not

- Cap Dynamic Type on body content to protect a layout.
- Turn off all animation under Reduce Motion.
- Rename a visible label in `.accessibilityLabel`.
- Ship an `onTapGesture` without a button trait.
- Assume reading `accessibilityReduceMotion` somewhere means every kind of motion is covered.
- Leave a `TimelineView(.animation)`, display link, or autoplaying video running under Reduce Motion.
- Rely on the default reading order of a custom card.
- Use `accessibilityHidden` to hide something because it was awkward to label.
- Announce every keystroke or every scroll position.

<!-- references/buttons-and-controls.md -->

## Buttons and controls

Use this when you are building or reviewing any tappable thing: buttons, CTAs, chips, rows, toggles, segmented controls, sliders, floating actions.
Buttons are the most-pressed surface in the app. Their press feel, state handling, and hierarchy do more for "considered" than almost anything else.

### Rules

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

### Cheat sheet

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

### Code

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

### Checks

- Tap the padding of every icon button; it fires.
- Press and hold: scale 0.97, haptic fired once on the way down, nothing on the way up.
- Start a load: measure the button before and after; identical width.
- Disable a control: a reason is visible without tapping anything.
- Count filled accent buttons per screen: one.
- Drag a slider slowly; the thumb never lags or overshoots the finger.
- Trigger a failure: the message is inline, under the control, with a "Try again" path.
- Turn on Reduce Motion: press feedback still works (it is 0.16s and small; keep it).

### Do not

- Put `.sensoryFeedback` on release.
- Scale a row or list cell below 0.99.
- Use a custom spinner inside a button; `ProgressView()` adapts to scheme and Reduce Motion.
- Ship two filled buttons side by side.
- Style a destructive action like the primary.
- Use "Submit", "OK", or "Yes / No" as labels (see `references/copy-and-naming.md`).
- Let a floating action button cover the last row; move it out of the way on scroll.
- Spring a slider thumb.
- Wrap glass buttons (iOS 26) in your own scale style; `.interactive()` already does it (see `references/liquid-glass.md`).

<!-- references/color.md -->

## Colour and material

Use this when you are defining, auditing, or fixing colour tokens, dark mode, gradients, shadows, or translucent surfaces in a SwiftUI app.
It does not pick a palette. It makes the project's palette hold together in both appearances and on wide-gamut screens.

### Rules

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

### Cheat sheet

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

### Code

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

### Checks

- Every `Color(` literal names `.displayP3` or goes through `p3` / `p3d`.
- One `ink` token; secondary and tertiary are opacities of it.
- Contrast measured on the darkest surface each token appears over, in both appearances.
- Every gradient has ≥ 5 stops and a grain overlay.
- Every `.shadow(` opacity ≤ 0.18 and paired with a dark-mode hairline.
- No material or glass behind more than two lines of text.
- Each extension target compiled and viewed in both appearances.
- Greyscale pass: every status still readable.

### Do not

- Derive dark mode by inversion or by multiplying the light palette.
- Use `.gray`, `.secondary`, and a custom muted token in the same app; pick one system.
- Put two filled accent controls on one screen.
- Use a two-stop gradient between saturated colours.
- Use a warm or cool tinted shadow at opacity above 0.18; it reads as dirt.
- Ship true black without writing the decision into the design contract.
- Tint a material grey when the project's palette has a hue; the fill should carry the hue.

See also: `references/typography.md` for text colour hierarchy, `references/liquid-glass.md` for iOS 26 materials, `references/widgets-and-live-activities.md` for render modes that override your colours.

<!-- references/copy-and-naming.md -->

## Copy and naming

Use this when writing or reviewing any user-facing string: button labels, titles, navigation, errors, empty states, placeholders, permissions, notifications, settings.
Copy is the layer users read most and designers review least. One wrong verb on a button costs more than a wrong radius.

### Rules

1. **Buttons are verb-first and name the noun.** "Save photo", "Delete project", "Send to Sam". Why: the label is the contract; "OK" and "Submit" promise nothing. Check: read every button alone, out of context; you know what happens.
2. **Sentence case by default, one policy per element type.** Why: mixed casing across screens reads as many hands. Check: buttons, titles, and labels each follow one rule everywhere. Title Case is a house choice; write it in the design contract.
3. **Pick "Continue" or "Next" and use it everywhere.** "Get started" enters a flow; "Done" finishes it. Check: grep for both; only one appears in flows.
4. **An action keeps its name through the whole flow.** "Publish" produces "Publishing…" then "Published". Why: renaming mid-flow makes the user wonder if something else happened. Check: follow one verb from button to toast.
5. **Name navigation by its contents, not by an umbrella.** "Library", "Progress", "Inbox", not "Home" or "Dashboard". Check: every tab and nav title answers "what is in here".
6. **Errors say what happened and what to do.** Calm, plain, zero playfulness. Never apologise, never "Oops", never "We're having trouble". Check: every error has a noun and a next step.
7. **Toggles label the ON state.** "Send read receipts", never "Don't send read receipts". Check: no toggle label starts with a negative.
8. **Placeholders are examples, not labels.** `name@example.com`, `DD/MM/YYYY`. The label sits above or beside the field. Check: clear the field; the label is still visible.
9. **Never concatenate around variables.** Use `String(localized:)` with a full sentence and a plural rule. Why: word order and plural forms differ per language. Check: no `"You have " + n + " items"` anywhere.
10. **Destructive confirmations name the noun on the button.** Title: "Delete this project?". Buttons: "Delete project" (destructive) and "Cancel". Check: no "Are you sure?" with Yes / No.
11. **Permission primers explain why and what happens, then one button titled "Continue" or "Next".** Never "Allow". Why: App Review 5.1.1(iv) treats a pre-alert "Allow" as manipulation. Check: exactly one button, no Cancel, no fake alert.
12. **Notification title is the headline, not the app name.** The system shows the app name already. Prefer relative time ("updated 4 min ago"). Check: no notification title equals the app name.
13. **Device verbs match the device.** "Tap" on touch, "click" with a pointer, "select" when both. Check: an iPad app with keyboard support does not say "tap".
14. **A person's name appears at most once per session.** Why: repeated names read as a mail merge. Check: grep for the name interpolation; one site in the greeting.
15. **No manufactured personalisation.** No streak guilt, no "we miss you", no "day 7" counters unless the product is a streak product, no randomised synonym greetings. Why: fake warmth reads as a template. Check: every personal line is derived from real user data and would survive the user seeing the code.
16. **Gender-neutral phrasing.** "Subscribers can post recipes", not "A subscriber can post his recipes". Check: no he/she in interface strings.
17. **Emoji in interface chrome: default off. Em-dashes in UI copy: default off.** House style may override either; if it does, write the rule and the allowed contexts into the design contract. Check: grep for the em-dash character and for emoji ranges in `Localizable.xcstrings`.

### Cheat sheet

| Bad | Good | Why |
|---|---|---|
| Submit | Save photo | Names the outcome |
| OK | Got it | "OK" is forms-speak |
| Yes / No | Delete project / Cancel | Repeats the consequence |
| Continue | Add to cart, £24.99 | Says where it leads (in commerce) |
| Learn more | See how sharing works | "More" is empty; several "Learn more" links are indistinguishable |
| Sign up | Create account | Specific outcome |
| Loading… | Saving… | The verb in progress |
| Error | Try again | Recoverable framing |
| Get started | Take your first photo | Says what starting is |
| Buy | Buy for £9.99 | Always show the price |

| Bad error | Good error |
|---|---|
| Oops! Something went wrong. | Unable to save. Check your connection and try again. |
| Invalid email | Enter an email address like name@example.com |
| That password is too short | Choose a password with at least 8 characters |
| Error 401 | Your session expired. Sign in again to continue. |
| We're having trouble loading your data | Couldn't load your notes. Pull to retry. |
| Upload failed | Photo didn't upload. It's still on your device; tap to retry. |
| Payment error | Card declined. Try another card or check with your bank. |
| Network error | You're offline. Showing saved data. |
| Something's not right | Couldn't sync 3 items. Tap to see which. |

| Stakes | Tone |
|---|---|
| Success, onboarding, empty state | Warm; light is fine |
| Routine actions, settings | Neutral, minimal |
| Errors, destructive confirmations | Calm, plain, no playfulness |
| Data loss, security, money | Serious, explicit, every consequence stated |

| Surface | Rule |
|---|---|
| Nav title | Noun, names the contents |
| Tab label | One word, the contents |
| Button | Verb + noun |
| Section header | Noun; sentence case unless the contract says caps |
| Toast | Past tense, ≤ 44 characters |
| Empty state | One line of why, one action |
| Permission primer | Why + what happens, "Continue" |
| Notification | Headline + one line; relative time |
| Settings row | Noun phrase; toggles name the ON state |
| Paywall CTA | "Start free trial" or "Subscribe for £X/year"; the price is on screen |

### Code

Pluralisation without concatenation.

```swift
// Localizable.xcstrings holds the plural variants; the call site stays a full sentence.
Text(String(localized: "\(count) new messages", comment: "Inbox badge; count is an integer"))

// Or with markdown emphasis kept inside the localised string:
Text(String(localized: "You saved **\(count)** photos this week"))
```

Destructive confirmation that names the noun.

```swift
.confirmationDialog("Delete this project?", isPresented: $confirmDelete, titleVisibility: .visible) {
    Button("Delete project", role: .destructive) { delete() }
    Button("Cancel", role: .cancel) {}
} message: {
    Text("This removes the project and its 12 files. You can't undo this.")
}
.sensoryFeedback(.warning, trigger: confirmDelete) { _, new in new }
```

A verb that keeps its name through the flow.

```swift
enum PublishPhase { case idle, working, done }

var label: String {
    switch phase {
    case .idle: "Publish"
    case .working: "Publishing…"
    case .done: "Published"
    }
}
```

Permission primer copy shape.

```swift
VStack(spacing: 12) {
    Text("Scan receipts with the camera")
        .font(.title2.weight(.semibold))
    Text("Next, iOS will ask for camera access. The app only uses it while you're scanning, and never uploads images.")
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.leading)
    Button("Continue") { requestCamera() }   // exactly one button; no Cancel
        .buttonStyle(.pressable)
}
```

### Checks

- Read every button label out of context; each says what happens.
- Grep for "Oops", "Sorry", "Something went wrong", "trouble", "Are you sure", "OK", "Submit", "Click here".
- Grep for `" + ` near string literals; none build sentences.
- Follow one verb from button to completion; the name never changes.
- Every toggle reads correctly when ON.
- Run in German: nothing truncates, nothing wraps badly.
- Grep for the em-dash character and for emoji; matches are allowed only where the design contract says so.
- Count uses of the user's name per session: one.

### Do not

- Apologise in an error. State the fact and the fix.
- Use exclamation marks in errors or destructive flows.
- Write "Allow" on a permission primer.
- Put the app name in a notification title.
- Write "No items", "Nothing here", "No data".
- Use three different words for the same action across screens.
- Manufacture warmth from randomness. The words stay steady; the data varies.
- Truncate a label with an ellipsis when `ViewThatFits` and a shorter variant would do.

<!-- references/gestures-and-physics.md -->

## Gestures and physics

Use this when a view follows a finger: drag to dismiss, swipe to reply, reorder, scrub, pull, pan, or any custom gesture that hands off into an animation.
The difference between "app-like" and "web-like" on iOS is almost entirely whether motion inherits the gesture's velocity and can be interrupted mid-flight.

### Rules

1. **Interruptibility is the single most important principle.** Always animate from the current on-screen value, never from the target you were heading to. If a sheet is halfway closed and the user grabs it, it must be exactly where they see it. In SwiftUI this means state holds the presentation value and gestures write to it directly. Check: grab any animating surface mid-flight; it stops under the finger, not at the destination.
2. **Follow the finger 1:1.** During `.onChanged`, set the offset with no animation. A spring during a drag lags the finger and feels like dragging through syrup. Check: no `withAnimation` and no `.spring` inside any `.onChanged`.
3. **Velocity decides commit, not position.** Read `value.predictedEndTranslation` or `value.velocity` on release. A fast flick past 600pt/s commits regardless of distance; an upward flick always cancels a downward dismiss. Distance threshold is the fallback at 120pt. Check: flick a sheet 30pt fast and it dismisses; drag it 200pt then reverse slowly and it stays.
4. **Hand the velocity into the spring.** On release, start the settle animation with `.interpolatingSpring(..., initialVelocity:)` or `.spring` seeded from the gesture so the object continues on its trajectory. A spring that starts from rest after a flick reads as a brick wall. Check: a flicked card keeps moving in the flick direction before settling.
5. **Rubber-band past the edge with Apple's constant.** `(1 - 1 / (offset / dimension × 0.55 + 1)) × dimension`. It is asymptotic, which is why iOS overscroll feels like elastic and not a wall. Check: dragging past the limit slows smoothly and never stops dead.
6. **Project momentum the way the platform does.** Apple's deceleration is `distance = (v / 1000) × d / (1 − d)` with `d ≈ 0.998` (0.99 for a snappier feel). The textbook `v² / 2a` is not what the OS ships and will feel foreign next to system scroll views. Check: a paged or snapping surface lands where a native scroll view would.
7. **Decompose 2D motion into independent X and Y springs.** One spring on a 2D distance desynchronises the axes and curves the path. Check: a freely dragged object released diagonally travels straight.
8. **Detect every plausible gesture in parallel, then cancel the losers.** A recogniser that waits for a final state feels laggy. Decide direction after ~10pt of travel; a tap survives ~10pt of hysteresis. Check: a slight wobble during a tap still taps; a slow diagonal drag picks one axis and sticks to it.
9. **Commit a press only after it has held ~70ms.** A swipe has moved by then. Without the delay, every scroll across a grid of buttons lights them up. Check: swipe across a button grid; nothing highlights.
10. **Give threshold feedback once.** When a drag crosses the commit threshold, fire one `.soft` impact and change the visual (the reply glyph fills, the backdrop reaches its darkest). Fire it again only if the user crosses back and re-enters. Check: hold the finger at the threshold; the haptic does not repeat.
11. **Progress the backdrop with the drag.** A dismissing surface darkens or scales its backdrop linearly with offset over the first ~200pt so the user sees the consequence of letting go. Check: at half a dismiss, the backdrop is at half opacity.

### Cheat sheet

| Value | Default |
|---|---|
| Drag-dismiss commit | 120pt travel or 600pt/s velocity, whichever first |
| Upward flick during downward dismiss | always cancels |
| Tap hysteresis | ~10pt |
| Direction lock | after ~10pt of travel |
| Press commit delay | ~70ms |
| Rubber-band constant | 0.55 |
| Deceleration rate | 0.998 per ms (0.99 snappier) |
| Backdrop progression | linear over 0–200pt |
| Threshold haptic | `.impact(flexibility: .soft)` once per crossing |
| Settle after release | `.spring(duration: 0.45, bounce: 0.12)` seeded with velocity |
| Swipe-to-reply cap | 80pt offset, threshold 60pt, `minimumDistance: 16` |

### Code

#### Rubber-band and momentum projection

```swift
import SwiftUI

enum Physics {
    /// Apple-style elastic resistance past an edge.
    static func rubberBand(_ offset: CGFloat, dimension: CGFloat, c: CGFloat = 0.55) -> CGFloat {
        let sign: CGFloat = offset < 0 ? -1 : 1
        let x = abs(offset)
        return sign * (1 - 1 / (x / dimension * c + 1)) * dimension
    }

    /// Where a flick will come to rest. `velocity` in pt/s, matching DragGesture.Value.velocity.
    static func project(velocity: CGFloat, decelerationRate d: CGFloat = 0.998) -> CGFloat {
        (velocity / 1000) * d / (1 - d)
    }
}
```

#### Swipe to dismiss with progressive backdrop, threshold haptic, and velocity handoff

```swift
struct DismissibleCard<Content: View>: View {
    let onDismiss: () -> Void
    @ViewBuilder let content: Content

    @State private var offset: CGFloat = 0
    @State private var crossed = false
    @State private var thresholdTick = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let commitDistance: CGFloat = 120
    private let commitVelocity: CGFloat = 600

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5 * (1 - min(max(offset, 0) / 200, 1)))   // linear over 0–200pt
                .ignoresSafeArea()
            content
                .offset(y: offset)
                .gesture(drag)
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: thresholdTick)
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                let y = value.translation.height
                // Follow the finger 1:1 downward; rubber-band upward.
                offset = y >= 0 ? y : Physics.rubberBand(y, dimension: 300)
                let nowCrossed = y > commitDistance
                if nowCrossed != crossed {
                    crossed = nowCrossed
                    if nowCrossed { thresholdTick += 1 }   // once per crossing
                }
            }
            .onEnded { value in
                let v = value.velocity.height          // pt/s
                let upwardFlick = v < -commitVelocity
                let commit = !upwardFlick && (v > commitVelocity || offset > commitDistance)
                if commit {
                    withAnimation(reduceMotion ? .easeInOut(duration: 0.18) : .spring(duration: 0.32, bounce: 0)) {
                        offset = 900
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: onDismiss)
                } else {
                    // Seed the settle with the release velocity so it continues its trajectory.
                    withAnimation(reduceMotion
                                  ? .easeInOut(duration: 0.18)
                                  : .interpolatingSpring(duration: 0.45, bounce: 0.12, initialVelocity: v / 300)) {
                        offset = 0
                    }
                    crossed = false
                }
            }
    }
}
```

`initialVelocity` is expressed relative to the distance travelled, so divide the pt/s velocity by the remaining distance in points. `v / 300` is a reasonable seed for a 300pt travel; tune by feel, not by formula.

#### Two independent axes

```swift
@State private var x: CGFloat = 0
@State private var y: CGFloat = 0

.onEnded { value in
    withAnimation(.interpolatingSpring(duration: 0.45, bounce: 0.12,
                                       initialVelocity: value.velocity.width / 200)) { x = 0 }
    withAnimation(.interpolatingSpring(duration: 0.45, bounce: 0.12,
                                       initialVelocity: value.velocity.height / 200)) { y = 0 }
}
```

#### Press that commits after 70ms (so swipes do not light buttons)

```swift
struct CommittedPress: ViewModifier {
    let onPress: () -> Void
    @State private var pending: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard pending == nil else { return }
                    pending = Task {
                        try? await Task.sleep(for: .milliseconds(70))
                        if !Task.isCancelled { onPress() }
                    }
                }
                .onEnded { _ in pending?.cancel(); pending = nil }
        )
    }
}
```

Pair with a scroll view's own gesture; the scroll wins after 10pt of travel and cancels the pending press.

#### Swipe to reply (bounded, with a single threshold haptic)

```swift
DragGesture(minimumDistance: 16)
    .onChanged { value in
        let raw = max(0, value.translation.width)
        replyOffset = min(raw, 80)                       // cap at 80pt
        let crossedNow = raw > 60
        if crossedNow != crossed { crossed = crossedNow; if crossedNow { tick += 1 } }
    }
    .onEnded { _ in
        if crossed { onReply() }
        withAnimation(.spring(duration: 0.32, bounce: 0.12)) { replyOffset = 0 }
        crossed = false
    }
```

### Checks

- Drag any dismissible surface halfway, grab it again before it settles. It stops under the finger.
- Flick a sheet 30pt fast: dismisses. Drag 200pt and slowly reverse: stays.
- Flick upward while dismissing downward: cancels every time.
- Drag past a limit: slows smoothly, never stops dead.
- Release diagonally: object travels straight, not in an arc.
- Swipe across a grid of buttons: nothing highlights.
- Hold the finger at a threshold: the haptic fires once.
- With Reduce Motion on: everything still commits and cancels; nothing travels on release.

### Do not

- Animate inside `.onChanged`.
- Decide commit by distance alone.
- Start a settle spring from rest after a flick.
- Use a single spring for a 2D offset.
- Fire the threshold haptic on every frame past the threshold.
- Compute deceleration with `v² / 2a`.
- Use `predictedEndTranslation` as the destination; use it as a signal.

<!-- references/haptics.md -->

## Haptics

Use this when adding, auditing, or budgeting haptic feedback: which style, on which event, at what frequency, and when to say nothing.
Haptics are punctuation. A full stop, not an exclamation mark. The apps that feel best fire fewer haptics than you expect, and fire them at the exact moment of contact.

### Rules

1. **Press fires on touch-down, never on release.** The user reads a touch-down haptic subconsciously as "the button heard me". On release it arrives after the decision and feels like a delay. Check: press and hold any button; the tick happens immediately.
2. **One `.success` per commit.** Sending, saving, completing: one haptic for the whole batch, never one per item. Check: complete a batch of ten; count the ticks (expect one).
3. **`.selection` on the crossing, not per pixel.** Pickers, segmented controls, detents, week boundaries: fire when the value changes, not while the finger moves. Check: drag slowly across a picker; each tick lines up with a value change.
4. **Prepare before predictable moments.** `prepare()` on a `UIFeedbackGenerator` cuts latency from ~50ms to under 5ms and stays warm for ~2 seconds. Call it on touch-down for the release haptic, or when a countdown enters its last second. With `.sensoryFeedback` the system prepares for you; use the UIKit generator only when you need the timing control. Check: a haptic tied to a visual lands within the same frame.
5. **Throttle continuous haptics and scale them with density.** Scrubbing, flipping, ticking: at most one transient per 30ms (45ms when many things move), intensity `0.35 + 0.35 × density`, sharpness `0.5 + 0.4 × density`. The landing is heavier and duller (intensity 0.9, sharpness 0.25). Check: a full-board cascade reads as a flutter, not machine-gun fire.
6. **Never double-fire what the system already fires.** Context-menu open (`.medium`), context-menu select (`.medium`), dismiss-outside (`.soft`), widget button taps, Camera Control half-press, `Toggle`, `Picker`, pull-to-refresh, and `.sensoryFeedback`-backed system controls all fire on their own. Check: strip your haptics from these and compare.
7. **Fire yourself where the system is silent.** Action Button intents, custom buttons, custom sliders, drag thresholds, and completions get nothing from the system. Check: every custom control has a press-down haptic.
8. **Haptic and sound land within 10ms.** Latency between them destroys the illusion of one event. Trigger both from the same line, sound already prepared. Check: record with a high-speed camera or trust the ear; any gap reads as two events.
9. **Guard iPad and Mac.** iPads have no haptic engine; `.sensoryFeedback` is a no-op there, but `CHHapticEngine()` throws. Check `CHHapticEngine.capabilitiesForHardware().supportsHaptics` before building an engine. Check: run on an iPad simulator; nothing crashes, nothing logs.
10. **Budget per session.** A screen that ticks on every state change is noise; the user stops feeling any of them. Decide which three to five moments per app deserve a signature, and give everything else the standard vocabulary or nothing. Check: list every haptic the app fires on the primary path; if it exceeds ~8 distinct moments, cut.
11. **Never haptic** cold launch, list scrolling, foreground notifications, saved settings, read receipts (once per conversation per session at most), loading completions the user did not wait for, or anything on a timer. Check: grep `sensoryFeedback` and `impactOccurred`; each site maps to a user action.

### Cheat sheet

| Moment | `.sensoryFeedback` | Rule |
|---|---|---|
| Button press | `.impact(weight: .light)` | Touch-DOWN, never release |
| Selection change | `.selection` | On the crossing only |
| Commit (send, save, complete) | `.success` | Once per commit |
| Warning state entered | `.warning` | Once on entering |
| Error | `.error` | Paired with inline copy |
| Pick up / drag start | `.impact(flexibility: .soft, intensity: 0.7)` | |
| Land / drop | `.impact(weight: .medium)` | Heavier and duller than pick-up |
| Snap to detent | `.impact(flexibility: .rigid)` | At the detent, not near it |
| Alignment (crop, guides) | `.alignment` | Once per alignment |
| Level change (slider quarter marks) | `.levelChange` | Throttle ≥ 80ms |
| Start / stop (record, timer) | `.start` / `.stop` | |
| Continuous (scrub, flip) | CoreHaptics transient | ≥ 30ms apart, density-scaled |

| CoreHaptics parameter | Tap / click | Soft press | Rumble |
|---|---|---|---|
| Intensity | 0.8–1.0 | 0.4–0.6 | 0.3–0.6 |
| Sharpness | 0.6–1.0 | 0.2–0.4 | 0.0–0.2 |

A transient is ~80ms. Continuous events run up to 30s. A generator stays warm ~2s after `prepare()`.

### Code

#### Everyday haptics with `.sensoryFeedback`

```swift
struct SendButton: View {
    @State private var pressTick = 0
    @State private var sentCount = 0
    let send: () async -> Bool

    var body: some View {
        Button("Send") { Task { if await send() { sentCount += 1 } } }
            .buttonStyle(.pressable)   // fires pressTick on touch-down; see assets/PressableButtonStyle.swift
            .sensoryFeedback(.impact(weight: .light), trigger: pressTick)
            .sensoryFeedback(.success, trigger: sentCount)          // once per commit
    }
}

// Selection on the crossing: trigger is the value, so the tick lines up with the change.
Picker("Sort", selection: $sort) { /* ... */ }
    .sensoryFeedback(.selection, trigger: sort)

// Conditional: only when entering the warning state.
.sensoryFeedback(.warning, trigger: isOverLimit) { old, new in !old && new }
```

#### Prepared UIKit generator for tight timing

```swift
final class PressHaptics {
    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)

    func touchDown() {
        light.impactOccurred()
        medium.prepare()            // the release haptic is now < 5ms away
    }
    func release(velocity: CGFloat) {
        medium.impactOccurred(intensity: 0.3 + min(velocity / 2000, 1) * 0.7)   // velocity-mapped
    }
}
```

#### Density-scaled continuous haptics (CoreHaptics with a fallback)

```swift
import CoreHaptics
import UIKit

final class ContinuousHaptics {
    private var engine: CHHapticEngine?
    private let fallback = UIImpactFeedbackGenerator(style: .rigid)
    private var last: TimeInterval = 0

    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }   // iPad guard
        engine = try? CHHapticEngine()
        engine?.playsHapticsOnly = true
        engine?.isAutoShutdownEnabled = true
        engine?.resetHandler = { [weak self] in try? self?.engine?.start() }
    }

    /// One tick per burst of moving things. Sharpness rises with how much is moving.
    func tick(moving: Int, now: TimeInterval = ProcessInfo.processInfo.systemUptime) {
        let gap: TimeInterval = moving > 30 ? 0.045 : 0.03
        guard now - last >= gap else { return }
        last = now
        let density = min(1, Float(moving) / 50)
        transient(intensity: 0.35 + 0.35 * density, sharpness: 0.5 + 0.4 * density)
    }

    /// The landing: heavier, duller.
    func settle() { transient(intensity: 0.9, sharpness: 0.25) }

    private func transient(intensity: Float, sharpness: Float) {
        guard let engine else { fallback.impactOccurred(intensity: CGFloat(intensity)); return }
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [
            .init(parameterID: .hapticIntensity, value: intensity),
            .init(parameterID: .hapticSharpness, value: sharpness),
        ], relativeTime: 0)
        do {
            try engine.start()
            let player = try engine.makePlayer(with: try CHHapticPattern(events: [event], parameters: []))
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            fallback.impactOccurred(intensity: CGFloat(intensity))
        }
    }
}
```

#### A signature: two transients that read as one object materialising

```swift
func materialise(engine: CHHapticEngine) throws {
    let events = [
        CHHapticEvent(eventType: .hapticTransient, parameters: [
            .init(parameterID: .hapticIntensity, value: 0.55),
            .init(parameterID: .hapticSharpness, value: 0.30),
        ], relativeTime: 0),
        CHHapticEvent(eventType: .hapticTransient, parameters: [
            .init(parameterID: .hapticIntensity, value: 0.9),
            .init(parameterID: .hapticSharpness, value: 0.55),
        ], relativeTime: 0.085),
    ]
    try engine.makePlayer(with: try CHHapticPattern(events: events, parameters: [])).start(atTime: CHHapticTimeImmediate)
}
```

Reserve this kind of pattern for the three to five moments per app that deserve a signature. Everything else uses the standard vocabulary.

#### AHAP shape (for designers to hand over)

```json
{
  "Version": 1.0,
  "Pattern": [
    { "Event": { "Time": 0.0,   "EventType": "HapticTransient",
                 "EventParameters": [ { "ParameterID": "HapticIntensity", "ParameterValue": 0.55 },
                                      { "ParameterID": "HapticSharpness", "ParameterValue": 0.30 } ] } },
    { "Event": { "Time": 0.085, "EventType": "HapticTransient",
                 "EventParameters": [ { "ParameterID": "HapticIntensity", "ParameterValue": 0.90 },
                                      { "ParameterID": "HapticSharpness", "ParameterValue": 0.55 } ] } }
  ]
}
```

Load with `CHHapticPattern(contentsOf:)`.

### Checks

- Press and hold every button: the tick is on touch-down.
- Complete a batch: exactly one `.success`.
- Drag slowly across each picker and detent: one tick per value change, none between.
- Open a context menu with your own haptic disabled: the system already ticks.
- Run on iPad: no crash, no console noise.
- List every haptic on the primary path: ≤ ~8 distinct moments, none on scroll, launch, or timers.
- Trigger the paired sound and haptic together: they land as one event.

### Do not

- Fire on release.
- Fire once per item in a batch.
- Fire on every pixel of a drag.
- Duplicate system haptics on `Toggle`, `Picker`, context menus, or widget buttons.
- Build a `CHHapticEngine` without checking `supportsHaptics`.
- Tie a haptic to a timer, a fetch completion, or a notification arriving in the foreground.
- Give every state change a signature pattern.

<!-- references/icons-and-symbols.md -->

## Icons and SF Symbols

Use this when you are choosing, sizing, colouring, or animating icons, or when a screen has glyphs that do not sit right next to their text.
It does not pick an icon family. It makes whichever family the project uses read as one voice, and it keeps icon motion tied to events.

### Rules

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

### Cheat sheet

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

### Code

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

### Checks

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

### Do not

- Animate an icon to attract attention. An icon attracts attention by being the only thing that is not moving.
- Use `.multicolor` on a UI glyph to make it "pop".
- Change icon weight on selection; it shifts layout. Change fill.
- Import a custom icon as a single PNG and scale it.
- Put an SF Symbol in the app icon or a hero illustration.
- Use a 16pt glyph with a 16pt hit area. The target is 44.

See also: `references/motion.md` for the event-only motion rule, `references/haptics.md` for pairing, `references/layout-and-spacing.md` for optical alignment, `references/accessibility.md` for labels on icon-only buttons.

<!-- references/layout-and-spacing.md -->

## Layout, spacing and hierarchy

Use this when you are placing things on a screen: margins, gaps, radii, alignment, what goes first, what hides behind a menu, and what happens at the edges.
It does not pick a density. It makes the project's density consistent and its hierarchy legible in one glance.

### Rules

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

### Cheat sheet

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

### Code

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

### Checks

- Every spacing value is on the grid.
- Left edge of content aligns across every screen.
- The biggest number has 24pt above and below.
- Group gaps ≥ 2× inner gaps; each `Divider()` justified.
- ≤ 3 radii; nested corners computed.
- Zoom to 400%: icons and squares sit optically centred.
- SE-sized device, landscape, keyboard up: nothing hidden, nothing touching an edge.
- 1, 2, and 200 items all look designed.
- One primary per view; secondary actions ≤ 3 visible.

### Do not

- Add a fourth radius because one component "needs" it. Reuse the nearest.
- Use `Spacer()` where a named gap would do; spacers hide intent.
- Put a hairline and a 24pt gap between the same two groups.
- Use `.ignoresSafeArea()` on content; only on backgrounds.
- Fix a layout at one text size with `.frame(width:)`.
- Copy iPhone margins and 44pt targets into an iPad sidebar or a Mac inspector.

See also: `references/typography.md` for the type spine, `references/buttons-and-controls.md` for sizes and hit areas, `references/sheets-and-navigation.md` for sheet radii and detents.

<!-- references/liquid-glass.md -->

## Liquid Glass (iOS 26)

Use this when the project targets iOS 26 and you are adopting, auditing, or restraining Liquid Glass on toolbars, floating buttons, sheets, chips, or custom surfaces.
It does not make an app "glassy". It puts glass exactly where the system puts it and keeps content solid so it stays legible.

### Rules

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

### Cheat sheet

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

### Code

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

### Checks

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

### Do not

- Make a card, list row, or message bubble glass.
- Tint every glass control; tint one.
- Keep the old shadow under a bar that is now glass.
- Wrap glass in a second blur to "soften" it.
- Put glass over glass to build depth; use spacing and a single hairline.
- Treat glass as a brand feature. It is the system's material; your brand is in the content it floats over.

See also: `references/color.md` for the flat translucent content surface, `references/buttons-and-controls.md` for press styles on non-glass buttons, `references/sheets-and-navigation.md` for what sheets do automatically, `references/accessibility.md` for Reduce Transparency.

<!-- references/motion.md -->

## Motion

Use this when you are adding, reviewing, or consolidating any animation in a SwiftUI app: springs, curves, staggers, content transitions, ambient loops, or the Reduce Motion fallback.
The goal is a small named vocabulary that every animation in the app comes from, so the whole app moves like one object.

### Rules

1. **Build a vocabulary, then forbid everything outside it.** An app with forty ad-hoc springs feels like forty apps. Name 5–8 curves, give each one job, and write the sentence "if a new animation does not fit one of these, the answer is usually don't" at the top of the file. Check: grep for `.spring(`, `.snappy(`, `.smooth(`, `.easeOut(`; every hit references a named constant.
2. **Scope every `.animation` with `value:`.** A bare `.animation(_)` animates every state change that passes through the view, including ones you never intended, which is the iOS equivalent of `transition: all`. Check: grep `\.animation\([^)]*\)$` for calls with no `value:`; each is a finding.
3. **One datum, one curve.** Everything driven by the same value uses the same `Animation` constant in the same `withAnimation` block. A number, its gauge, and its trend that arrive on three curves read as three objects. Check: for each `@State` that drives visuals, list the views it touches and confirm they share one constant.
4. **Out is faster than in.** Exit at ~0.65× the entrance duration with `bounce: 0`. People have already decided to leave. Sheet: in `0.42 / 0.18`, out `0.32 / 0`. Check: every presented surface has a distinct dismiss animation shorter than its present animation.
5. **The 100× rule.** If someone triggers it 100+ times a day, do not animate it. Tab switches, keyboard focus, arrow selection, list scrolling: instant, or a 0.14–0.16s press curve at most. Check: count how many times a day a heavy user hits each animated interaction.
6. **What follows a finger is linear.** During a drag, scrub, or dial, the view tracks the gesture 1:1 with no animation. A spring starts only on release, seeded with the release velocity. See `references/gestures-and-physics.md`. Check: no `.spring` inside an `.onChanged` handler.
7. **Entrances never `.easeIn`.** An element that starts slow looks reluctant to arrive. Entrances use a spring or `.timingCurve(0.16, 1, 0.3, 1, duration: 0.4)`. Exits may accelerate. Check: grep `.easeIn(` and confirm each is an exit.
8. **Stagger on first appearance only.** 30–80ms per element, at most ~8 items (240ms total). Beyond that the last item arrives after the user has already looked at it. Never re-stagger on scroll or on every data refresh. Check: staggered views carry a `hasAppeared` flag that is set once.
9. **Every changing number is monospaced and content-transitions.** `.monospacedDigit()` stops the layout shifting as 99 becomes 100; `.contentTransition(.numericText(value:))` rolls the digits. One without the other is half a fix. Check: every `Text` bound to a changing number has both modifiers.
10. **Icons morph, they do not breathe.** State changes on symbols use `.contentTransition(.symbolEffect(.replace))`. Idle animation on a symbol (`.breathe`, `.pulse`, `.bounce` on repeat) is the most recognisable template tell. Check: grep `symbolEffect` and confirm every use is a state change or a one-shot event.
11. **Ambient loops use `TimelineView`, never a `Timer`.** A `Timer` at 60fps re-renders the whole tree and drifts; `TimelineView(.animation)` is frame-synchronised and pauses off-screen. Period ≥ 1.2s. Check: grep `Timer.publish` and `repeatForever`; each is either an explicit ambient loop or a finding.
12. **Loops act, rest, then ease home.** A loop that snaps back to its start frame reads as a glitch. Do the thing, park the payoff so it dwells, then ease home. Check: watch any loop at 10% speed and find the snap.
13. **Write the storyboard as a comment above the constants.** Every state of the feature, top to bottom, with ms after trigger. It is the only document that survives refactors because it lives next to the numbers. Check: the motion file opens with the storyboard.
14. **Reduce Motion is a crossfade, not nothing.** Replace travel, scale, and 3D with `.easeInOut(duration: 0.18)` on opacity. Keep haptics. Stripping every animation makes the app feel broken. Check: toggle Reduce Motion in the simulator and walk the primary path.

### Cheat sheet

| Moment | Default | Note |
|---|---|---|
| Button press (touch-down) | `.spring(duration: 0.16, bounce: 0)` to scale 0.97 | Near-instant; fires hundreds of times a day |
| Button release | `.spring(duration: 0.30, bounce: 0.25)` | The one place a whisper of bounce belongs |
| State change (toggle, tab indicator, chip) | `.snappy(duration: 0.24 to 0.28, extraBounce: 0.08 to 0.12)` | Default for small UI |
| Crossfade (mode, colour, opacity) | `.smooth(duration: 0.22)` or `.easeOut(0.22)` | Opacity never springs |
| Sheet present | `.spring(duration: 0.42, bounce: 0.18)` | Contents +60–80ms |
| Sheet dismiss | `.spring(duration: 0.32, bounce: 0)` | Out faster than in |
| Hero / matched geometry | `.spring(duration: 0.42, bounce: 0.16)` | Radius animates with size |
| Navigation push | `.spring(duration: 0.38, bounce: 0.05)` | Deeper grows in from 0.94; shallower shrinks in from 1.04 |
| Weighted object settling | `.spring(duration: 0.45, bounce: 0.12)` | Cards after a drag |
| Celebration (rare) | `.bouncy(duration: 0.6, extraBounce: 0.3)` | Once per milestone |
| Progress tracking a real value | `.linear(duration: 0.18)` | It is a number |
| Ambient loop | ≥ 1.2s, `TimelineView` | Never on a symbol |
| Reduce Motion fallback | `.easeInOut(duration: 0.18)` | Opacity only |

#### Spring notation conversion

| You have | Use | Note |
|---|---|---|
| `response: r, dampingFraction: d` | `.spring(duration: r, bounce: 1 - d)` | Approximate; 0.42/0.82 ≈ duration 0.42, bounce 0.18 |
| `.smooth` | `duration 0.5, bounce 0` | System preset |
| `.snappy` | `duration 0.5, bounce 0.15` | System preset |
| `.bouncy` | `duration 0.5, bounce 0.3` | System preset |
| `stiffness / damping` | Do not translate; re-tune by feel | Different model |

### Code

#### A vocabulary file (worked example, shipped in a RAW-extraction utility)

```swift
import SwiftUI

/// The whole motion vocabulary. Seven curves, each with one job. If a new
/// animation does not fit one of these, the answer is usually "don't".
enum Motion {
    /// Weighted objects arriving or returning: a bar, a viewer, a card snapping back.
    static let settle = Animation.spring(duration: 0.42, bounce: 0.16)
    /// Something carrying an image between two places. Better damped: it must not wobble.
    static let fly = Animation.spring(duration: 0.34, bounce: 0.10)
    /// The one deliberate overshoot in the app.
    static let reveal = Animation.spring(duration: 0.55, bounce: 0.32)
    /// Yes/no state: rings, ticks, a tile lifting when selected.
    static let state = Animation.snappy(duration: 0.22)
    /// Mode changes and label crossfades. Nothing travels.
    static let mode = Animation.smooth(duration: 0.22)
    /// Pure opacity: thumbnails arriving, captions, the landing stagger.
    static let fade = Animation.easeOut(duration: 0.3)
    /// A fill that tracks a real number, so it moves linearly.
    static let progress = Animation.linear(duration: 0.18)
    /// Reduce Motion stand-in for anything that would otherwise travel.
    static let reduced = Animation.easeOut(duration: 0.2)
}
```

#### The storyboard-as-comment shape (from a control-surface app; values are its own)

```swift
/* MOTION STORYBOARD
 * Read top-to-bottom. Each value is ms after trigger.
 * Motion is earned: the frequent moments are near-instant, the rare ones get the theatre.
 *
 * POWER ON (once per connection; rare)
 *     0ms   surface already there, pads at scale 0.92, opacity 0
 *    60ms   rail pills fade in
 *   120ms   pads appear in a diagonal wave (staggered 24ms by row+col)
 *
 * PRESS (hundreds of times a day; near-instant)
 *    70ms   touch confirmed (a swipe would have moved by now)
 *           scale 1.0 -> 0.96, haptic                     (140ms, no bounce)
 *   release scale 0.96 -> 1.0                             (320ms, bounce 0.18)
 *
 * FOLDER OPEN (deeper = grow in from 0.94)   BACK (shallower = shrink in from 1.04)
 *
 * REDUCED MOTION: no scale, no travel, no sweep. Opacity and colour only.
 */
enum Timing {
    static let padStagger   = 24   // ms between diagonal groups
    static let pressCommit  = 70   // touch must hold this long before it counts
}
```

Keep the constants directly under the storyboard. A reader should never have to hunt for the number the comment describes.

#### Scoped animation and unified interpolation

```swift
struct Meter: View {
    let value: Double            // one datum
    private let curve = Motion.settle

    var body: some View {
        VStack(spacing: 8) {
            Text(value, format: .number.precision(.fractionLength(0)))
                .monospacedDigit()
                .contentTransition(.numericText(value: value))
            Gauge(value: value, in: 0...100) { EmptyView() }
            Image(systemName: value > 50 ? "arrow.up" : "arrow.down")
                .contentTransition(.symbolEffect(.replace))
        }
        .animation(curve, value: value)   // one curve, three siblings, scoped
    }
}
```

#### First-appearance stagger

```swift
struct StaggeredList<Item: Identifiable, Row: View>: View {
    let items: [Item]
    @ViewBuilder let row: (Item) -> Row
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ForEach(Array(items.prefix(8).enumerated()), id: \.element.id) { index, item in
            row(item)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared || reduceMotion ? 0 : 8)
                .animation(
                    (reduceMotion ? Motion.reduced : Motion.fade).delay(Double(index) * 0.04),
                    value: appeared
                )
        }
        ForEach(items.dropFirst(8)) { row($0) }   // no stagger past 8
        .onAppear { appeared = true }              // set once, never reset on refresh
    }
}
```

#### Ambient loop with `TimelineView`

```swift
struct Shimmer: ViewModifier {
    func body(content: Content) -> some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { context in
            let t = context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.4) / 1.4
            content.overlay(
                LinearGradient(colors: [.clear, .white.opacity(0.25), .clear], startPoint: .leading, endPoint: .trailing)
                    .offset(x: (t * 2 - 1) * 300)
                    .blendMode(.plusLighter)
            )
            .mask(content)
        }
    }
}
```

#### Reduce Motion fallback

```swift
extension Animation {
    /// Use the intended curve, or a short crossfade when Reduce Motion is on.
    static func polished(_ intended: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.18) : intended
    }
}
```

### Checks

- Open the motion file. It begins with a storyboard comment and holds every curve the app uses.
- Grep for spring literals outside the motion file. Expect zero.
- Grep for `.animation(` without `value:`. Expect zero.
- For each presented surface, the dismiss is shorter than the present and has no bounce.
- Record the primary path at 10% speed (Simulator: Debug > Slow Animations). Nothing snaps, nothing overshoots twice, siblings move together.
- Toggle Reduce Motion. Everything still changes state; nothing travels.
- Every `Text` bound to a changing number has `.monospacedDigit()` and `.numericText`.

### Do not

- Add a spring because the surface "feels flat". Ask what the frequency is first.
- Put `.animation` on a container to animate "everything inside". Scope it.
- Use `withAnimation` around state that also drives an unrelated view.
- Animate opacity with a bouncy spring.
- Let a `Timer` drive anything visual.
- Ship a loop that snaps to its first frame.
- Strip all animation under Reduce Motion.

<!-- references/onboarding.md -->

## Onboarding

Use this when designing or reviewing the first run: launch, the first screens, permissions, account, the first payoff.
The first thirty seconds decide whether someone stays. Every screen either builds toward a payoff or costs you the user.

### Rules

1. **Value in three seconds.** The first real screen shows what the app does with something the user can see, not a paragraph about it. Why: people decide before they read. Check: cover the text; the screen still communicates.
2. **Four or five rooms, one purpose each.** Value moment → the one input → the payoff → a permission primer only if the very next step needs it → handoff. Why: each extra screen loses a share of users. Check: name each screen's single job; if a screen has two, split it or cut it.
3. **Sign-in and the paywall are not rooms.** Guest-first; ask for an account when there is something to save, sync, or unlock. Show the paywall only after a value preview, and skippable. Why: forced sign-in is the top abandonment point. Check: the user reaches the payoff without an account.
4. **The launch screen is not a design canvas.** It matches the first real screen, contains no text (it cannot be localised), and no logo unless the logo is part of the first screen. Why: it is a placeholder for a fraction of a second; a splash reads as a delay. Check: the launch storyboard has no `UILabel`.
5. **Progress is dots, never a bar.** A bar reads as loading; dots read as position in a short journey. The active dot is a capsule 2.5–3× the inactive width, same height, and glides to the new index. Inactive dots at about 0.25 opacity of the ink. Check: the dots never teleport.
6. **Do not count the primer or the celebration as steps.** Five dots that only reach three is a broken promise. Check: dot count equals the number of screens the user actually pages through.
7. **The CTA is pinned.** A fixed distance from the bottom safe area, same on every screen; body copy grows upward. Why: a button that moves between screens reads as "made by nobody in particular". Check: page through; the button's Y never changes.
8. **Forward enters from the trailing edge; back returns to it.** `.spring(duration: 0.45, bounce: 0.15)`. Background art travels at 30–40% of the foreground. Why: direction encodes progress. Check: a cross-fade in place is a finding.
9. **The value preview is built from real components.** The one input produces an immediate reflection using the app's actual views, and the payoff is prefetched the moment the input exists. Why: a mock-up promises; the real thing proves. Check: the preview screen imports the same view as the main app.
10. **Permission primers have exactly one button titled "Continue" or "Next".** No Cancel, no "Allow", no incentives, no screenshot of the alert. Why: App Review 5.1.1(iv). Check: the primer view has one `Button`.
11. **Ask at the point of value, never at launch.** Camera when the user taps scan; notifications after the first thing worth being told about. Check: no permission alert fires before the user has done anything.
12. **Sign in with Apple, when offered, uses the system button and is no smaller than any other sign-in option.** Do not ask for a password afterwards, and do not ask for a real email when a private relay address arrives. Check: `ASAuthorizationAppleIDButton` or `SignInWithAppleButton`, full width if others are full width.
13. **Request a review only after a completed value sequence, weeks in.** Never at first-run completion, never as a direct result of a tap. The system allows three prompts per year. Check: `requestReview` is not called from onboarding.
14. **The celebration is a quiet landing beat.** The number lands, the symbol morphs, one `.success` haptic. Save particles for milestones. Check: no confetti on "You're all set".
15. **Dots are hidden from VoiceOver; the flow announces "Step n of m".** Check: `.accessibilityHidden(true)` on the dots; `.accessibilityValue` on the container.

### Cheat sheet

| Room | Job | Contains | Does not contain |
|---|---|---|---|
| 1 Value moment | Show the thing | One sentence, real UI or media | Feature list, logo hero |
| 2 The one input | Get the seed | One field or picker, keyboard up | A form |
| 3 Payoff | Prove it | Real components rendering the user's input | Placeholder data |
| 4 Primer (optional) | Prepare one permission | Why + what happens, one "Continue" | Cancel, "Allow", incentives |
| 5 Handoff | Land in the app | Quiet beat, then the first real screen | Paywall, sign-in, review request |

| Element | Value |
|---|---|
| Page transition | `.spring(duration: 0.45, bounce: 0.15)`, forward from trailing |
| Background parallax | 30–40% of foreground travel |
| Dot size | 7pt inactive; active capsule ~2.75× wide |
| Dot glide | `.spring(duration: 0.4, bounce: 0.15)` (legacy `response: 0.4, dampingFraction: 0.85`); Reduce Motion `.easeInOut(0.2)` |
| Inactive dot opacity | ~0.25 of the ink |
| CTA position | Fixed inset from bottom safe area, identical on every room |
| Stagger within a room | 30–80ms, first appearance only |
| Reduce Motion | Crossfade 180ms, no travel, no parallax |

### Code

Paged flow with hidden system dots and a pinned CTA.

```swift
struct OnboardingFlow: View {
    @State private var index = 0
    private let rooms = 4

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $index) {
                ValueRoom().tag(0)
                InputRoom().tag(1)
                PayoffRoom().tag(2)
                HandoffRoom().tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(duration: 0.45, bounce: 0.15), value: index)

            OnboardingDots(count: rooms, index: index)
                .padding(.bottom, 16)
        }
        .safeAreaInset(edge: .bottom) {
            Button(index == rooms - 1 ? "Start" : "Continue") {
                index = min(index + 1, rooms - 1)
            }
            .buttonStyle(.pressable)
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)      // safe area is added by the inset, not replaced
        }
        .accessibilityElement(children: .contain)
        .accessibilityValue("Step \(index + 1) of \(rooms)")
    }
}
```

Dots that glide.

```swift
struct OnboardingDots: View {
    let count: Int
    let index: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let dot: CGFloat = 7
    private let gap: CGFloat = 7
    private var activeWidth: CGFloat { dot * 2.75 }

    var body: some View {
        HStack(spacing: gap) {
            ForEach(0..<count, id: \.self) { i in
                Capsule(style: .continuous)
                    .fill(i == index ? Color.primary.opacity(0.9) : Color.primary.opacity(0.25))
                    .frame(width: i == index ? activeWidth : dot, height: dot)
            }
        }
        .animation(reduceMotion ? .easeInOut(duration: 0.2) : .spring(duration: 0.4, bounce: 0.15),
                   value: index)
        .accessibilityHidden(true)
    }
}
```

Permission primer with one button.

```swift
struct PermissionPrimer: View {
    let title: String
    let explanation: String
    let symbol: String
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: symbol).font(.system(size: 40)).foregroundStyle(.secondary)
            Text(title).font(.title2.weight(.semibold))
            Text(explanation).font(.body).foregroundStyle(.secondary)
            Spacer()
            Button("Continue", action: onContinue)   // the only button
                .buttonStyle(.pressable)
                .frame(maxWidth: .infinity, minHeight: 52)
        }
        .padding(20)
    }
}
```

Parallax background at 35% of page travel.

```swift
GeometryReader { geo in
    heroArt
        .offset(x: -CGFloat(index) * geo.size.width * 0.35)
        .animation(.spring(duration: 0.45, bounce: 0.15), value: index)
}
.ignoresSafeArea()
```

Review request, weeks later, after a completed sequence.

```swift
@Environment(\.requestReview) private var requestReview

func didCompleteThirdExport() {
    Task { try? await Task.sleep(for: .seconds(2)); await requestReview() }
}
```

### Checks

- Time from launch to the first screen that shows the product: under three seconds on a cold start.
- Name each room's single job aloud.
- Page through with the CTA visible: its Y position never changes.
- Turn on Reduce Motion: pages crossfade, dots still update.
- Deny every permission: the flow completes and the app is usable.
- Skip the account: the payoff still appears.
- VoiceOver: dots are silent; "Step 2 of 4" is announced.
- Launch storyboard contains no text.

### Do not

- Put a feature carousel before the product.
- Ask for notifications, location, or tracking on launch.
- Title a primer button "Allow".
- Show a progress bar or a percentage.
- Show dots on a single-screen onboarding.
- Cross-fade pages in place.
- Put the paywall or sign-in inside the rooms.
- Fire confetti at "You're all set".
- Call `requestReview` from the flow.
- Let the CTA move, resize, or change style between rooms.

<!-- references/paywalls.md -->

## Paywalls and pricing

Use this when building or reviewing a paywall, a pricing screen, a trial flow, or any StoreKit code.
A calm, honest paywall converts better and keeps subscribers longer than a pressured one. The engineering underneath it is where trust is silently lost.

### Rules

1. **Value before wall.** The user has done something real before they see a price. Why: a cold wall is the worst-performing placement and the most-resented. Check: trace the first path to the paywall; there is a completed value moment before it.
2. **The real, localised price is always on screen.** `Product.displayPrice` plus the period. Never a hard-coded string. Why: currency, storefront, and offers vary; a typed price drifts and lies. Check: grep for a currency symbol in string literals; none near the paywall.
3. **One clear yes, one easy no.** A full-size, working Close from frame one. A neutral secondary ("Maybe later"), never confirmshaming. Check: Close is tappable in the first frame with a 44pt target.
4. **No manufactured urgency.** No countdown unless the expiry is real and set in App Store Connect. No phantom "was £99". No pulsing badge. Why: pressure reads as cheap and triggers refunds. Check: nothing on the paywall moves on its own after it settles.
5. **The verified entitlement is the source of truth.** Derive access from `Transaction.currentEntitlements`, keep it live with `Transaction.updates`, deny `.unverified`. Never a local bool. Check: refund in sandbox; access is gone on next launch.
6. **Finish every transaction.** Verify → deliver → `finish()`. Why: unfinished transactions re-deliver at every launch. Check: the handler calls `finish()` on every verified path.
7. **Every state gets the hero's care.** Loading, purchasing, pending (Ask to Buy), cancelled, failed, restored, already subscribed. Check: force each one in the StoreKit configuration; each has a designed view.
8. **Test the money before shipping.** StoreKit configuration → sandbox → TestFlight. Check: a purchase, a cancel, a restore, and a refund have each been run.
9. **Show the total and the per-month equivalent.** "£29.99/year, about £2.50/month". Never only the flattering number. Check: both appear for every annual option.
10. **One paid tier.** Free plus one paid, offered monthly and annual. Why: three tiers exist to make one look right; they add doubt, not revenue. Check: the option list has at most two rows.
11. **Annual may be the default; monthly is never hidden or greyed.** Check: both options are equally legible.
12. **Trial copy is gated on eligibility.** Show "7 days free" only when `isEligibleForIntroOffer` is true; state duration, amount, and date in words. Check: an ineligible sandbox account sees no trial promise.
13. **The CTA locks its height while purchasing.** Label swaps for `ProgressView` in the same frame. `.userCancelled` re-enables silently. Failure shows inline under the CTA with a retry, never an alert. Check: tap Subscribe and cancel; nothing moved, nothing appeared.
14. **Never prompt an existing subscriber to subscribe.** Show manage or upgrade instead. Check: entitlement is read before the paywall is presented.
15. **Re-prompt at the next genuine value moment, not on a timer.** Not every launch, not every session. Check: paywall presentation is triggered by an event, not a counter.
16. **Restore is a button and an automatic read.** `currentEntitlements` on launch plus a "Restore purchases" button; `AppStore.sync()` only on that tap. Check: reinstall; access returns without tapping anything.
17. **The honesty test.** Would this still work if the person understood it completely? If it only works while they are confused or rushed, it is a dark pattern. Check: read the paywall to someone who knows how subscriptions work.

### Cheat sheet

Anatomy, top to bottom.

| Position | Element | Rule |
|---|---|---|
| 1 | Close | Visible from frame one, full 44pt target, top corner |
| 2 | Headline | One line, in the project's title style; the eye lands here first |
| 3 | Hero (optional) | One calm image or the user's own data; not a five-screenshot carousel |
| 4 | Value lines | 3–4 concrete outcomes with small symbols, staggered in 40ms on first appearance |
| 5 | Options | 1–2 rows, `displayPrice` + period, total and per-month, annual may be preselected |
| 6 | Trial signal | Only when eligible; duration, amount, and charge date in words |
| 7 | CTA | Exactly one, full width, in the project's primary style, height locked while working |
| 8 | Quiet row | Restore purchases · Terms · Privacy |
| 9 | Fine print | Plain-language auto-renew and cancel sentence |

| Placement | Rank |
|---|---|
| Right after a value moment (contextual) | Best |
| At a natural metered limit ("3 of 3 free exports used") | Good |
| Behind a curiosity satisfier ("See what Pro does with this") | Good |
| In onboarding, after the value preview, skippable | Acceptable |
| On cold launch | Worst |

| State | Treatment |
|---|---|
| Products loading | Skeleton for the price rows; CTA disabled as transparency |
| Purchasing | CTA label → `ProgressView`, same frame; options disabled |
| `.pending` | "Waiting for approval" line; no unlock |
| `.userCancelled` | Re-enable; no message |
| Failed | Inline line under the CTA with the reason and "Try again" |
| Restored | Brief inline confirmation, then dismiss |
| Already subscribed | Never show subscribe; show manage |
| `canMakePayments == false` | Hide the store or explain in one line |

| Dishonest pattern | Fix |
|---|---|
| Invisible or delayed Close | Full-size Close from frame one |
| Fake countdown | No timer unless the expiry is real in App Store Connect |
| Phantom strike-through anchor | Only if it was genuinely the price |
| Hidden or greyed monthly | Both options equally legible |
| Trial trap | Duration, amount, and date in words |
| Confirmshaming | Neutral secondary |
| Pre-checked upsell | Nothing selected or charged by default |
| Cancellation maze | `showManageSubscriptions(in:)`, surfaced plainly |
| Cold wall | Value before wall |
| Re-selling the subscribed | Check entitlement first |
| Ineligible trial promise | Gate on `isEligibleForIntroOffer` |

| Broken pattern | Fix |
|---|---|
| Local-bool entitlement | Re-derive from `currentEntitlements` every launch |
| No `updates` listener | `Task` on `Transaction.updates` from launch, for the app's life |
| Unfinished transaction | Verify → deliver → `finish()` |
| Granting `.unverified` | Default deny |
| Hard-coded price | `Product.displayPrice` |
| Auto `AppStore.sync()` on launch | Only on an explicit Restore tap |
| CTA layout shift | Reserve the frame; swap the label in place |
| Unlocking on `.pending` | Wait state; grant only when `updates` confirms |
| No restore path | Automatic read plus a Restore button |
| Dead-end failure | Inline error with retry |
| Store shown to a no-payment device | Check `AppStore.canMakePayments` |
| Paywall first run in production | StoreKit config → sandbox → TestFlight |

### Code

Entitlements and the always-on listener, one handler.

```swift
@Observable final class Store {
    private(set) var isPro = false
    private var updates: Task<Void, Never>?

    init() {
        updates = Task { for await result in Transaction.updates { await handle(result) } }
        Task { await refresh() }
    }

    func refresh() async {
        var pro = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let t) = result, t.revocationDate == nil { pro = true }
        }
        isPro = pro
    }

    func purchase(_ product: Product) async -> PurchaseOutcome {
        do {
            switch try await product.purchase() {
            case .success(let result): await handle(result); return .success
            case .userCancelled: return .cancelled
            case .pending: return .pending
            @unknown default: return .failed("Something went wrong. Try again.")
            }
        } catch {
            return .failed("Purchase didn't complete. Try again.")
        }
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else { return }   // deny unverified
        await refresh()
        await transaction.finish()
    }
}

enum PurchaseOutcome { case success, cancelled, pending, failed(String) }
```

CTA that locks its frame and reports inline.

```swift
@State private var working = false
@State private var failure: String?

VStack(spacing: 8) {
    Button {
        Task {
            working = true; failure = nil
            switch await store.purchase(selected) {
            case .success: dismiss()
            case .cancelled: break
            case .pending: failure = "Waiting for approval. You'll get access once it's confirmed."
            case .failed(let reason): failure = reason
            }
            working = false
        }
    } label: {
        ZStack {
            Text(ctaTitle).opacity(working ? 0 : 1)
            if working { ProgressView().controlSize(.small) }
        }
        .frame(maxWidth: .infinity, minHeight: 56)
        .contentShape(Rectangle())
    }
    .buttonStyle(.pressable)
    .disabled(working)

    if let failure {
        HStack {
            Text(failure).font(.footnote).foregroundStyle(.secondary)
            Spacer()
            Button("Try again") { self.failure = nil }.font(.footnote.weight(.semibold))
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
.animation(.snappy(duration: 0.22), value: working)
.animation(.snappy(duration: 0.22), value: failure)
```

Price row with total and per-month, trial gated on eligibility.

```swift
struct PriceRow: View {
    let product: Product
    @State private var eligible = false

    var perMonth: String? {
        guard let sub = product.subscription, sub.subscriptionPeriod.unit == .year else { return nil }
        return (product.price / 12).formatted(product.priceFormatStyle)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(product.displayPrice) per year")
            if let perMonth { Text("about \(perMonth) a month").font(.footnote).foregroundStyle(.secondary) }
            if eligible, let intro = product.subscription?.introductoryOffer {
                Text("\(intro.period.value) days free, then \(product.displayPrice) a year. Cancel anytime before the trial ends.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .task { eligible = await product.subscription?.isEligibleForIntroOffer ?? false }
    }
}
```

System paywall (iOS 17+) when you do not need a custom layout.

```swift
SubscriptionStoreView(groupID: "your_group_id") {
    header   // the project's own hero; keep it calm
        .containerBackground(for: .subscriptionStoreFullHeight) { background }
}
.subscriptionStoreControlStyle(.prominentPicker)
.storeButton(.visible, for: .restorePurchases)
.storeButton(.visible, for: .redeemCode)
```

### Checks

- First frame of the paywall: Close is present and hits at 44pt.
- Every price on screen comes from `displayPrice`.
- Tap Subscribe, cancel the sheet: no layout change, no message.
- Sandbox refund: access revoked on next launch.
- Reinstall: access returns without tapping Restore.
- Sandbox account without trial eligibility: no trial copy.
- Nothing on the paywall animates after it settles.
- Read the fine print aloud; it states amount, period, renewal, and how to cancel.

### Do not

- Show the paywall on cold launch or to a current subscriber.
- Type a price into a `Text`.
- Grey or hide the monthly option.
- Pulse, glow, or throb any element to create pressure.
- Use an alert for a purchase failure.
- Unlock on `.pending` or on `.unverified`.
- Call `AppStore.sync()` anywhere except the Restore button.
- Stack a second CTA under the first.
- Fire confetti on subscribe; one `.success` haptic and a quiet confirmation is the beat.

<!-- references/sheets-and-navigation.md -->

## Sheets and navigation

Use this when presenting anything: sheets, detents, popovers, full-screen covers, hero transitions, navigation pushes, share sheets, and confirmation dialogs.
Presentation is where spatial continuity is won or lost. A sheet that arrives from nowhere and a title that leaves and comes back both break the sense of one place that changed.

### Rules

1. **Pick the detent by job, not by taste.** A quick confirm at `.height(220)`, a picker at `.medium`, a browse at `[.medium, .large]`, a form at `.large`. The user should be able to predict how tall the sheet will be from what they tapped. Check: every `.presentationDetents` in the app maps to one row of the cheat sheet.
2. **Name the corner radius once.** `.presentationCornerRadius` defaults to 10pt, which rarely matches a project's card radius. Set it to the project's large radius as a single constant and use it everywhere. Check: grep `presentationCornerRadius`; every call passes the same constant.
3. **Stacked sheets differ in height by at least 25%.** Two identical-height sheets read as one layer that swapped its contents; the user loses track of depth. Check: for any sheet presented from a sheet, compare detents.
4. **Trays adopt the environment.** A sheet presented from a themed surface inherits `.tint`, `.preferredColorScheme`, and `.presentationBackground`. A light sheet over a dark chat is disorienting. Check: present every sheet from a dark-mode and a tinted context.
5. **Contents arrive after the container.** The sheet springs in at t=0; its children fade and rise starting 60–80ms later, staggered 30ms. That offset is why system sheets feel like containers arriving with things inside. Check: watch at 10% speed; the first child appears after the sheet has mostly landed.
6. **Show the drag indicator unless there is a Close button.** Two dismissal affordances compete; zero leave the user stuck. Check: every sheet has exactly one obvious way out plus the swipe.
7. **Let the background stay interactive when the sheet is a companion.** Map with a results sheet, chart with an inspector, player with a queue: `.presentationBackgroundInteraction(.enabled(upThrough: .medium))`. Check: a medium sheet over a map still pans the map.
8. **Directional continuity.** Forward enters from the trailing edge and back returns to it. Deeper levels grow in from scale 0.94; shallower levels shrink in from 1.04. The eye learns the hierarchy from the direction. Check: push and pop three levels; the direction never flips.
9. **Titles live in the parent.** If a title, toolbar, or pill exists on both sides of a push, render it in a container that survives the push. Animating it out and back in is the most common continuity break. Check: on push, nothing that persists flickers.
10. **Hero transitions animate the radius with the size.** A thumbnail at radius 18 becomes a full-screen view at radius 0 by way of the device bezel radius (~38) during drag-dismiss. A radius that jumps reads as a cut. Check: scrub a hero transition at 10% speed; corners never pop.
11. **Destructive confirmations name the noun.** `confirmationDialog` with a button titled "Delete project" and `role: .destructive`, never "Are you sure?" with Yes/No. Pair with `.sensoryFeedback(.warning)` on present. Check: grep `confirmationDialog`; every destructive button names what it destroys.
12. **Share with `ShareLink` and `Transferable`.** The system sheet inherits the correct appearance, supports every target, and needs no `UIViewControllerRepresentable`. Check: grep `UIActivityViewController`; each is justified by a target `ShareLink` cannot reach.
13. **On iPad, quick choices are popovers, not sheets.** A full-width sheet for a three-item picker on a 13-inch screen is a phone layout leaking. Check: run the app on iPad; every small picker anchors to its trigger.

### Cheat sheet

| Job | Detents | Indicator | Extras |
|---|---|---|---|
| Quick confirm, 1–2 actions | `.height(220)` or `.fraction(0.25)` | visible | |
| Picker, short list | `.medium` | visible | iPad: `.popover` |
| Filter, browse | `[.medium, .large]` | visible | `backgroundInteraction(.enabled(upThrough: .medium))` when the parent is a map/chart/player |
| Form, compose | `.large` | hidden if Close exists | `.interactiveDismissDisabled(isDirty)` |
| Full takeover | `.large` | hidden | `.presentationDragIndicator(.hidden)` |

| Motion | Value |
|---|---|
| Sheet present | `.spring(duration: 0.42, bounce: 0.18)` |
| Sheet dismiss | `.spring(duration: 0.32, bounce: 0)` |
| Contents offset | +60–80ms, stagger 30ms |
| Push | `.spring(duration: 0.38, bounce: 0.05)`; deeper from 0.94, shallower from 1.04 |
| Hero | `.spring(duration: 0.42, bounce: 0.16)`; radius 18 → 38 → 0 on drag-dismiss |
| Drag-dismiss commit | 120pt or 600pt/s |
| Corner radius | project's large radius, one constant |
| Stacked sheets | ≥ 25% height difference |

### Code

#### The canonical sheet modifier stack

```swift
enum Sheet {
    static let radius: CGFloat = 28   // the project's large radius; set once
}

.sheet(isPresented: $showFilters) {
    FilterView()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Sheet.radius)
        .presentationBackground(.background)              // adopt the environment
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
}
```

#### Contents arriving after the container

```swift
struct SheetBody: View {
    @State private var landed = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                row
                    .opacity(landed ? 1 : 0)
                    .offset(y: landed ? 0 : 6)
                    .animation(.smooth(duration: 0.22).delay(0.07 + Double(index) * 0.03), value: landed)
            }
        }
        .onAppear { landed = true }
    }
}
```

#### Titles in the parent (bad, then good)

```swift
// Bad: the title is inside each destination, so it leaves and returns on every push.
NavigationStack {
    ListView().navigationTitle("Library")
}
.navigationDestination(for: Item.self) { item in
    DetailView(item: item).navigationTitle(item.name)
}

// Good: persistent chrome sits in a parent that survives; only content transitions.
struct Shell: View {
    @State private var path: [Item] = []
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: path.last?.name ?? "Library")   // one view, crossfades its text
                .animation(.smooth(duration: 0.22), value: path.count)
            NavigationStack(path: $path) {
                ListView()
                    .navigationDestination(for: Item.self) { DetailView(item: $0) }
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
```

#### Hero with animated radius

```swift
struct Hero: View {
    @Namespace private var ns
    @State private var open = false
    @State private var dragProgress: CGFloat = 0     // 0 at rest, 1 at commit
    let item: Item

    var body: some View {
        ZStack {
            if !open {
                Thumb(item: item)
                    .clipShape(.rect(cornerRadius: 18, style: .continuous))
                    .matchedGeometryEffect(id: item.id, in: ns)
                    .onTapGesture { withAnimation(.spring(duration: 0.42, bounce: 0.16)) { open = true } }
            } else {
                Full(item: item)
                    .clipShape(.rect(cornerRadius: 38 * dragProgress, style: .continuous))   // bezel radius while dragging
                    .matchedGeometryEffect(id: item.id, in: ns)
                    .ignoresSafeArea()
            }
        }
    }
}
```

At rest the full view has radius 0. As the user drags to dismiss, `dragProgress` rises and the corners round toward the bezel; on commit the spring carries it back to 18 at the thumbnail. The radius is a function of the same value that moves the view, which keeps it on one curve.

#### Directional push with depth scaling

```swift
extension AnyTransition {
    /// Deeper grows in from 0.94; shallower shrinks in from 1.04.
    static let deeper = AnyTransition.asymmetric(
        insertion: .scale(scale: 0.94).combined(with: .opacity),
        removal: .opacity)
    static let shallower = AnyTransition.asymmetric(
        insertion: .scale(scale: 1.04).combined(with: .opacity),
        removal: .opacity)
}

.transition(isGoingDeeper ? .deeper : .shallower)
.animation(.spring(duration: 0.38, bounce: 0.05), value: level)
```

#### Destructive confirmation and share

```swift
.confirmationDialog("Delete \"\(project.name)\"?", isPresented: $confirmDelete, titleVisibility: .visible) {
    Button("Delete project", role: .destructive) { delete(project) }
    Button("Cancel", role: .cancel) {}
} message: {
    Text("This removes the project and its 12 files. You can restore it from Recently Deleted for 30 days.")
}
.sensoryFeedback(.warning, trigger: confirmDelete) { _, new in new }

ShareLink(item: project, preview: SharePreview(project.name, image: project.cover)) {
    Label("Share", systemImage: "square.and.arrow.up")
}
```

`Project` conforms to `Transferable` with a `ProxyRepresentation` for text and a `FileRepresentation` for the export; the share sheet picks the right one per target.

#### iPad popover for small choices

```swift
.popover(isPresented: $showSort, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
    SortPicker()
        .presentationCompactAdaptation(.sheet)   // phones still get a sheet
}
```

### Checks

- Every sheet maps to one row of the detent table and uses the shared radius constant.
- Present each sheet from dark mode and from a tinted screen; it matches.
- Stack two sheets; heights differ by ≥ 25%.
- Watch a sheet open at 10% speed; the container lands before its children appear.
- Push three levels deep and pop; direction and scale never flip; persistent chrome never flickers.
- Scrub a hero transition; the corner radius is continuous.
- Every destructive dialog names the noun and uses `role: .destructive`.
- On iPad, small pickers are popovers anchored to their trigger.

### Do not

- Leave `.presentationCornerRadius` at its 10pt default when the project's cards are 16–28.
- Present a full-height sheet for two buttons.
- Present a sheet from a sheet at the same height.
- Put the title inside each destination and animate it on every push.
- Use `.easeIn` on a sheet's arrival.
- Build `UIActivityViewController` wrappers where `ShareLink` works.
- Ask "Are you sure?".

<!-- references/sound.md -->

## Sound

Use this when adding or auditing UI sound: which moments get a cue, how loud, through which audio session, and how the user turns it off.
Sound is the rarest channel and the easiest to get wrong. A few short cues on meaningful beats make an app feel physical; a cue on every tap makes it feel like a toy.

### Rules

1. **Three to five cues, each under 200ms.** More than five and the user cannot tell them apart; longer than 200ms and it becomes music. Check: list the cues; each has a name, a moment, and a duration you can state.
2. **Only meaningful beats get sound.** Something you did landed (sent, saved, completed), a rare milestone. Frequent, noisy actions (typing, scrolling, toggling, tapping rows) stay silent. Check: on the primary path, count sounds; expect one to three.
3. **Each cue has its own volume.** A milestone may be fuller (0.5); a success is quiet (0.34); everything else quieter still (0.24). One global level makes the small moments too loud or the big one too small. Check: every cue defines a volume.
4. **Use the `.ambient` category with `.mixWithOthers`.** This respects the Ring/Silent switch, never ducks music or podcasts, and never interrupts a call. Any other category makes your app the thing that interrupted someone's music. Check: play a podcast, trigger a cue; the podcast does not dip.
5. **Land within 10ms of the paired haptic.** Trigger both from the same call, with the player already prepared (`prepareToPlay()`). A late sound reads as a second event. Check: the two feel like one.
6. **Ship a toggle, default on, in Settings.** Sound is personal. The toggle lives with the app's other feedback settings, not buried under Advanced. Check: turn it off; every cue is silent, including system-sound fallbacks.
7. **Resolve cues by name so a designer can upgrade them without code.** Look for `<cue>.caf` (then `.wav`, `.m4a`, `.aif`) in the bundle; fall back to a restrained system sound ID. Dropping a licensed file into the bundle upgrades a cue. Check: rename a bundled file; the cue falls back cleanly.
8. **Synthesise when the sound must never repeat exactly.** Mechanical or physical apps (flip boards, dials, shutters) can generate cues at launch from filtered noise, a damped ring, and a low thud, with per-variant randomisation. Zero bundle weight, infinite variance. Check: trigger the same cue ten times; no two are identical.
9. **Throttle and scale with density, like haptics.** Many events at once become one softer flutter, not many loud ticks: minimum gap 18–28ms as density rises, level `0.28 + 0.42 × density`. Check: a cascade reads as one texture.
10. **Attack over 1.5ms, never from sample zero.** A cue that starts at full amplitude clicks. Check: listen on headphones; no click at the start.
11. **Know when sound is wrong.** Productivity tools, reading apps, finance, anything used in meetings: default to no sound at all, and never for errors. Check: the design contract states "Sound: none" explicitly when that is the decision.

### Cheat sheet

| Cue | Moment | Volume | System fallback |
|---|---|---|---|
| send | you sent something | 0.24 | 1004 |
| success | an action committed | 0.34 | 1057 (Tink) |
| save | something was kept | 0.24 | 1103 |
| celebrate | a rare milestone | 0.5 | 1025 |

| Setting | Value |
|---|---|
| Category | `.ambient`, options `[.mixWithOthers]` |
| Max duration | 200ms |
| Cue count | 3–5 |
| Sync with haptic | ≤ 10ms |
| Attack | 1.5ms |
| Throttle under load | 18–28ms gap, density-scaled level |
| Toggle | Settings, default on |

### Code

#### A cue player with bundled override and system fallback

```swift
import AVFoundation
import AudioToolbox

@MainActor
final class SoundFX {
    static let shared = SoundFX()
    private init() {}

    enum Cue: String, CaseIterable {
        case send, success, save, celebrate

        var systemID: SystemSoundID {
            switch self {
            case .send: 1004
            case .success: 1057
            case .save: 1103
            case .celebrate: 1025
            }
        }
        var volume: Float {
            switch self {
            case .celebrate: 0.5
            case .success: 0.34
            default: 0.24
            }
        }
    }

    var enabled: Bool { UserDefaults.standard.object(forKey: "soundEffects") as? Bool ?? true }

    private var players: [Cue: AVAudioPlayer] = [:]
    private var sessionReady = false

    func play(_ cue: Cue) {
        guard enabled else { return }
        if let player = player(for: cue) {
            prepareSession()
            player.volume = cue.volume
            player.currentTime = 0
            player.play()
        } else {
            AudioServicesPlaySystemSound(cue.systemID)
        }
    }

    /// Prepare the players you will need in the next second, so the cue lands with its haptic.
    func warm(_ cue: Cue) { player(for: cue)?.prepareToPlay() }

    private func player(for cue: Cue) -> AVAudioPlayer? {
        if let p = players[cue] { return p }
        let exts = ["caf", "wav", "m4a", "aif"]
        guard let url = exts.lazy.compactMap({ Bundle.main.url(forResource: cue.rawValue, withExtension: $0) }).first,
              let p = try? AVAudioPlayer(contentsOf: url) else { return nil }
        p.prepareToPlay()
        players[cue] = p
        return p
    }

    private func prepareSession() {
        guard !sessionReady else { return }
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        sessionReady = true
    }
}
```

Usage, paired with a haptic from the same line:

```swift
Button("Send") {
    Task {
        SoundFX.shared.warm(.send)
        if await send() {
            sentCount += 1                       // .sensoryFeedback(.success, trigger: sentCount)
            SoundFX.shared.play(.send)
        }
    }
}
```

#### Synthesised cue (shape only; tune the numbers to the object)

```swift
/// A short mechanical click: filtered noise (the strike) over a damped ring (the housing)
/// and a low thud (the body). Generated once per variant at launch; no assets.
static func makeClick(seed: UInt64, sampleRate sr: Double = 44_100) -> [Float] {
    var rng = SplitMix64(seed: seed)
    let duration = 0.045
    let n = Int(sr * duration)
    let resonance = 1500.0 + rng.next(in: -350...450)   // Hz; varies per variant
    let body      = 210.0  + rng.next(in: -40...40)
    let noiseDecay = 900.0 + rng.next(in: -200...300)   // 1/s
    let ringDecay  = 260.0 + rng.next(in: -60...60)
    let lpCoef = 0.35 + rng.next(in: -0.08...0.1)       // one-pole low pass on the noise
    var lp = 0.0, hpPrev = 0.0, hpPrevIn = 0.0
    var out = [Float](repeating: 0, count: n)
    for i in 0..<n {
        let t = Double(i) / sr
        lp += (rng.next(in: -1...1) - lp) * lpCoef
        let noise = lp * exp(-t * noiseDecay)
        let ring  = sin(2 * .pi * resonance * t) * exp(-t * ringDecay) * 0.35
        let thud  = sin(2 * .pi * body * t) * exp(-t * 180) * 0.25
        var s = noise * 1.6 + ring + thud
        let hp = 0.995 * (hpPrev + s - hpPrevIn); hpPrevIn = s; hpPrev = hp; s = hp   // keep it out of the mud
        let attack = min(1, t / 0.0015)                                                 // 1.5ms; no click at sample 0
        out[i] = Float(max(-1, min(1, s * attack * 0.8)))
    }
    return out
}
```

Make 6–8 variants at launch, keep a small pool of `AVAudioPlayerNode` voices, and pick a random variant per play. Throttle: `minGap = moving > 40 ? 0.018 : (moving > 8 ? 0.028 : 0)`; level `0.28 + 0.42 × min(1, moving / 60)`.

### Checks

- Play music, trigger every cue: the music never dips.
- Flip the Ring/Silent switch: every cue is silent.
- Turn the in-app toggle off: every cue is silent, including system fallbacks.
- Trigger a cue with its haptic: one event, not two.
- Headphones, each cue: no click at the start, nothing over 200ms.
- Count cues on the primary path: one to three.
- Delete a bundled file: the cue falls back to the system sound without a crash.

### Do not

- Use `.playback` or `.soloAmbient` for UI cues.
- Add a sound to tapping, typing, toggling, or scrolling.
- Ship one global volume.
- Play a sound for an error.
- Add sound to a productivity or reading app without a written reason in the design contract.
- Start a synthesised cue at full amplitude.
- Fire a sound from a timer or a background completion.

<!-- references/states.md -->

## States

Use this when a screen fetches, saves, waits, fails, or is empty. That is every screen.
The empty state is the first impression for every new user, and the error state is the moment trust is won or lost.

### Rules

1. **Every list, fetch, and form has empty, loading, error, and success.** Why: a screen that only works when data is present only works in the demo. Check: force each state with a debug flag or a fake store; none is a blank white view.
2. **Follow the loading ladder.** 0–500ms silent; 500ms–2s subtle inline; 2s+ explicit progress with a label; 10s+ a Live Activity or notification. Why: a spinner for 300ms reads as a flicker, and a silent 5s reads as broken. Check: time the network call on a slow simulator profile and see the right rung.
3. **The spinner travels.** Progress appears where the result will land, not only on the control that was tapped. Why: the eye follows one location, so anchor it to the destination. The control may carry progress as well once the result has a home of its own; it may never be the only place it appears. Check: after tapping Send, the bubble shows the progress, whether or not the button does too.
4. **Skeletons structurally match.** Same bar count, widths, and positions as the real content. Why: three bars for five-line content breaks the illusion the moment it resolves. Check: overlay the skeleton on a loaded cell; the boxes line up.
5. **Optimistic first.** Apply the change immediately; a pending item is a ghost at opacity 0.6; revert with an inline reason on failure. Why: the user's action causes the visible effect; the network is an implementation detail. Check: airplane mode, tap Like; the heart fills, then reverts with a line under it.
6. **Empty states invite.** A symbol or small illustration, one warm line of why, one action. Never "No items". Why: it is the only screen every new user sees. Check: the copy names what to do next and there is one button or a pointer to one.
7. **First-run and empty are different states.** First-run introduces; empty after use reflects ("You cleared everything. Nice."). Check: both exist when the difference matters.
8. **Errors rise in context and keep the last good value visible.** A strip or line at the thing that failed, not a toast in the sky. Why: the user is looking at the thing; the fix belongs there. Check: the failed row still shows its previous content, dimmed, with the reason underneath.
9. **Undo must actually undo.** Reverse the effect, not just hide the toast. Check: Undo restores the row, the memory, the setting; the model state matches.
10. **Celebrate rarely.** At most one celebration per session, for milestones, 60–120 particles, under 3s. Why: confetti on every save is exhausting by day three. Check: list every celebration trigger; each is weekly or rarer.
11. **Offline is a state, not an error.** Cached content stays usable; a quiet banner says what is stale. Check: airplane mode; the app is still useful.
12. **Overflow is a state.** 200 items, a 60-character title, a 4-line description. Check: run with a fake store of 5000 rows and a long-string locale.
13. **Permission denied has its own screen with a Settings path.** Why: the system alert only appears once; after that the app must explain and offer `UIApplication.openSettingsURLString`. Check: deny in Settings, relaunch, see the screen.
14. **A long local job is a different shape from a network wait.** A video export, a batch of photos, or an on-device model run takes tens of seconds on the user's own hardware, reports real per-unit progress, and can be cancelled. Give it determinate progress with a count ("14 of 60"), a Cancel that actually stops the work rather than hiding the sheet, and a surface that survives the job. Why: the loading ladder above is written for a request you are waiting on, not for work you are doing. Check: start the longest job in the app, press Cancel, and confirm the CPU drops and no file is written.
15. **The progress surface must not disappear in the same frame as the failure.** If the job's sheet unmounts the moment it throws, the message lands somewhere the user is not looking and the thing they were watching vanishes at the same time. Keep the surface, swap its contents to the error, and let the user dismiss it. Why: this is the most common way a real failure becomes invisible. Check: force the job to fail; the message appears where the progress was.
16. **A job that outlives the foreground ends in a system surface.** If the app can be backgrounded mid-job, completion is a Live Activity or a local notification, not a toast nobody sees. Register a background task so the work is not suspended halfway. Why: a 40 second export is exactly long enough for someone to switch apps. Check: start the job, background the app, and confirm you are told when it finishes.
17. **One channel per severity, and only one.** Two implementations of "tell the user something went wrong", with the important path wired to the older one, is a common and invisible bug: the newer channel wraps, persists, and is reachable, and the path that matters still uses the string that predates it. Why: nobody notices the second channel because each one works in isolation. Check: grep for every way the app can surface an error (`Toast`, `banner`, `alert`, a status `String` on a view model) and confirm there is exactly one per severity; if there are two, list every call site of the older one and move them.

### Cheat sheet

| Elapsed | Show | Where |
|---|---|---|
| 0–500ms | Nothing, or the optimistic result | |
| 500ms–2s | Subtle inline progress | Where the result will land |
| 2s+ | Explicit progress with a label and cancel if possible | Same place |
| 10s+ | Live Activity or completion notification | System surfaces |

| Outcome | Treatment | Timing |
|---|---|---|
| Minor, reversible, global ("Archived") | Capsule toast with Undo | Auto-dismiss ~2.2s; clip at 44 characters |
| Important success, error, completion | Inline at the thing that changed | Persists until resolved or dismissed |
| The app acted on the user's behalf | Receipt card in the flow: symbol, title, one detail line, Undo if apt | Persists in the list |
| Destructive | Confirm naming the noun, then resolve in place | |
| Milestone | One quiet landing beat, optionally particles | ≤ 3s, ≤ 1 per session |

| State | Anatomy |
|---|---|
| Empty (first run) | Symbol, one line that names the first action, one button |
| Empty (search) | "No results for 'apricot'." plus a way out ("Clear filters") |
| Empty (after clearing) | Acknowledge, no button needed |
| Error (inline) | Last good value dimmed, one line of what happened, one line of what to do |
| Error (full screen, nothing cached) | Symbol, plain reason, Retry |
| Offline | Banner "Showing saved data" and content still usable |
| Permission denied | Why the app needs it, what works without it, "Open Settings" |

| Long local job | Treatment |
|---|---|
| Progress | Determinate, with a count ("14 of 60"), in a surface that survives the job |
| Cancel | Always reachable; stops the work, not just the sheet |
| Failure | Replaces the contents of the same surface; never unmounts it |
| Partial success | Report the split ("58 exported, 2 skipped") and keep the failures identifiable |
| Backgrounded | Live Activity or local notification, plus a background task so it is not suspended |

Error strip shape (from a shipped control-surface app): rises from the bottom edge of the failing region in 280ms with `.spring(duration: 0.28, bounce: 0)`, dwells 4s, sinks away. It is inside the region, not above the whole screen.

### Code

Skeleton that matches the real row and shimmers with `TimelineView`.

```swift
struct SkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle().frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 6, style: .continuous).frame(width: 160, height: 14)
                RoundedRectangle(cornerRadius: 6, style: .continuous).frame(width: 110, height: 12)
            }
            Spacer()
        }
        .foregroundStyle(.quaternary)
        .modifier(Shimmer())
    }
}

struct Shimmer: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    func body(content: Content) -> some View {
        content.overlay {
            if !reduceMotion {
                TimelineView(.animation(minimumInterval: 1 / 30)) { context in
                    let t = context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.4) / 1.4
                    LinearGradient(colors: [.clear, .white.opacity(0.25), .clear],
                                   startPoint: .leading, endPoint: .trailing)
                        .frame(width: 200)
                        .offset(x: -200 + CGFloat(t) * 600)
                        .mask(content)
                }
            }
        }
    }
}
```

Optimistic update with a ghost and an inline revert.

```swift
@Observable final class LikeState {
    var isLiked = false
    var isPending = false
    var failure: String?

    func toggle(api: API, id: String) {
        let previous = isLiked
        isLiked.toggle()
        isPending = true
        failure = nil
        Task {
            do {
                try await api.setLiked(isLiked, for: id)
            } catch {
                isLiked = previous
                failure = "Couldn't save. Check your connection."
            }
            isPending = false
        }
    }
}

// In the view
Image(systemName: state.isLiked ? "heart.fill" : "heart")
    .contentTransition(.symbolEffect(.replace))
    .opacity(state.isPending ? 0.6 : 1)
if let failure = state.failure {
    Text(failure).font(.footnote).foregroundStyle(.secondary)
        .transition(.move(edge: .top).combined(with: .opacity))
}
```

Empty state with the system view, and when to go custom.

```swift
// System: fine for lists, search, and simple first runs.
ContentUnavailableView {
    Label("No notes yet", systemImage: "note.text")
} description: {
    Text("Your first note is one tap away.")
} actions: {
    Button("New note") { createNote() }.buttonStyle(.borderedProminent)
}

// Custom: when the empty state is the first impression of a hero feature and the
// project's illustration language exists. Same three parts, project's own art.
```

Toast with an Undo that reverts.

```swift
@Observable final class Toaster {
    struct Toast: Equatable { let message: String; let undo: (() -> Void)?
        static func == (a: Toast, b: Toast) -> Bool { a.message == b.message } }
    var current: Toast?

    func flash(_ message: String, undo: (() -> Void)? = nil) {
        let clipped = message.count > 44 ? String(message.prefix(42)) + "…" : message
        let toast = Toast(message: clipped, undo: undo)
        current = toast
        Task { try? await Task.sleep(for: .seconds(2.2)); if current == toast { current = nil } }
    }
}

// overlay(alignment: .bottom)
if let toast = toaster.current {
    HStack(spacing: 12) {
        Text(toast.message).font(.subheadline.weight(.medium))
        if let undo = toast.undo {
            Button("Undo") { undo(); toaster.current = nil }.font(.subheadline.weight(.semibold))
        }
    }
    .padding(.horizontal, 16).padding(.vertical, 10)
    .background(.regularMaterial, in: Capsule(style: .continuous))
    .padding(.bottom, 24)
    .transition(.move(edge: .bottom).combined(with: .opacity))
}
.animation(.spring(duration: 0.42, bounce: 0.18), value: toaster.current)
```

A quiet celebration without particles: one landing beat.

```swift
KeyframeAnimator(initialValue: 1.0, trigger: completed) { scale in
    checkmark.scaleEffect(scale)
} keyframes: { _ in
    SpringKeyframe(1.18, duration: 0.22, spring: .bouncy)
    SpringKeyframe(1.0, duration: 0.42, spring: .smooth)
}
.sensoryFeedback(.success, trigger: completed)
```

Permission denied with a path out.

```swift
ContentUnavailableView {
    Label("Camera is off", systemImage: "camera.slash")
} description: {
    Text("Turn it on in Settings to scan receipts. Manual entry still works.")
} actions: {
    Button("Open Settings") {
        if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
    }
}
```

### Checks

- Force each state with a launch argument (`-fake-store empty`, `-fake-store 5000`, `-fail-network`) and screenshot all of them.
- Throttle the network; confirm nothing spins before 500ms and something explains itself after 2s.
- Loaded cell over skeleton: boxes align.
- Airplane mode: cached content usable, optimistic actions revert with a reason.
- Every Undo restores model state, not just the UI.
- Count celebration triggers; each is rare.
- Deny a permission in Settings; the app explains and links out.
- Run the longest job in the app, press Cancel, and watch the CPU drop; nothing is written.
- Force that job to fail; the message appears where the progress was, and stays.
- Start it, background the app, and confirm completion still reaches you.
- List every way the app can report an error; there is one per severity, not two.

### Do not

- Show a spinner under 500ms, or on the button that was tapped.
- Use "No items", "Nothing here", or "Error" as copy.
- Put a field error in a toast, or the only Undo in a toast that vanishes.
- Ship a skeleton with a different structure from the content.
- Fail silently. A swallowed error is worse than a visible one.
- Unmount the progress surface in the same frame the job fails.
- Offer a Cancel that hides the sheet and leaves the work running.
- Keep a second, older error channel alive because the newer one arrived after it.
- Celebrate a routine save.
- Reuse the empty state for the error state; they are different questions.
- Park crucial persistent information in an empty state; it disappears with the first item.

<!-- references/typography.md -->

## Typography

Use this when you are setting up a type scale, auditing text hierarchy, fixing truncation or clipping, or making numbers and labels behave under Dynamic Type.
It does not choose a typeface. It makes whatever face the project uses read as one system at every size.

### Rules

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

### Cheat sheet

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

### Code

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

### Checks

- Distinct sizes on one screen ≤ 3 plus captions.
- No `.tracking` outside the two exceptions.
- Every changing number is `.monospacedDigit()`.
- AX5 preview: nothing clips, nothing overlaps, every label still fits or falls back.
- German preview: no truncated button.
- Custom fonts scale with the text size setting.
- No text baked into images.
- Paragraphs are leading-aligned and have ≥ 1.45× line height.

### Do not

- Introduce a second face because a heading "needs character". That is a design contract decision, not a polish decision.
- Use `.system(size:)` for anything a Dynamic Type style could express.
- Use `.bold` on body text for emphasis when `.semibold` is the project's heaviest weight.
- Centre a paragraph.
- Fix a truncation by shrinking the whole label with `minimumScaleFactor` below 0.7; write a shorter variant.
- Use letter-spacing to fit text; cut words instead.

See also: `references/color.md` for the ink hierarchy, `references/layout-and-spacing.md` for margins and air around text, `references/copy-and-naming.md` for the words themselves.

<!-- references/widgets-and-live-activities.md -->

## Widgets, Live Activities and Dynamic Island

Use this when the app ships a Home Screen, Lock Screen, or StandBy widget, a Control Center control, a Live Activity, or a Dynamic Island presentation. These surfaces are seen a hundred times a day for half a second each. That half-second is where most of an app's perceived quality lives.

### Rules

1. **Content margins, not safe areas.** WidgetKit gives every widget `widgetContentMargins` (about 16pt by default, 11pt when the system wants a tight grouping). `ignoresSafeArea()` has no effect inside a widget. Why: the system owns the container; you own the content. Check: no `ignoresSafeArea` in the extension target.
2. **Never type a literal corner radius inside a widget.** Use `ContainerRelativeShape()` for every nested card so corners stay concentric with the system container on every device. Why: the container radius differs by device and by family; a literal 22 clips on one and floats on another. Check: `grep -rn "cornerRadius\|RoundedRectangle" Widgets/` returns nothing but `ContainerRelativeShape`.
3. **`.containerBackground(for: .widget)` is required on iOS 17+.** It lets the system remove your background on the Lock Screen, in StandBy, and on the iPad Lock Screen. Why: without it the widget renders with a blank background in those placements or is rejected from them. Check: every widget view body ends with `.containerBackground(for: .widget) { ... }`.
4. **Only set `.containerBackgroundRemovable(false)` when the widget is its background.** A photo widget, a full-bleed gradient that carries the meaning. Cost: the widget is ineligible for iPad Lock Screen and StandBy. Why: you are trading reach for fidelity; know that you are doing it. Check: any `containerBackgroundRemovable(false)` has a comment stating the trade.
5. **Three render modes are three designs.** Read `widgetRenderingMode` and design for `.fullColor`, `.accented`, and `.vibrant` separately. In `.accented` the system treats your views as template images: it ignores hue and renders from the alpha channel. In `.vibrant` hierarchy comes from opaque greys (`Color(white: 0.6)`), never from white at reduced opacity, because opacity controls blur strength there and reads as mush. Why: one design tested only in full colour looks broken on two out of three placements. Check: preview all three modes; check `.vibrant` in greyscale.
6. **`widgetAccentable(false)` on a child does not undo a parent's `true`.** Structure accent groups deliberately. Check: accent groups are siblings, not nested.
7. **Typography floor is 11pt; no Ultralight, Thin, or Light weights.** Why: the widget is read at arm's length, often through a blur. Check: `grep -rn "\.light\|\.thin\|\.ultraLight" Widgets/` is empty; no `.system(size:` under 11.
8. **`ViewThatFits` for every variable-length string.** Provide the ideal, a tighter variant, and a last resort. Test at AX5 and in German. Why: a truncated hero label is the most common shipped widget bug. Check: every `Text` bound to data sits inside a `ViewThatFits`.
9. **Every changing number is `.monospacedDigit()`** and transitions with `.contentTransition(.numericText())`. Why: 99 becoming 100 otherwise shifts the whole layout. Check: grep for numbers without `monospacedDigit`.
10. **What a widget can animate:** `Text(timerInterval:)` and `Text(_:style:)` tick on their own with zero timeline entries; `.contentTransition(.numericText())`, `.contentTransition(.symbolEffect(.replace))`, `.contentTransition(.opacity)`, `.interpolate`; a background wash that shifts per entry; `.invalidatableContent()` while an intent runs. **What it cannot:** continuous animation, `TimelineView(.animation)`, gestures, press-scale, confetti, particles, breathing icons. Why: the widget is a snapshot; pretending otherwise produces a frozen frame of a half-finished animation. Check: no `withAnimation`, `repeatForever`, or `TimelineView(.animation)` in the extension.
11. **Timeline entries at least 5 minutes apart; long timelines.** Budget is roughly 40–70 reloads per day per device. Recompute any ambient wash per entry at a 30–60 minute cadence. Why: exceed the budget and the system throttles you into showing stale data. Check: `TimelineProvider` produces entries spaced ≥ 5 minutes and a policy of `.after` or `.atEnd`, never `.never` for live data.
12. **The widget itself is near-silent.** Its only life is a wash healing across the day and a number rolling when it changes. That restraint is the polish. Why: a widget that shouts is a widget that gets removed. Check: nothing on the widget moves except the number and the background.
13. **App writes, extension reads.** Keep one `Codable` snapshot in the App Group container. The extension never queries PhotoKit, HealthKit, or the network directly. Why: the extension has seconds of runtime and no permission prompts; a query that works in the app hangs in the extension. Check: the extension imports no data framework.
14. **Deep-link continuity.** The link carries exactly what was tapped (the item, the mode). The app enters from a matching state, ideally with the same visual it was tapped on. Why: tap the widget and it should feel like you picked the thing up. Check: `widgetURL` or `Link` destinations are specific; no widget opens the app's root.
15. **Lock Screen accessory sizes are fixed.** `.accessoryCircular` about 76×76pt, `.accessoryRectangular` about 172×76pt, `.accessoryInline` one line of text with an optional leading symbol. No drop shadows, no gradients: tint mode flattens them. Check: accessory families preview in tint mode.
16. **StandBy is read from across a room.** Hero number ≥ 56pt. Test the red night-tint mode; most widgets have never been checked there and look broken. Check: preview with the StandBy environment and the red tint.
17. **Live Activity Lock Screen presentation ≤ 160pt tall.** Top row 24pt, bottom row 20pt. It hugs the sensor housing. System animations cap at about 2 seconds, there are none on Always-On, and it ignores your `withAnimation`. Update cadence matches the domain: transport every 30 s, audio every 5–10 s, a flight every 10 minutes until approach. Check: the activity view fits in a 160pt frame at AX3.
18. **Dynamic Island has hard limits.** Compact regions about 50pt wide, ≤ 5 characters each. Minimal is a single 22×22pt glyph. Expanded ≤ 200pt tall. Inset every image ≥ 4pt from the edge. No background colours. No buttons in compact or minimal. `.keylineTint` is the only branding chrome you get. Why: the island is system territory; violate the shape and it reads as a bug. Check: compact leading and trailing views are a glyph plus at most five characters.
19. **End a Live Activity with a short summary, then dismiss.** `dismissalPolicy: .after(.now + 15...30 min)` for "arrived", `.immediate` for cancelled. The system cap is 8 hours; design guidance is much shorter. Why: a stale "arriving" activity on the Lock Screen at midnight is a broken promise. Check: every `Activity.end` call passes a policy.
20. **Control Center titles are verb-first.** "Log water" reads on the Action Button as "Hold to Log Water". The control performs instantly and does not open the app unless the action needs a screen. Check: `ControlWidgetButton` titles start with a verb; `openAppWhenRun` is false unless there is a screen to show.
21. **Widget copy.** Relative time ("updated 4 min ago") over absolute. Empty state is warm and short ("nothing logged yet"), never "No data". Errors say "couldn't refresh" with the last good value dimmed, never "Error 404". Chrome labels lowercase if the project's copy is; sentence case otherwise. Gallery description is one verb-first sentence.
22. **Contrast for custom colours in dark mode: 7:1 for small text, never below 4.5:1.** Why: the Home Screen wallpaper is unknown; the widget container is your only guarantee.
23. **No confetti in a widget.** Completion is a quiet landing beat: the number lands, the gauge fills, the symbol morphs. **No faked press states.** The system gives you none; pretending is worse than nothing.

### Cheat sheet

| Surface | Size | Type floor | What moves |
|---|---|---|---|
| Small (Home) | ~158–170pt square | 11pt | number, wash |
| Medium (Home) | ~338–364 × 158–170pt | 11pt | number, wash |
| Large (Home) | ~338–364 × 354–382pt | 11pt | number, wash |
| Extra large | iPad and Mac only | 11pt | number, wash |
| Accessory circular | ~76×76pt | 11pt | number |
| Accessory rectangular | ~172×76pt | 11pt | number |
| Accessory inline | one line | system | text |
| StandBy | full | hero ≥ 56pt | number, wash |
| Live Activity (Lock) | ≤ 160pt tall | 12pt | `timerInterval`, `numericText` |
| Island compact | ~50pt each side, ≤ 5 chars | 12pt | `numericText` |
| Island minimal | 22×22pt | glyph | replace |
| Island expanded | ≤ 200pt tall | 12pt | `numericText` |

Content margins: ~16pt default, ~11pt tight. Timeline: entries ≥ 5 min; 40–70 reloads a day. Dark custom colours: 7:1 small text.

### Code

Snapshot shared through the App Group (app writes, extension reads):

```swift
struct WidgetSnapshot: Codable, Equatable {
    static let appGroup = "group.com.example.app"      // rename
    var count: Int
    var label: String?
    var updated: Date

    static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
            .appendingPathComponent("widget", isDirectory: true)
    }
    static func load() -> WidgetSnapshot? {
        guard let url = containerURL?.appendingPathComponent("snapshot.json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(WidgetSnapshot.self, from: data)
    }
    func save() throws {
        guard let dir = Self.containerURL else { return }
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try JSONEncoder().encode(self).write(to: dir.appendingPathComponent("snapshot.json"), options: .atomic)
    }
}
```

A widget view that respects every rule above:

```swift
struct CountWidgetView: View {
    @Environment(\.widgetRenderingMode) private var mode
    let entry: CountEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ViewThatFits {
                Text(entry.label)
                Text(entry.shortLabel)
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(secondary)

            Text(entry.count, format: .number)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .contentTransition(.numericText())
                .foregroundStyle(primary)

            Text("updated \(entry.date, style: .relative) ago")
                .font(.system(size: 11))
                .foregroundStyle(secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) { Color.clear }   // project background here
        .widgetURL(entry.deepLink)
    }

    // Vibrant hierarchy is opaque grey, never white at opacity.
    private var primary: Color { mode == .vibrant ? Color(white: 0.95) : .primary }
    private var secondary: Color { mode == .vibrant ? Color(white: 0.6) : .secondary }
}
```

Dynamic Island shape, within the limits:

```swift
DynamicIsland {
    DynamicIslandExpandedRegion(.leading) { Image(systemName: "figure.walk").padding(4) }
    DynamicIslandExpandedRegion(.trailing) {
        Text(timerInterval: context.state.range, countsDown: true).monospacedDigit()
    }
} compactLeading: {
    Image(systemName: "figure.walk")
} compactTrailing: {
    Text(context.state.shortStatus)          // ≤ 5 characters
        .monospacedDigit()
} minimal: {
    Image(systemName: "figure.walk")         // 22×22
}
.keylineTint(.accentColor)
```

### Checks

- Preview every family in `.fullColor`, `.accented`, and `.vibrant`; view `.vibrant` in greyscale.
- Preview accessory families in tint mode; nothing relies on a gradient or shadow.
- Preview StandBy with the red night tint.
- Set the simulator to AX5 and switch the language to German; no label truncates outside a `ViewThatFits` fallback.
- Tap every widget and every Live Activity; the app lands on the tapped thing, not the root.
- Force a timeline reload and count entries; spacing ≥ 5 minutes.
- Kill the app, wait an hour, look at the widget; it shows a relative time and the last good value, not "No data".
- Extension target imports: no PhotoKit, HealthKit, CoreLocation, or networking.

### Do not

- The shrunk screen: a miniature of the app's home view.
- The dead-centre logo: a widget whose hero is the brand mark.
- Washed-out tint: a custom colour that disappears in `.accented`.
- The mush: white at 0.5 opacity in `.vibrant`.
- The confident stale number: a value with no "updated" line and no dimming when old.
- The clipped corner: a literal radius inside `ContainerRelativeShape` territory.
- The blank widget: a timeline provider that ran out of memory fetching thumbnails.
- The dead-end tap: `widgetURL` that opens the app root.
- "Tap to configure": a placeholder that never had placeholder data.
- The teleport: a number that jumps without `.numericText`.
- The breathing icon: any symbol effect that loops.
- The disagreeing parts: the number, the gauge, and the label reflecting different timeline entries.
- The everything panel: three metrics, two buttons, and a chart in a small widget.

