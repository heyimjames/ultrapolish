# ultrapolish

Two universal design-polish skills. They make an existing interface better within its own
visual style. They never introduce a palette, a typeface, or a motion personality.
Read the section that matches the platform you are working on.

## Index

- **ultrapolish-ios: universal polish for Swift / SwiftUI apps**
- **ultrapolish-web: universal polish for React / TypeScript / CSS apps**

---

## ultrapolish-ios: universal polish for Swift / SwiftUI apps

_When to use this section: Universal polish for native Swift/SwiftUI apps. Takes a competent app to a beloved one within its own visual style; never introduces a palette, typeface, or motion personality. Use whenever the user is building, reviewing, auditing, or refining an iOS app and wants it to feel considered, cohesive, premium, and detailed. Covers motion and springs, gestures, colour (OKLCH, Display P3, dark mode), typography and Dynamic Type, 4pt layout, hierarchy, buttons, sheets, navigation, haptics, sound, SF Symbols, copy, empty/loading/error states, onboarding, paywalls, StoreKit, widgets, Live Activities, Dynamic Island, Liquid Glass, accessibility. Triggers on polish, feels generic, premium, craft, cohesive, make it better, audit UI, spring, .snappy, sheet, detent, haptic, sensoryFeedback, sound effect, button, CTA, SF Symbol, symbolEffect, microcopy, empty state, skeleton, onboarding, paywall, widget, Live Activity, glassEffect, Dynamic Type, VoiceOver, Reduce Motion, tap target, dark mode, OKLCH, design tokens._

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



---

## ultrapolish-web: universal polish for React / TypeScript / CSS apps

_When to use this section: Universal polish for web apps and sites built with React, TypeScript, and CSS. Takes a competent interface to a beloved one within its own visual style; never introduces a palette, typeface, or motion personality. Use whenever the user is building, reviewing, auditing, or refining a web UI and wants it to feel considered, cohesive, premium, and detailed. Covers easing and springs, gestures and scroll, colour (OKLCH, APCA, dark mode), typography, 4px layout, surfaces, buttons, forms, overlays, haptics, icons, copy, states, onboarding and pricing, mobile web, performance, accessibility, marketing pages. Triggers on polish, feels generic, premium, craft, cohesive, make it better, audit UI, easing, cubic-bezier, spring, Motion, hover, focus ring, shadow, radius, modal, drawer, sheet, popover, tooltip, toast, form, input, button, icon, typography, OKLCH, contrast, dark mode, empty state, skeleton, layout shift, iOS Safari, safe-area, reduced motion, a11y, landing page, pricing page, design tokens._

# ultrapolish-web

Universal polish for web interfaces. Any app or site, its own style, from 6/10 to 11/10 on detail, UX, and cohesion.

This is not a visual style. It is a craft standard and a procedure. It works with editorial monochrome, with dense data tools, with playful consumer apps. It makes what is already there feel considered, continuous, and alive.

## 0. The universality guard

Read this before touching a pixel.

1. **Read before you write.** Find the project's own rules: `DESIGN.md`, `AGENTS.md`, `CLAUDE.md` design sections, `globals.css`, `tailwind.config`, `@theme` blocks, token files, a `motion.ts`, a components directory. Grep for `--radius`, `--ease`, `cubic-bezier`, `transition:`, `box-shadow`, `font-family`, `@media (prefers-`. Build the intake table (section 1) before proposing anything.
2. **Never introduce what the project does not have.** No new typeface, no new palette, no new radius language, no new motion personality. If the site is sharp and flat, polish it sharp and flat. If it is soft and rounded, polish it soft and rounded.
3. **Numbers here are defaults for projects without an established value.** The project's own token wins whenever it is used consistently. Inconsistency is the finding; the value is not.
4. **The anti-pattern list is a negative list.** It says what reads as generic or careless. It does not imply a positive style.
5. **No system? Propose one before polishing.** Offer the 15-line design contract from the design-contract-template reference below, get it agreed, then work inside it. Polishing without a contract produces a second, competing style.
6. **Restraint is a deliverable.** The right change is often "remove", "align", or "reuse". Every finding must name what the user gains. If you cannot, it is not a finding.

## 1. Workflow

### 1.1 Intake (always, ~2 minutes)

| Dimension | What the project already does | Source |
|---|---|---|
| Type | Faces, weights, scale, line-heights, `text-wrap` | `font-family`, `@theme`, `text-*` classes |
| Colour | Token names, light/dark mechanism, accent(s), how muted and disabled are made | `globals.css`, `:root`, `[data-theme]` |
| Radii | Distinct values, whether nested radii are concentric | `--radius*`, `rounded-*` |
| Spacing | Grid step, container padding, gaps | `gap-*`, `p-*`, `--spacing` |
| Motion | Easing tokens, durations, spring library, `prefers-reduced-motion` handling | `--ease*`, `transition`, `motion/react` |
| Surfaces | Shadow recipe, border vs shadow-as-border, image outlines | `box-shadow`, `border`, `outline` |
| Overlays | Modal/sheet/popover library, z-index scale, focus handling | `<dialog>`, Base UI, Radix, Vaul, `--z-*` |
| Forms | Input height, error placement, validation timing | `<input>`, `aria-invalid` |
| States | Which of empty / loading / error / success / offline exist | skeleton components, `Suspense` |
| Copy | Case, voice, emoji, punctuation, verb-first or not | strings, `<Button>` children |

A row can end in three states, and they are not the same finding:

- **A value.** Record it. It now outranks every default in this skill.
- **A rule instead of a token.** "Nested radius is always outer minus padding", applied at each site, is a system. Do not file it as a gap because it has no token file.
- **Genuinely absent, or not applicable.** Absent is a finding. Not applicable is not: an app with no forms has no form system to miss. Write "n/a" and move on.

Read the project's own rules before the code, but do not read all of them. A mature `CLAUDE.md` can run to a hundred kilobytes. In quick mode take the headings first (`grep '^#'`), then the design, theming and token sections, then the token file itself. Reading the whole document is a full-audit cost, not a two-minute one.

### 1.2 Mode

- **build**: you are writing the feature. Apply the standard as you go. The output table becomes the change log.
- **quick audit**: primary user path only, HIGH and MEDIUM findings, cap 8.
- **full audit**: every screen and every state (empty, loading, error, success, offline, first-run, overflow, 320px wide, 200% zoom, reduced motion, dark mode, keyboard-only, screen reader), cap 20.

State the mode in the first line of the output.

### 1.3 Sweep order

Foundational first, because a token fix upstream removes five leaf findings downstream.

1. Accessibility and states (can everyone reach and understand every state)
2. Layout and hierarchy (what the eye lands on first, second, third)
3. Copy and naming
4. Typography
5. Colour and surfaces
6. Motion and continuity
7. Controls, forms, overlays
8. Performance as felt (INP, layout shift, jank)

### 1.4 Output format

Always this shape. Group by root cause: a token or shared-component fix outranks the same symptom in five components, and is one row listing every location.

```
Mode: quick audit · Path: sign-up → dashboard · Viewports: 375, 1280

| # | Sev | Location | Where else | What is wrong, and what it should be | What this changes for the user |
|---|-----|----------|-----------|--------------------------------------|--------------------------------|
| 1 | HIGH | Button.tsx:12 | every button | Submit is disabled until the form validates, so the control that would explain the problem is the one switched off. Keep it enabled, validate on submit, focus the first invalid field | Users learn what is wrong instead of guessing why the button is dead |

Considered but rejected
| Candidate | Why not |
|---|---|
| Add hover lift to cards | Cards are not links; lift promises a click that does nothing |

Verified how
- Keyboard-only pass through the path; focus visible at every stop
- Chrome Animations panel at 10% speed for the sheet open/close pair

Verdict: Needs changes (1 HIGH, 4 MEDIUM)
```

Severity: **HIGH** blocks a task, misleads, hides content, loses data, or fails keyboard or screen-reader use. **MEDIUM** harms comprehension, efficiency, or consistency. **LOW** isolated polish, full mode only.

**Systemic raises severity by one step; it is not a severity of its own.** A shared component or token defect that is otherwise MEDIUM becomes HIGH. This keeps HIGH meaning "someone is blocked or misled" while still making the upstream fix outrank the leaf symptoms it causes.

Verdict vocabulary: `Ship`, `Needs changes`, `Block` (any HIGH).

Two columns earn their place and are easy to get wrong. **Where else** is what makes a systemic finding legible as one row instead of five; write "only here" when it is genuinely local. **What is wrong, and what it should be** is one prose cell, not a two-word before and a two-word after: a real finding needs the defect, the fix, and the reason in the same breath.

The "What this changes for the user" column is mandatory. It is the test of whether a finding is real.

## 2. The ten laws

These hold in every style. Break one only with a written reason.

1. **One datum, one curve.** Everything driven by the same value animates on the same easing and duration, together. Modal and its backdrop, tooltip and its arrow, a number and its bar.
2. **Out is faster than in.** Exit at about 0.65× the entrance duration, with an accelerating curve and no bounce.
3. **The 100× rule.** If someone triggers an interaction 100 times a day, do not animate it. Menu toggles, keyboard focus moves, arrow-key selection, tab switches in a tool: instant.
4. **Opacity never springs; transforms may.** Springs are for objects with mass or for anything a gesture can interrupt. Colour, opacity, and hover use a short curve. Never `transition: all`; name the property.
5. **The spinner travels.** Progress appears where the result will appear, not only on the control that was clicked. No spinner before 300ms. A pending optimistic row is a ghost at 60% opacity, not a spinner. The control may also carry progress once the result has a home of its own: a button that doubles as a progress bar is right when the work also appears where it will land, and wrong when that is the only place it appears.
6. **Every state gets equal care.** Empty, loading, error, success, offline, first-run, overflow, 320px, 200% zoom, reduced motion, dark mode, keyboard-only.
7. **No layout shift, ever.** Reserve every box: images have dimensions, skeletons match final size, loading buttons lock their width, tabular numbers, fonts with `size-adjust`. A box reserved for the tallest state is a hole in every shorter one, so each state must fill it or centre in it; if a state can do neither, it does not belong in the sequence.
8. **A disabled control says why; a destructive action names its noun.** Never disable submit until valid. "Delete project" and "Cancel", never "Are you sure?" with OK.
9. **One accent per view.** The primary action carries the colour on its background, not its label. Blue text reads as a link; blue background reads as the primary.
10. **Everyone can reach it.** Every interactive element is a real `<button>` or `<a>`, has a visible `:focus-visible` ring, a 24px minimum target (44 on touch), and a name a screen reader can say.

## 3. Cheat sheets

Defaults for projects without an established value. The project's own token wins.

### 3.1 Easing and duration

| Job | Curve | Duration |
|---|---|---|
| Hover, colour, opacity | `ease` or `cubic-bezier(0.2, 0, 0, 1)` | 100–150ms |
| Micro state (checkbox, toggle, chip) | `cubic-bezier(0.2, 0, 0, 1)` | 120–180ms |
| Enter (dropdown, tooltip, popover) | `cubic-bezier(0.165, 0.84, 0.44, 1)` (ease-out-quart) | 150–250ms |
| Enter, large surface (modal, sheet, page) | `cubic-bezier(0.16, 1, 0.3, 1)` (ease-out-expo-ish) | 250–400ms |
| Exit, anything | `cubic-bezier(0.4, 0, 1, 1)` | 0.65× the entrance, ≤ 200ms |
| Move on screen (reorder, resize) | `ease-in-out` or a spring | 200–300ms |
| Marquee, hold-to-confirm, progress | `linear` | as long as the thing takes |

Full ease-out ladder, weak to strong: quad `(0.25, 0.46, 0.45, 0.94)` · cubic `(0.215, 0.61, 0.355, 1)` · quart `(0.165, 0.84, 0.44, 1)` · quint `(0.23, 1, 0.32, 1)` · expo `(0.19, 1, 0.22, 1)`. Bigger surface, stronger curve.

`ease-in` on an entering element is almost never right. UI animations stay under 300ms unless they are page-scale.

### 3.2 Springs

Use `visualDuration` + `bounce` (Motion) or a generated CSS `linear()`; never raw stiffness/damping unless modelling something physical.

| Token | Motion | CSS settle | Use |
|---|---|---|---|
| micro | `{ visualDuration: 0.2, bounce: 0.12 }` | ~320ms | press, checkbox, icon swap |
| snappy | `{ visualDuration: 0.3, bounce: 0.18 }` | ~480ms | default: toggles, tab indicators, chips |
| smooth | `{ visualDuration: 0.4, bounce: 0 }` | ~400ms | sheets, modals, panes |
| bouncy | `{ visualDuration: 0.35, bounce: 0.32 }` | ~700ms | likes, badges, one celebration |
| gentle | `{ visualDuration: 0.6, bounce: 0 }` | ~600ms | backdrops, hero reveals |
| exit | `exitOf(token)` = `visualDuration × 0.65, bounce: 0` | | every exit |

CSS `linear()` strings with 100+ points cost nothing at runtime. Generate them at build time from the same tokens (`assets/gen-springs.mjs`) and pair each with its measured settle duration.

**Settle and visual duration are different numbers and the difference is large.** Visual duration is when the motion reads as finished; settle is when it has actually stopped, and a `linear()` needs the settle or it truncates. A spring with a 0.4s visual duration settles around 720ms. The 300ms guidance in the duration table above is about *visual* duration and about curves; it does not condemn a 720ms settle. Never compare the two numbers as if they measured the same thing.

Springs for: drag release, sheet dismiss, reorder, anything retriggerable mid-flight (velocity handoff). Curves for: hover, focus, colour, opacity, tooltips.

### 3.3 Stagger, press, and contextual swaps

- Stagger list items 30–40ms, cap ~8 (240ms). Stagger semantic chunks (title, body, actions) 80–100ms. First appearance only; never on scroll into view.
- Press scale: rows 0.99, surfaces and CTAs 0.97, icon buttons 0.94, floor 0.90. `transition: transform 150ms ease-out`. Never animate from `scale(0)`; start at 0.95.
- Contextual icon swap (copy → check): scale 0.25 → 1, opacity 0 → 1, `blur(4px)` → 0, spring `{ duration: 0.3, bounce: 0 }`. Bounce is always 0 on icon swaps. Hold the check 1.5s.
- Enter: opacity + `translateY(8–12px)` + `blur(4px)`. Exit: `translateY(-8px)` + opacity, 150ms. Blur is optional; skip it on lists longer than 20.

### 3.4 Typography

| Role | Size | Line-height | Weight |
|---|---|---|---|
| Display | 2.25rem / 36px | 1.1 | 600 |
| Title | 1.5rem / 24px | 1.2 | 600 |
| Heading | 1.125rem / 18px | 1.3 | 600 |
| Body | 1rem / 16px | 1.5 | 400 |
| Caption | 0.8125rem / 13px | 1.4 | 400 |

- Emphasis within a role is one weight step (400 → 500), not a size change.
- Measure 60–75 characters: `max-width: 65ch`.
- Anything wrapping to 3+ lines needs line-height ≥ 1.4, even in tight rows. Headings ~1.1. Always unitless.
- Letter-spacing: large headings slightly negative (−0.02em); small uppercase labels positive (+0.05em); body untouched.
- `text-wrap: balance` on headings (silently ignored past 6 lines), `pretty` on paragraphs and cards, neither on long-form.
- Weights under 400 are display-only at 28px+. Nothing under 18px goes below 400.
- Floors: body 16px, UI 14px, captions 13px, rarely 12px. Inputs ≥ 16px on mobile or iOS zooms. Never `maximum-scale=1`.
- `font-variant-numeric: tabular-nums` on every number that changes; not on static display numbers, phone numbers, or version strings.
- `-webkit-font-smoothing: antialiased` once on the root. `.woff2` only. Prefer `font-weight: 650` over `font-variation-settings`.

### 3.5 Layout and spacing

- **4px grid, 8px rhythm.** 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64.
- **Container padding 16px on mobile, 24px from tablet up.** Same on every page.
- **Grouping by space, not lines.** Gap between groups ≥ 2× the gap within (8 inside, 16+ between). Separators last, for dense data, never combined with a large gap.
- **Controls**: 12px between adjacent filled controls; 24px clearance around borderless icon buttons; 24px+ between unrelated groups.
- **Peek**: the next item in a horizontal scroller shows 16–32px past the edge, or nobody scrolls it.
- **Radii**: at most three *authored* values. Nested radii are then derived, not authored: inner = outer − padding. A project with one rule and twelve derived values has a radius system; a project with twelve unrelated literals does not. Above 24px of padding, treat the layers as separate surfaces and start again from the outer value.
- **Full-bleed grid**: `grid-template-columns: 1fr min(65ch, calc(100% - 48px)) 1fr`.
- **Safe areas are added to padding**: `padding-bottom: calc(16px + env(safe-area-inset-bottom))`. Requires `viewport-fit=cover`.
- **Breakpoints from content, not devices.** Prefer container queries. Test 320px and the largest first.
- **Logical properties** (`padding-inline`, `inset-inline-start`) by default.
- **Clipping**: a modal's action row never scrolls with its content. Nothing critical sits under the keyboard or below the fold of a fixed-height pane.

### 3.6 Surfaces

- **Shadow as border (light)**: `0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04)`; hover raises to `.08 / .08 / .06`.
- **Dark mode** collapses to a single ring: `0 0 0 1px oklch(1 0 0 / 0.08)`, hover `0.13`. Shadows do not read on dark.
- **Image outline** (non-negotiable on user content): `outline: 1px solid oklch(0 0 0 / 0.1)` light, `oklch(1 0 0 / 0.1)` dark, `outline-offset: -1px`. Never a tinted grey; it reads as dirt.
- **Hairline**: `--hairline: 1px`, `0.5px` at `min-resolution: 2dppx`.
- **Elevation ladder** by named surface (`--surface`, `--raised`, `--overlay`) beats ad-hoc shadows.
- **Backdrop blur**: needs `saturate(180%)` or it is grey mush; 2–3 per screen, static chrome only, never on a scrolling or animating element.
- **z-index scale**: `--z-dropdown: 100; --z-sticky: 150; --z-overlay: 200; --z-popover: 300; --z-toast: 400`. Never 9999. Prefer `isolation: isolate` on components.

### 3.7 Buttons and controls

- Six states: rest, hover (≤ 150ms colour change; no lift unless the element is a link to somewhere), active (press scale), focus-visible (ring), loading (width locked, label swaps for a spinner in the same box), disabled (muted token, not opacity; paired with a reason).
- Tap targets: **24px is the floor that binds** (WCAG 2.5.8), with its spacing exception: a 24px circle centred on the target must not intersect another. 44px on touch and 40px with a pointer are consumer-app defaults, not standards. A dense professional tool with a documented row height is entitled to sit between 24 and 40; a consumer app is not. Expand with a pseudo-element on the `<button>` or `<label>`, never on an `<input>`.
- `touch-action: manipulation` on every control; set `-webkit-tap-highlight-color` to match the design.
- Tooltips: 200ms open delay, then a "warm" state where siblings open instantly for 300ms.
- Copy-to-clipboard shows a check for 1.5s. Search debounces 300ms. A "Done → Cancel · Save" footer reserves its final width and cross-fades labels in 150ms.

### 3.8 Overlays

| Overlay | Enter | Exit | Focus | Dismiss |
|---|---|---|---|---|
| Modal | 200–300ms, backdrop and panel on the same curve | 0.65×, same curve pair | `<dialog>` + `showModal()`, focus least-destructive action | Escape, backdrop click, Close |
| Sheet / drawer | spring `smooth`; contents at +80ms, stagger 30ms | spring `exitOf(smooth)` | first field after the animation completes (~350ms) | drag > 50% or > 500px/s; upward flick cancels |
| Popover / menu | 150–200ms from its trigger origin | 100–150ms | roving tabindex; Escape returns to trigger | Escape, outside click |
| Tooltip | 150ms after 200ms delay | instant | never focusable | pointer leave, Escape |
| Toast | 200ms | 150ms | never steals focus | 5s floor, pause on hover, persist if it carries an action or error |

- Paired elements (modal + backdrop, tooltip + arrow) share identical easing and duration.
- `inert` on the background while a modal is open. Return focus to the trigger on close. `overscroll-behavior: contain` inside.
- Escape closes whatever opened last: tooltip → menu → dialog.
- Submenus get a diagonal safe area (`clip-path` triangle) so the cursor can travel.

### 3.9 Colour

- **Work in OKLCH.** `oklch(L C H / alpha)`, three decimals. Baseline 2023.
- **Contrast**: APCA |Lc| ≥ 75 body (90 preferred), ≥ 60 non-body, ≥ 45 large, ≥ 30 UI. WCAG 4.5:1 normal, 3:1 large and UI. A mid-lightness background (L 0.75) caps contrast at ~Lc 60 no matter the text.
- **Fix contrast by adjusting L first**, preserving C and H.
- **Multi-hue palettes share L and chroma percentage**, not absolute chroma; cyan peaks at C≈0.09 where purple reaches 0.29.
- **Dark mode is not a mirror.** Re-check every pair. Muted text is one ink stepped in alpha (1 / 0.62 / 0.45 / 0.28) so one base flips and the hierarchy follows.
- **Theme switch**: add a `.no-transitions` class, flip the theme, remove after two `requestAnimationFrame`s with a 120ms `setTimeout` backstop (rAF does not fire in background tabs). "System" is the absence of a stored key.
- **One colour, one meaning.** Same hue within ±15° on something non-interactive tells users to click.
- **P3**: sRGB value first, then `@supports (color: oklch(0 0 0))` inside `@media (color-gamut: p3)`.
- Test every colour on a translucent surface over the lightest and darkest content that can scroll behind it.

### 3.10 States and loading

| Elapsed | Show |
|---|---|
| 0–300ms | Nothing. Optimistic result if possible |
| 300ms–2s | Skeleton with exact final dimensions, or inline progress where the result will land |
| 2s+ | Explicit progress with a label and cancel |
| 10s+ | Notify on completion; let the user leave |

- Skeletons structurally match the content. Shimmer 1.2–1.5s, subtle.
- Optimistic first; pending = 60% opacity ghost; revert with an inline reason on failure.
- Empty state = name + one line of why + one action. Search empties name the query and offer an exit: "No results for 'quarterly'. Clear filters."
- Errors sit next to the field, on the label row, not in a toast. "Unable to save. Check your connection and try again."
- Undo must actually reverse the effect.

### 3.11 Performance as a design property

- INP < 200ms, ideally < 100ms. Any click must produce visible change within 100ms.
- 120Hz displays give 8.3ms per frame, not 16.
- Frame killers, ranked: `backdrop-filter` on a moving element; animating layout properties; large blurred `box-shadow` on an animated element (animate opacity of a pseudo-element holding the shadow instead); React re-renders during a gesture (`useMotionValue`, never `setState` in `onDrag`); unbounded lists.
- `will-change` only for `transform`, `opacity`, `filter`, only after observing a first-frame stutter. Never `all`.
- `content-visibility: auto; contain-intrinsic-size: auto 72px` gets most of virtualisation's win in one line. Virtualise past ~100 rows.
- Prefetch on `pointerdown`, not `click`: 100–150ms for free. `fetchpriority="high"` on the LCP image.
- Never animate blur above 20px.

## 4. Topics

Each topic below is the 30-second version. The reference has the full rules, numbers, code, and checks.

### Motion and transitions → the motion reference below

Name every property you transition. Build a motion vocabulary of 5–8 named tokens, each with a job, and the rule "if a new animation does not fit one of these, don't". Write the storyboard as a comment above the tokens. Frequency decides motion: rare gets theatre, daily gets instant. Exits accelerate. Loops act, rest, then ease home; never snap. Skip entrance animation on page load for above-the-fold chrome. Replay at 10% speed in the Animations panel before shipping.

### Springs, gestures and scroll → the springs-and-gestures reference below

Velocity beats position: dismiss on > 500px/s regardless of distance; upward flick always cancels. Rubber-band with Apple's constant 0.55. Animate from the current value, never the target; blend velocity on reversal. `layout` animations: wrap text in `layout="position"`, put `layoutScroll` on scroll containers, and keep border-radius inline. Scroll snap paging needs `scroll-snap-stop: always`. Do not build a custom scroller.

### Colour, dark mode and theming → the color reference below and the theming-and-dark-mode reference below

OKLCH palette algorithm with per-step chroma clamping. Semantic tokens over base tokens; lint-ban base tokens outside the token file. One accent per view. Increased contrast variant widens the L gap by ≥ 0.15. Per-locale gain/loss colours.

### Typography → the typography reference below

Role-based scale, one weight step for emphasis, measure 60–75ch, `text-wrap` by length, `text-box: trim-both cap alphabetic` for badges and buttons where supported, underlines from the font, smart punctuation, `<bdi>` for mixed-direction values, `font-synthesis` only after verifying every face. Variable-font axes: map named weights to the real axis range in exactly one place.

### Layout, spacing and hierarchy → the layout-and-spacing reference below

The eye lands on the headline, then the primary action, within a second. One primary per view. Group by space. Controls distinct from content. Hint at hidden content with a peek. Hold structure until it breaks; collapse late. Design for two items and for two hundred. Plan for i18n: no fixed widths sized to English, `min-height` not `height`.

### Surfaces and depth → the surfaces-and-depth reference below

Shadow-as-border recipes, hairlines, image outlines, concentric radii, the backdrop-filter budget, and the rule that bigger surfaces read as thicker (stronger blur, deeper shadow). Never stack two translucent surfaces.

### Buttons and controls → the buttons-and-controls reference below

Six states with exact values. Width-locked loading. The Done → Cancel · Save state machine. Tooltip warmth. Optical alignment: the icon-side padding is 2px less than the text-side; a play triangle nudges `translateX(2px)`.

### Forms and inputs → the forms-and-inputs reference below

Inputs ≥ 16px on mobile, `-webkit-appearance: none`, never disable submit until valid, validate on submit then `aria-invalid` + `aria-describedby` + focus the first invalid field, `autocomplete` tokens are a WCAG requirement, `inputmode` for OTP and money, never block paste, trim before validating, placeholders are examples not labels, focus after a sheet finishes animating, handle the virtual keyboard inset.

### Overlays → the overlays reference below

Modal, sheet, drawer, popover, tooltip, toast: enter, exit, focus, dismissal, and the paired-element rule. Sheet choreography with the 80ms content offset. Toast floor 5s with pause on hover. Prefer inline state over toasts for anything contextual.

### Haptics and sound on the web → the haptics-and-sound reference below

`navigator.vibrate` on `pointerdown` only (light 8ms, medium 15, heavy 25, error `[10, 40, 10]`); never on scroll, hover, load, or appearance. iOS Safari has no vibration API; a switch-input trick exists and is fragile. Sound is almost always wrong on the web: it ignores the ringer switch. Exceptions are opted-in tools (metronome, timer, game).

### Icons → the icons reference below

Stroke matches text weight: 1.5px beside 400, 2px beside 500–600, 2.5px beside 700. `currentColor` only, one asset per icon, outline default and fill active, sized 1em–1.25em inline, native 16/20/24 grids. RTL flip table. Lucide's default stroke 2 is heavy next to most body text; use 1.5–1.75 with `absoluteStrokeWidth`.

### Copy and naming → the copy-and-naming reference below

Verb-first buttons that name the noun. Sentence case by default. "Continue" or "Next", pick one. Links describe the destination, never "Click here". Toggles label the ON state. Errors are calm, plain, and say what to do. Device verbs: tap on touch, click with a pointer, select when both. Never concatenate strings around variables. Defaults: no emoji in interface chrome, no em-dashes in UI copy; house style may override both in the design contract.

### States → the states reference below

The loading ladder, skeleton rules, optimistic ghosts, empty-state anatomy, error placement, and the feedback taxonomy: minor reversible → toast with Undo; contextual → inline at the thing; the app acted for you → a receipt; destructive → confirm with the noun.

### Onboarding and pricing → the onboarding-and-pricing reference below

Value in three seconds. Four or five steps, one purpose each. Progress as dots, not a bar. CTA never moves. Intro animations gated by `sessionStorage`. Pricing: state the price plainly, show total and per-month, one paid tier, no fake anchors, no countdowns, Close visible from frame one, restore and terms always present. The honesty test: would this still work if the person understood it completely?

### Touch and mobile web → the touch-and-mobile reference below

The base layer: `-webkit-tap-highlight-color: transparent`, `text-size-adjust: 100%`, `touch-action: manipulation`, `user-select: none` on chrome and `text` on content, `dvh` for fill and `svh` for fixed chrome, `viewport-fit=cover`, `overscroll-behavior: none` only in standalone mode. The anti-advice table: no `user-scalable=no`, no `position: fixed` on body to lock scroll, no JS smooth-scroll libraries, no `100vh` + resize listener.

### Scroll → the scroll reference below

Momentum is the platform's; do not fake it. Snap with `scroll-snap-stop: always` for paging. Scrollbars only inside panels, never restyled on the page. `scroll-margin-top` on every anchored id. Sticky headers shrink with `animation-timeline: scroll()`. Scroll edge effects, not hard dividers, where content meets floating chrome.

### Performance → the performance reference below

Budgets, the frame-killer ranking, `content-visibility`, prefetch on pointerdown, virtualisation thresholds, the theme-switch suppressor, and `visibilitychange` timer freezes.

### Canvas and generated media → the canvas-and-media reference below

When the product is the pixels, most of this skill's tooling stops working: the accessibility tree is empty, CSS reaches nothing, and the render loop is the real performance budget. Name the canvas with `role="img"` and a live label, put meaning in `aria-valuetext` rather than a raw number, and give every canvas-only action a real DOM control. Ask for `{ colorSpace: "display-p3" }` or wide-gamut values clamp silently, and remember an invalid `fillStyle` is a no-op that keeps the previous colour. Back the store at `devicePixelRatio`, stop the loop off screen and when hidden, restart from now, and check reduced motion in JS because CSS cannot reach a loop. One renderer for preview and export: if changing the export resolution does not change the pixel dimensions of the file, the export path is a lie.

### Accessibility as polish → the accessibility reference below

`:focus-visible` only; keep the browser ring plus `outline-offset: 2px` or verify a custom ring against every adjacent colour. Roving tabindex for composite widgets. `.sr-only` at 1px, not 0. Announcement ladder: focus move → `aria-describedby` → `role="status"` → `role="alert"`. Reduced motion is opt-in (`no-preference`), the global kill switch uses `0.01ms` not `none` so `transitionend` still fires. Zoom to 200% and reflow at 320px. `rem` for type and breakpoints, `px` for hairlines and rings. Alt by purpose. SPA route change moves focus to the new `<h1>`.

### Marketing pages → the marketing-pages reference below

No scroll-triggered fade-ups on every section; no scroll hijacking; no non-1:1 parallax; no auto-advancing carousels. One orchestrated moment beats scattered effects. Spend boldness in one place. OG images survive at 200px wide: headline ≥ 80px at 1200 wide, 3–8 words, one focal point, tested in greyscale.

### Native feel (opt-in) → the native-feel reference below

The iOS-on-web layer: 17px body, negative tracking by size, materials, sheet physics, edge-swipe back. A style choice, clearly labelled. Load only when the project wants to feel like a native app.

## 5. Anti-patterns and AI tells

Reject on sight. Each reads as "made by nobody in particular".

- `transition: all`; `will-change` on everything; `z-index: 9999`
- Fade-and-slide-up entrance on every section as it scrolls into view; hover lift on every card
- One border-radius on everything regardless of hierarchy; the same `rgba(0,0,0,.1)` shadow under every card
- Cream background near `#F4F1EA` with a high-contrast serif and a terracotta accent near `#D97757`; near-black plus one acid accent; broadsheet hairlines with zero radius; the identical-rounded-card kit
- Tracked-out ALL-CAPS eyebrow above every heading; meta strings joined with middle dots; headlines shaped as WORD, a spaced em dash, then a fragment; `→` appended to link text; a mono face for every small label; tinted near-black (`#0B0B0B`, `#111`) posing as black
- A single word in a headline italicised or coloured for effect
- Numbered markers (01 / 02 / 03) on content that is not a sequence
- Submit disabled until the form is valid; `autocomplete="off"` on identity or payment fields; paste blocked on any field
- Toast for a field error; toast that vanishes with the only Undo
- Spinner on the clicked button; spinner before 300ms; skeleton that does not match the content
- `100vh` layouts; `maximum-scale=1`; `position: fixed` on body to lock scroll; `-webkit-overflow-scrolling: touch` for momentum (default since iOS 13)
- `backdrop-filter` without `saturate`; `backdrop-filter` on a scrolling element
- Opacity-based disabled states that fail contrast at random
- Blue text that is not a link; a hue within 15° of the accent on a non-interactive element
- Fonts introduced by the polish pass (Inter or otherwise) that the project did not already use
- Emoji bullets in marketing copy; corporate openers ("We're thrilled to announce")
- Spring on opacity; bounce on an icon swap; stagger beyond 8 items
- Reduced motion handled by `animation: none` (breaks `animationend` listeners) or not handled at all

## 6. The 6 → 11 checklist

Each item is checkable in under a minute. Full mode runs the whole list; quick mode runs the starred items.

### Accessibility and states
- [ ] ★ Keyboard-only pass: every control reachable, focus visible at every stop, Escape closes what opened last
- [ ] ★ Every interactive element is a `<button>` or `<a>` with an accessible name
- [ ] ★ Empty, loading, error, success each exist for every list, form, and fetch
- [ ] Offline state exists; cached content stays usable
- [ ] 320px width reflows with vertical scroll only; 200% zoom holds
- [ ] Reduced motion swaps vestibular motion for crossfades; functional feedback remains
- [ ] Screen reader announces route changes, live updates, and errors via the ladder
- [ ] Overflow: 200 rows, a 60-character title, German labels all hold

### Layout and hierarchy
- [ ] ★ Eye lands on headline then primary action within a second
- [ ] ★ One primary action per view
- [ ] ★ Same container padding on every page
- [ ] Spacing from the grid; group gaps ≥ 2× inner gaps
- [ ] Controls 12px apart; borderless controls with 24px clearance
- [ ] At most three radii; nested = outer − padding
- [ ] Horizontal scrollers peek 16–32px
- [ ] Nothing critical under the keyboard or below a fixed pane's fold
- [ ] Safe areas added to padding; `viewport-fit=cover` set

### Copy and naming
- [ ] ★ Buttons verb-first, naming the noun
- [ ] ★ Errors say what happened and what to do; no apology, no "Oops"
- [ ] One capitalisation policy per element type
- [ ] An action keeps its name across the flow
- [ ] Links describe their destination
- [ ] Toggles label the ON state
- [ ] Empty states name the thing and offer one action
- [ ] Emoji and dash policy matches the design contract

### Typography
- [ ] ★ Roles carry hierarchy; emphasis is one weight step
- [ ] ★ Inputs ≥ 16px on mobile; no `maximum-scale`
- [ ] Measure ≤ 75ch; 3+ line text has line-height ≥ 1.4
- [ ] `text-wrap: balance` on headings, `pretty` on cards, neither on long-form
- [ ] Changing numbers are tabular
- [ ] No weight under 400 below 28px
- [ ] Font smoothing set once on the root; `.woff2` only
- [ ] Underlines from the font; only colour animates

### Colour and surfaces
- [ ] ★ APCA ≥ 75 body, ≥ 60 secondary, ≥ 30 UI (or WCAG 4.5 / 3)
- [ ] ★ Every colour pair re-checked in dark mode
- [ ] One accent per view; colour on the primary's background
- [ ] Muted text is one ink stepped in alpha
- [ ] Shadow-as-border in light; single ring in dark
- [ ] Images outlined at 10% black/white inset
- [ ] Backdrop blur has `saturate`, ≤ 3 per screen, static only
- [ ] Theme switch suppresses transitions for one frame with a backstop
- [ ] Meaning never carried by colour alone

### Motion
- [ ] ★ No `transition: all`; every transition names its property
- [ ] ★ Exits shorter than entrances, accelerating, no bounce
- [ ] ★ Paired elements share easing and duration
- [ ] Opacity and colour never spring
- [ ] Stagger 30–40ms, first appearance only, ≤ 8 items
- [ ] Press scale within the ladder; nothing below 0.9
- [ ] No entrance animation on above-the-fold chrome at page load
- [ ] Animations replayed at 10% speed and look right
- [ ] Gesture-driven motion starts from the current value and inherits velocity

### Controls, forms, overlays
- [ ] ★ Targets ≥ 44px touch / 40px pointer / 24px floor, expanded on the button not the input
- [ ] ★ Submit never disabled until valid; first invalid field focused on submit
- [ ] ★ Loading buttons lock their width; disabled has a reason
- [ ] `autocomplete` and `inputmode` set on every identity, payment, and OTP field
- [ ] Modals use `<dialog>` or `inert`; focus returns to the trigger
- [ ] Sheets dismiss on velocity; contents arrive 80ms after the container
- [ ] Tooltips delay 200ms and warm; toasts persist when they carry an action
- [ ] Copy-to-clipboard holds a check 1.5s; search debounces 300ms
- [ ] Hover changes only colour unless the element navigates

### Performance as felt
- [ ] ★ No layout shift on load, on font swap, on data arrival, on button loading
- [ ] ★ INP < 200ms on the primary path
- [ ] No `backdrop-filter` or big blurred shadow on anything that moves
- [ ] Lists past ~100 rows virtualised or `content-visibility: auto`
- [ ] Prefetch on `pointerdown`; LCP image `fetchpriority="high"`
- [ ] No `setState` inside a drag handler

### Onboarding, pricing, marketing (when present)
- [ ] Onboarding ≤ 5 steps; dots not bars; CTA pinned
- [ ] Pricing plain: total and per-month, one paid tier, Close from frame one, no countdowns
- [ ] Marketing: no scroll-triggered fades, no hijack, no autoplay carousel, one orchestrated moment
- [ ] OG image tested at 200px wide and in greyscale

## 7. Decisions register

Where sources disagree, this skill takes these positions. Change them only in the project's design contract.

| Topic | Decision |
|---|---|
| Grid | 4px base, 8px rhythm, 16/24 container padding |
| Exit curve | `cubic-bezier(0.4, 0, 1, 1)` at ~0.65× entrance, no bounce; entrances never ease-in |
| Springs | `visualDuration` + `bounce`; CSS `linear()` generated from the same tokens |
| Springs vs curves | Springs for gesture-driven, interruptible, or weighted; curves for hover, colour, opacity; opacity never springs |
| Press scale | Rows 0.99 · surfaces 0.97 · icon buttons 0.94 · floor 0.90 |
| Stagger | Items 30–40ms cap ~8; semantic chunks 80–100ms; first appearance only |
| Dark mode black | Near-black carrying the palette's hue; true black only as a written decision |
| Hit area | 44px touch · 40px pointer · 24px WCAG floor with spacing exception |
| Reduced motion | Replace vestibular motion with crossfade; keep functional feedback; kill switch `0.01ms`, never `none` |
| Body size | Project's value; 16px default; 17px only under `native-feel.md` |
| Autocomplete | Never disabled on identity, payment, or OTP fields |
| Toasts | 5s floor, pause on hover, persist with actions or errors; inline beats toast for anything contextual |
| Icons | Two states (outline, fill), not three |
| Emoji / em-dash | Defaults: none in chrome, none in UI copy; house style may override in the design contract |
| Blur | Static backdrop blur up to 50px is fine; never animate blur above 20px |
| Shadow recipe | 3-layer shadow-as-border in light; single 8% white ring in dark |

## 8. Further reading inside this skill

- the anti-patterns reference below for the long-form tells with the fix for each
- the audit-checklist reference below for the printable checklist with the "how to check" column
- the design-contract-template reference below for the 15-line contract and a filled example
- `assets/` for drop-ins: `motion.css`, `gen-springs.mjs`, `motion.ts`, `base.css`, `theme-switch.ts`, `utilities.css`, `skeleton.css`, `shadows.css`

---

# References

Claude Code loads these on demand. In this build they are inlined in full.

<!-- references/audit-checklist.md -->

## Audit checklist (printable)

The full checklist from SKILL.md §6 with a "how to verify" column. ★ items are the quick-mode set. Severity is what to file if the check fails; downgrade only with a written reason.

### The one-hour audit

1. Intake table (10 min): tokens, radii, spacing, motion, overlays, states. See SKILL.md §1.1.
2. Keyboard-only pass of the primary path (10 min).
3. DevTools: 320px, then 200% zoom at 1280 (5 min).
4. Emulate `prefers-reduced-motion` and dark mode; repeat the primary path (5 min).
5. Throttle to fast 3G; watch every loading state (5 min).
6. Animations panel at 10% speed for one overlay pair and one list entrance (5 min).
7. The greps at the bottom of this file (5 min).
8. Copy pass: every button, every error, every empty state (5 min).
9. Group findings by root cause; write the "what this changes" column (5 min).
10. Verdict.

### Accessibility and states

| Check | How to verify | Severity |
|---|---|---|
| ★ Keyboard-only pass: every control reachable, focus visible, Escape closes what opened last | Unplug the mouse; Tab through the path; open a menu inside a dialog and press Escape | HIGH |
| ★ Every interactive element is a `<button>` or `<a>` with a name | Accessibility tree in DevTools; `grep -rn "onClick" \| grep -v "<button\|<a "` | HIGH |
| ★ Empty, loading, error, success exist for every list, form, fetch | Mock each response; screenshot each | HIGH |
| Offline state exists; cached content stays usable | DevTools Network: Offline | MEDIUM |
| 320px reflows with vertical scroll only; 200% zoom holds | Responsive mode at 320; browser zoom 200% at 1280 | HIGH |
| Reduced motion swaps vestibular motion for crossfades | Rendering panel: emulate `prefers-reduced-motion`; every action still responds | MEDIUM |
| Screen reader announces route changes, live updates, errors | VoiceOver (Cmd+F5) on Safari; navigate; submit an invalid form | HIGH |
| Overflow: 200 rows, 60-char title, German labels hold | Seed data; switch locale | MEDIUM |

### Layout and hierarchy

| Check | How to verify | Severity |
|---|---|---|
| ★ Eye lands on headline then primary action within a second | Squint test on a screenshot; ask a colleague what to click | MEDIUM |
| ★ One primary action per view | Count filled buttons per screen | MEDIUM |
| ★ Same container padding on every page | `grep -rn "max-w-\|container"`; compare computed padding on three pages | MEDIUM |
| Spacing from the grid; group gaps ≥ 2× inner gaps | Inspect gaps; values ∈ {4, 8, 12, 16, 20, 24, 32, 40, 48, 64} | LOW |
| Controls 12px apart; borderless controls with 24px clearance | Measure in DevTools | LOW |
| At most three radii; nested = outer − padding | `grep -rno "rounded-[a-z0-9]*\|border-radius:[^;]*" \| sort \| uniq -c` | MEDIUM |
| Horizontal scrollers peek 16–32px | Resize; the next card is partly visible | LOW |
| Nothing critical under the keyboard or below a fixed pane's fold | Open each modal at 375×667 with the keyboard up | HIGH |
| Safe areas added to padding; `viewport-fit=cover` set | View source; test on a phone with a home indicator | MEDIUM |

### Copy and naming

| Check | How to verify | Severity |
|---|---|---|
| ★ Buttons verb-first, naming the noun | List every button label | MEDIUM |
| ★ Errors say what happened and what to do; no "Oops" | `grep -rni "oops\|something went wrong\|having trouble"` | MEDIUM |
| One capitalisation policy per element type | Sample ten labels | LOW |
| An action keeps its name across the flow | Trace "Publish" to "Published" | LOW |
| Links describe their destination | `grep -rni ">click here<\|>learn more<"` | MEDIUM |
| Toggles label the ON state | Read every switch label | LOW |
| Empty states name the thing and offer one action | Screenshot each | MEDIUM |
| Emoji and dash policy matches the design contract | Grep for emoji ranges and the em dash character | LOW |

### Typography

| Check | How to verify | Severity |
|---|---|---|
| ★ Roles carry hierarchy; emphasis is one weight step | Inspect computed sizes on a busy screen; count distinct sizes | MEDIUM |
| ★ Inputs ≥ 16px on mobile; no `maximum-scale` | Focus an input on an iPhone; read the viewport meta | HIGH |
| Measure ≤ 75ch; 3+ line text has line-height ≥ 1.4 | Measure the widest paragraph; inspect `line-height` on wrapped rows | MEDIUM |
| `text-wrap: balance` on headings, `pretty` on cards | `grep -rn "text-wrap\|text-balance\|text-pretty"` | LOW |
| Changing numbers are tabular | Watch a counter tick; `grep -rn "tabular-nums"` | MEDIUM |
| No weight under 400 below 28px | `grep -rn "font-light\|font-thin\|font-weight: [123]00"` | LOW |
| Font smoothing set once; `.woff2` only | `grep -rn "font-smoothing"`; list font files | LOW |
| Underlines from the font; only colour animates | Inspect link `text-decoration` | LOW |

### Colour and surfaces

| Check | How to verify | Severity |
|---|---|---|
| ★ APCA ≥ 75 body, ≥ 60 secondary, ≥ 30 UI (or WCAG 4.5 / 3) | Contrast checker on ink, muted, and disabled tokens, both modes | HIGH |
| ★ Every colour pair re-checked in dark mode | Toggle `data-theme`; screenshot the same screen twice | MEDIUM |
| One accent per view; colour on the primary's background | Count accent uses per screen | MEDIUM |
| Muted text is one ink stepped in alpha | Inspect the token file | LOW |
| Shadow-as-border in light; single ring in dark | Inspect a card's `box-shadow` in both modes | LOW |
| Images outlined at 10% black/white inset | Inspect an avatar over a white card | LOW |
| Backdrop blur has `saturate`, ≤ 3 per screen, static | `grep -rn "backdrop-filter" \| grep -v saturate`; count per screen | MEDIUM |
| Theme switch suppresses transitions for one frame with a backstop | Toggle theme; watch for a ripple of mismatched fades | LOW |
| Meaning never carried by colour alone | Greyscale screenshot | HIGH |

### Motion

| Check | How to verify | Severity |
|---|---|---|
| ★ No `transition: all`; every transition names its property | `grep -rn "transition: all\|transition-all"` | MEDIUM |
| ★ Exits shorter than entrances, accelerating, no bounce | Compare `exit` and `animate` in each component; Animations panel | MEDIUM |
| ★ Paired elements share easing and duration | Animations panel at 10%: modal and backdrop start and end together | MEDIUM |
| Opacity and colour never spring | Search spring configs for `opacity` | LOW |
| Stagger 30–40ms, first appearance only, ≤ 8 items | Inspect `staggerChildren`; scroll a list twice | LOW |
| Press scale within the ladder; nothing below 0.9 | `grep -rn "scale(0\.[0-8]\|scale-9[0-4]"` | LOW |
| No entrance animation on above-the-fold chrome at load | Reload; nav and header do not animate | LOW |
| Animations replayed at 10% speed look right | Animations panel, 10% | LOW |
| Gesture-driven motion starts from the current value with velocity | Interrupt a sheet mid-open; no jump | MEDIUM |

### Controls, forms, overlays

| Check | How to verify | Severity |
|---|---|---|
| ★ Targets ≥ 44px touch / 40 pointer / 24 floor, expanded on the button | DevTools box on each small control | HIGH |
| ★ Submit never disabled until valid; first invalid field focused | Submit empty; watch focus | HIGH |
| ★ Loading buttons lock width; disabled has a reason | Click; measure width before and during; hover a disabled control | MEDIUM |
| `autocomplete` and `inputmode` on identity, payment, OTP fields | `grep -rn 'autocomplete="off"'`; inspect each field | HIGH |
| Modals use `<dialog>` or `inert`; focus returns to trigger | Open, Tab past the end, close | HIGH |
| Sheets dismiss on velocity; contents arrive 80ms after the container | Flick from 10%; Animations panel | MEDIUM |
| Tooltips delay 200ms and warm; toasts persist with actions | Hover two tooltips in a row; trigger a toast with Undo and wait | MEDIUM |
| Copy holds a check 1.5s; search debounces 300ms | Click copy; type in search with Network open | LOW |
| Hover changes only colour unless the element navigates | Hover every card and row | LOW |

### Performance as felt

| Check | How to verify | Severity |
|---|---|---|
| ★ No layout shift on load, font swap, data arrival, button loading | Lighthouse CLS = 0; Performance panel Layout Shift track | HIGH |
| ★ INP < 200ms on the primary path | Web Vitals extension or Performance panel Interactions | HIGH |
| No `backdrop-filter` or big blurred shadow on anything that moves | Performance panel while scrolling | MEDIUM |
| Lists past ~100 rows virtualised or `content-visibility: auto` | Seed 500 rows; scroll | MEDIUM |
| Prefetch on `pointerdown`; LCP image `fetchpriority="high"` | Network panel on hover-then-click; view source | LOW |
| No `setState` inside a drag handler | Read `onDrag` bodies | MEDIUM |

### Onboarding, pricing, marketing (when present)

| Check | How to verify | Severity |
|---|---|---|
| Onboarding ≤ 5 steps; dots not bars; CTA pinned | Count; overlay consecutive screenshots | MEDIUM |
| Pricing plain: total and per-month, one paid tier, Close from frame one | Screenshot at t=0; read the numbers | HIGH |
| Marketing: no scroll fades, no hijack, no autoplay carousel | Scroll with Animations panel open | MEDIUM |
| OG image survives 200px and greyscale | Resize and desaturate the file | LOW |

### The greps

```
grep -rn "transition: all\|transition-all"
grep -rn "will-change"
grep -rn "100vh"
grep -rn "maximum-scale\|user-scalable"
grep -rn 'autocomplete="off"'
grep -rn "z-index: *9\{3,\}\|z-\[9"
grep -rn "backdrop-filter" | grep -v saturate
grep -rn "whileInView\|data-aos"
grep -rni "oops\|something went wrong\|are you sure"
grep -rn "prefers-reduced-motion"
grep -rn 'tabindex="[1-9]'
grep -rn "<img" | grep -v "alt="
```

### Before you ship

1. Keyboard-only pass, ring visible everywhere.
2. 320px and 200% zoom hold.
3. Dark mode screenshot of every screen.
4. Reduced motion emulated; app still responds.
5. Fast 3G: nothing spins before 300ms; skeletons match.
6. CLS 0; INP under 200ms.
7. Every button verb-first; every error says what to do.
8. One accent per view; contrast measured.
9. No `transition: all`; exits shorter than entrances.
10. Every target ≥ 44px on touch.
11. The greps above return nothing unjustified.
12. The design contract is committed and nothing in the diff contradicts it.

<!-- references/design-contract-template.md -->

## Design contract template (web)

Use this when the project has no written design system, or when the intake table has empty rows. Fill it in with the project owner, commit it as `DESIGN.md` (or a section of `AGENTS.md`), and polish inside it. Fifteen lines is the target. If it needs more, the project has more than one style.

### Why a contract before polish

Polish applied without a contract produces a second style that competes with the first. Every later contributor (human or agent) will guess again. Fifteen lines stop the guessing.

### The template

```
## Design contract

1. Purpose: <one sentence: who this is for and the feeling it should leave>
2. Type: <faces by role; e.g. "System stack only" or "Brand Sans for everything, weight 400 to 600">. Roles: display <36/1.1/600>, title <24/1.2/600>, heading <18/1.3/600>, body <16/1.5/400>, caption <13/1.4/400>. Measure <65ch>.
3. Colour: <canvas light/dark, ink light/dark, ONE accent and what it means>. Tokens in OKLCH. Muted = ink at <0.62 / 0.45 / 0.28>. Semantic tokens only in components.
4. Dark mode: <mechanism: data-theme attribute flipping CSS variables>. Not a mirror: every pair re-checked. True black: <no>.
5. Grid: 4px. Container padding <16 mobile / 24 up>. Section rhythm <48 / 64>.
6. Radii: <e.g. 6 / 10 / 16>. Nested = outer minus padding. Pills <999px> for <chips only / buttons too>.
7. Depth: <"hairline box-shadow ring at ink 8%, no drop shadows" or "3-layer shadow-as-border light, single white ring dark">. Images outlined at 10%.
8. Motion: tokens in <motion.css / motion.ts>: micro <120ms ease>, enter <220ms quart-out>, exit <150ms accelerate>, spring <snappy 0.3/0.18> for gestures only. Named properties only. Stagger <40ms>, first appearance only. Reduced motion = crossfade.
9. Hover: <colour change only / colour plus 1px lift on links to pages>. Press: <0.97>. Focus: <browser ring + 2px offset / custom ring colour>.
10. Overlays: <library>. z-scale <100/200/300/400>. Sheets dismiss on velocity. Toasts <only for reversible global outcomes / never>.
11. Forms: inputs <40px / 44px> tall, ≥16px text, errors on the label row, submit always enabled, autocomplete set.
12. Icons: <family, stroke 1.5 at 20px> beside body; fill = active. Never a second family.
13. Copy: sentence case. Verb-first buttons naming the noun. Emoji in chrome: <no>. Em-dashes: <no>. Voice: <two adjectives>.
14. States: every list and fetch has empty, loading, error. Skeletons match structure. Nothing spins before 300ms.
15. Not allowed: <three things this project will never do, e.g. "scroll-triggered fade-ups, hover lift on cards, ALL-CAPS eyebrows">.
```

### A filled example (a fictional reading app, to show the density expected)

```
## Design contract

1. Purpose: a calm place to read saved articles. It should feel like paper, not a feed.
2. Type: system stack only (-apple-system, system-ui). Roles: display 32/1.15/600, title 22/1.25/600, heading 17/1.3/600, body 17/1.55/400 (reading), caption 13/1.4/400. Measure 68ch.
3. Colour: canvas #FFFFFF / #161616, ink #1A1A1A / #ECECEC, one accent: ochre oklch(0.72 0.12 75) meaning "saved". Muted = ink at 0.62 / 0.45 / 0.28. Components use --color-* semantic tokens only.
4. Dark mode: data-theme="dark" flips the variables. Every pair re-checked. True black: no.
5. Grid: 4px. Container 16 / 24. Section rhythm 48.
6. Radii: 6 / 10 / 16. Nested = outer minus padding. Pills 999px for chips only.
7. Depth: hairline ring at ink 8%, no drop shadows anywhere. Images outlined at 10%.
8. Motion: motion.css tokens: --ease 120ms, --ease-enter 220ms, --ease-exit 150ms; springs only on the reader sheet drag. Named properties. Stagger 40ms on first paint of the list. Reduced motion = crossfade.
9. Hover: colour only. Press 0.97. Focus: browser ring, 2px offset.
10. Overlays: native <dialog> and one Vaul sheet. z-scale 100/200/300/400. Toasts never; state shows inline.
11. Forms: inputs 44px, 16px text, errors on the label row, submit always enabled, autocomplete set.
12. Icons: Lucide at 1.5 stroke, 20px, fill = active.
13. Copy: sentence case, verb-first ("Save article", "Archive"). Emoji: no. Em-dashes: no. Voice: quiet, exact.
14. States: empty invites ("Save your first article from the share sheet"), skeletons match rows, nothing spins before 300ms.
15. Not allowed: scroll-triggered fades, hover lift, ALL-CAPS eyebrows, a second accent.
```

### Checks

- Every row has a value, not a question.
- Row 3 has exactly one accent with a stated meaning.
- Row 8 names a file. If the file does not exist, create it from `assets/motion.css`.
- Row 15 lists things the project is actually tempted by, not generic sins.
- The contract is committed before the first polish change lands.

### Do not

- Write a contract longer than a screen. Split styles, do not merge them.
- Fill rows with "TBD". An empty row is a finding; a TBD row is a lie.
- Let the contract restate this skill. It records the project's choices, not the skill's defaults.

<!-- references/anti-patterns.md -->

## Anti-patterns and AI tells

Each entry is a thing that reads as "made by nobody in particular". Every one has a fix and a way to spot it. This is a negative list: it says what to refuse, not what to choose. A project whose design contract owns one of these keeps it; the tell is choosing it by default.

### Motion

#### `transition: all`
Why it reads as careless: it animates properties you did not intend (layout, colour, shadow) on their own timings, so nothing lines up, and it costs layout on every frame.
The fix: name the property. `transition: transform 150ms ease-out, opacity 150ms ease-out;`. Tailwind's bare `transition` is a curated list, not `all`; `transition-transform` covers `transform, translate, scale, rotate`.
How to spot it: `grep -rn "transition: all\|transition-all"`.

#### `will-change` on everything
Why: each promoted layer costs memory; promoted text blurs; nothing gets faster.
The fix: remove it. Add `will-change: transform` only to one element after you have observed a first-frame stutter in the Performance panel.
How to spot it: `grep -rn "will-change"`; more than a handful of hits is the finding.

#### Fade-and-slide-up on every section as it scrolls into view
Why: it is the statistical average of every template, delays content the reader already scrolled to, and triggers vestibular discomfort by default.
The fix: delete it. Keep one orchestrated hero moment gated by `sessionStorage`. See `references/marketing-pages.md`.
How to spot it: `grep -rn "whileInView\|IntersectionObserver\|data-aos"`; open the Animations panel and scroll.

#### Hover lift on every card
Why: lift promises navigation; a card that lifts and goes nowhere teaches the reader to distrust hover.
The fix: cards that navigate change one thing (border or underline colour). Cards that do not navigate do nothing on hover.
How to spot it: hover each card; ask where it goes.

#### Spring on opacity
Why: opacity has no mass; a bounce past 1 clamps and reads as a stutter.
The fix: opacity tweens, `200ms ease-out`. Transforms may spring.
How to spot it: any `type: "spring"` whose target includes `opacity`.

#### Bounce on an icon swap
Why: a check mark that overshoots looks like a toy.
The fix: `scale 0.25 → 1`, `blur(4px) → 0`, `{ duration: 0.3, bounce: 0 }`.
How to spot it: contextual icons with `bounce` > 0.

#### Stagger beyond eight items
Why: the last item arrives after the reader has already looked at it.
The fix: 30–40ms per item, cap around 8, first appearance only.
How to spot it: `staggerChildren` on lists without a cap.

#### Exits slower than entrances, or bouncy
Why: people want out faster than they wanted in.
The fix: exit at 0.65× the entrance, accelerating curve `cubic-bezier(0.4, 0, 1, 1)`, no bounce.
How to spot it: compare `exit` and `animate` durations in the same component.

#### Reduced motion handled with `animation: none`, or not at all
Why: `none` never fires `animationend`, so JS waiting on it hangs; ignoring the preference is a vestibular hazard.
The fix: opt-in motion under `prefers-reduced-motion: no-preference`; kill switch at `0.01ms`.
How to spot it: `grep -rn "prefers-reduced-motion"`; zero hits or `animation: none` inside.

### Colour and surfaces

#### One border-radius on everything
Why: the same radius on a 900px card and a 20px chip makes the chip look like a lozenge and the card look like a chip; nested corners collide.
The fix: three radii at most; nested radius = outer − padding.
How to spot it: `grep -rn "rounded-xl\|border-radius"`, count distinct values and their contexts.

#### The same `rgba(0,0,0,.1)` shadow under every card
Why: one soft grey blur under identical cards is the SaaS-template signature.
The fix: shadow-as-border in light (`0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04)`), a single white ring in dark, and an elevation ladder by named surface.
How to spot it: `grep -rn "rgba(0, *0, *0, *0.1)"`.

#### The five generic palettes and chrome
Cream near `#F4F1EA` with a serif and terracotta near `#D97757`; near-black plus one acid accent; broadsheet hairlines at zero radius; the identical-card kit; template chrome (ALL-CAPS eyebrows, middle-dot meta, a WORD then a spaced em dash then a fragment, `#0B0B0B` or `#111` posing as black, mono for small labels, an arrow appended to links).
Why: each is the default output of a thousand generators.
The fix: keep the project's own palette; if the project has none, write the design contract first. Remove eyebrows, arrows, and middle dots unless they carry information.
How to spot it: `grep -rn "F4F1EA\|D97757\|#111\b\|#0B0B0B\|uppercase.*tracking"`.

#### A single word in a headline italicised or coloured for effect
Why: it is a decoration that pretends to be emphasis.
The fix: one weight, one colour, a shorter headline.
How to spot it: `<em>` or a colour span inside an `<h1>`.

#### Numbered markers on content that is not a sequence
Why: 01 / 02 / 03 promises order that does not exist.
The fix: drop the numbers unless reordering would break meaning.
How to spot it: could the items be shuffled?

#### `backdrop-filter` without `saturate`
Why: blur desaturates; the result is grey mush.
The fix: `backdrop-filter: blur(24px) saturate(180%)`.
How to spot it: `grep -rn "backdrop-filter" | grep -v saturate`.

#### `backdrop-filter` on a scrolling or animating element
Why: it re-rasterises every frame anything behind it moves; it is the number-one frame killer.
The fix: static chrome only, two or three per screen.
How to spot it: Performance panel, scroll, look for long paint bars on the blurred element.

#### Opacity-based disabled states
Why: `opacity: 0.4` passes or fails contrast at random depending on the background.
The fix: a muted token pair, explicit and measured, plus a reason the control is disabled.
How to spot it: `grep -rn "disabled:opacity\|:disabled.*opacity"`.

#### Blue text that is not a link; accent hue on a non-interactive element
Why: colour is a promise of interactivity.
The fix: one colour, one meaning; anything within ±15° of the accent hue is either interactive or recoloured.
How to spot it: click every blue thing.

#### Tinted near-black posing as black
Why: `#111` under a `#000` heading reads as a mistake; it is the tell of a template that could not decide.
The fix: one ink, stepped in alpha for hierarchy.
How to spot it: count distinct dark greys in the token file.

### States

#### Spinner on the clicked button
Why: it says "the button is thinking" instead of "your thing is arriving".
The fix: lock the button's width and swap the label for a spinner in the same box, or better, show progress where the result will appear.
How to spot it: click, watch where the spinner lands.

#### Spinner before 300ms
Why: a flash of spinner for a fast request reads as slowness.
The fix: nothing for 300ms, then a skeleton with final dimensions.
How to spot it: throttle to fast 3G; anything that flashes is the finding.

#### Skeleton that does not match the content
Why: the illusion breaks when three bars become five lines.
The fix: same count, widths, and positions as the real content.
How to spot it: overlay the skeleton and the loaded state.

#### Toast for a field error
Why: the error vanishes before the reader finds the field.
The fix: inline on the label row, `aria-invalid`, focus the field.
How to spot it: submit an invalid form and watch the top-right corner.

#### Toast that vanishes with the only Undo
Why: data loss on a timer.
The fix: 5s floor, pause on hover, persist when it carries an action.
How to spot it: trigger a destructive action and count.

### Controls and forms

#### Submit disabled until the form is valid
Why: users get a dead button and no explanation.
The fix: keep it enabled, validate on submit, focus the first invalid field.
How to spot it: `grep -rn "disabled={!isValid\|disabled={!form"`.

#### `autocomplete="off"` on identity or payment fields
Why: it fails WCAG 1.3.5 and forces retyping.
The fix: the right token (`email`, `cc-number`, `one-time-code`, …).
How to spot it: `grep -rn 'autocomplete="off"'`.

#### Paste blocked
Why: it defeats password managers and OTP autofill.
The fix: remove the handler; trim values before validating.
How to spot it: `grep -rn "onPaste"` with `preventDefault`.

#### Hit area on the `<input>`
Why: replaced elements do not render pseudo-elements reliably; the expansion silently fails.
The fix: pseudo-element on the wrapping `<label>` or `<button>`.
How to spot it: DevTools box on the checkbox is 16px.

#### `z-index: 9999`
Why: it means the stack was never designed; the next overlay will be 10000.
The fix: a scale (`100 / 200 / 300 / 400`) or `isolation: isolate`.
How to spot it: `grep -rn "z-index: *9\{3,\}\|z-\[9"`.

### Copy

#### "Are you sure?" with OK / Cancel
Why: neither button names the consequence.
The fix: "Delete project?" with "Delete project" and "Cancel".
How to spot it: grep for "Are you sure".

#### "Oops! Something went wrong."
Why: it apologises and says nothing.
The fix: "Unable to save. Check your connection and try again."
How to spot it: grep for "Oops", "Something went wrong", "We're having trouble".

#### Emoji bullets and corporate openers
Why: checkmark and rocket lists are the most recognisable machine-written pattern; "We're thrilled to announce" says nothing.
The fix: plain bullets, or prose; lead with the thing.
How to spot it: grep the copy for the emoji ranges and for "thrilled".

### Structure and performance

#### `100vh` layouts
Why: iOS Safari's largest viewport overflows under the URL bar.
The fix: `dvh` for fill, `svh` for fixed chrome.
How to spot it: `grep -rn "100vh"`.

#### `maximum-scale=1` or `user-scalable=no`
Why: fails WCAG 1.4.4; Safari ignores it anyway.
The fix: inputs at 16px, remove the flag.
How to spot it: the viewport meta.

#### `position: fixed` on body to lock scroll
Why: loses scroll position and breaks the keyboard.
The fix: `<dialog>` + `overscroll-behavior: contain`, or `inert`.
How to spot it: grep for `body.style.position`.

#### `-webkit-overflow-scrolling: touch`
Why: default since iOS 13; it is dead code that signals a copied snippet.
The fix: delete it.
How to spot it: grep.

#### Fonts introduced by the polish pass
Why: a polish pass that adds a typeface is a restyle; Inter-by-default is its own tell.
The fix: use what the project owns. If it owns nothing, the design contract decides, not the audit.
How to spot it: diff `font-family` before and after the pass.

#### `setState` inside a drag handler
Why: a React render per pointer event drops frames.
The fix: `useMotionValue`, or a ref and a single rAF.
How to spot it: `onDrag` bodies that call a state setter.

### Marketing

#### Scroll hijacking, parallax, auto-advancing carousels
Why: scroll belongs to the reader; parallax off 1:1 is a vestibular trigger; carousels hide content.
The fix: remove; show the content.
How to spot it: scroll with the trackpad and watch the page do something else.

#### An arrow glyph after link text
Why: it decorates the link instead of describing the destination.
The fix: descriptive link text.
How to spot it: grep for the arrow character in JSX.

#### OG image that dies at 200px
Why: Slack and iMessage render it at 200px wide; small type vanishes.
The fix: headline ≥ 80px at 1200 wide, one focal point, tested at 200×105 and in greyscale.
How to spot it: resize the image to 200 wide.

<!-- references/accessibility.md -->

## Accessibility as polish

Use this when building or reviewing any interactive component, form, overlay, or route, and whenever something "works with a mouse" but has not been tried with a keyboard, a screen reader, zoom, or reduced motion. The interfaces people love are the ones that hold together under all four.

### Rules

1. **`:focus-visible` only, and a ring you can see.** Keep the browser ring and add `outline-offset: 2px`, or draw a custom `outline: 2px solid var(--focus-ring)` and verify it against every colour it crosses. `currentColor` is not automatically visible. Never `forced-color-adjust: none` inside `forced-colors: active`. Check: Tab through the primary path; the ring is visible at every stop, including on the accent-coloured button.
2. **`tabindex` is 0 or -1, never positive.** Composite widgets (tabs, toolbars, grids, listboxes) use roving tabindex: the active item is 0, the rest are -1, arrows move within, Tab leaves. Check: `grep -rn 'tabindex="[1-9]'` returns nothing.
3. **Modals use `<dialog>` with `showModal()`, or `inert` on everything else.** Focus the least destructive action on a destructive confirm. Return focus to the trigger on close. `overscroll-behavior: contain` inside. Check: open, Tab wraps inside; Escape closes; focus lands back on the button that opened it.
4. **Escape closes whatever opened last.** Tooltip, then menu, then dialog. Check: open a menu inside a dialog; Escape closes the menu only.
5. **Custom widgets keep the APG keyboard promise.** A role is a contract (see cheat sheet). Check: implement the table row for every `role=` you ship.
6. **Reduced motion is opt-in, and reduced, not eliminated.** Wrap motion in `@media (prefers-reduced-motion: no-preference)`. If you must use a global kill switch, set durations to `0.01ms`, not `none`, so `animationend` and `transitionend` still fire. Disable parallax, autoplay, and large-scale movement; replace slides and zooms with opacity crossfades; keep spinners, focus rings, and brief functional feedback. Check: emulate reduced motion in DevTools; the app still responds visibly to every action.
7. **The global kill switch is a floor, not a solution.** A `*` selector reaches CSS animations and transitions in the document, and nothing else. It does not reach five things, each of which is capable of being the single largest movement in your app. A project that honours reduced motion in a dozen hand-written CSS blocks still fails if its biggest slide is driven by JavaScript. Check: list every animation over 100px of travel, then name the mechanism driving each one.
8. **Anything that moves, blinks, or updates for more than five seconds has a visible pause.** Toasts stay at least 5s, pause on hover and focus, and persist when they carry an action or an error. Check: hover a toast; the timer stops.
9. **Zoom to 200% and reflow at 320px.** Text scales, nothing clips, no horizontal scrolling except in data tables and diagrams that scroll inside their own container. Check: 1280px wide at 400% zoom, and DevTools at 320px.
10. **`rem` for type, text containers, and breakpoints; `px` for hairlines, rings, and shadows.** Why: users who scale text expect layout to scale with it; borders should not. Check: grep breakpoints; media queries use `rem` or `em`.
11. **Visually hidden text uses the canonical `.sr-only` block.** 1px, not 0; `clip-path: inset(50%)`; `white-space: nowrap`. Never `display: none` for content a screen reader should read. Check: the class matches the block below.
12. **Choose how to announce.** Move focus for a new view; `aria-describedby` for context on a control; `role="status"` for polite updates; `role="alert"` only for urgent interruptions. Keep a stable, empty live region in the DOM for repeated polite updates. Check: a screen reader hears "Saved" once, not twice, and not the whole form.
13. **Never disable submit until valid.** Keep it enabled, validate on submit, set `aria-invalid="true"` and `aria-describedby` on each failing field, focus the first invalid field. Disable only once the request starts, keeping the label beside the spinner. Check: submit an empty form; focus lands on the first error and the error is read.
14. **`autocomplete` is a WCAG requirement (1.3.5).** `name`, `email`, `tel`, `street-address`, `postal-code`, `cc-number`, `cc-exp`, `cc-csc`, `username`, `current-password`, `new-password`, `one-time-code`. Never `autocomplete="off"` on identity or payment fields. Never block paste. Check: every identity field has a token.
15. **Alt by purpose.** Decorative: `alt=""` present, never missing (a missing alt reads the filename). Functional: name the action, `alt="Search"`, not the picture. Complex: a short summary plus a data table nearby. SVG: decorative gets `aria-hidden="true" focusable="false"`; meaningful gets `role="img"` and `aria-label`. Check: `grep -rn "<img" | grep -v "alt="` returns nothing.
16. **The visible label is in the accessible name.** Name precedence: `aria-labelledby` > `aria-label` > native label, text, alt > `title`. A button that shows "Save" must not be named "Submit form". Mark brand names and identifiers `translate="no"`. Check: inspect the accessibility tree; names match what is on screen.
17. **`aria-disabled` or `disabled`, never both.** With `aria-disabled` you must block pointer, keyboard, and submission in code and style it yourself. Check: grep for elements carrying both.
18. **Route changes announce themselves.** Update `document.title`, move focus to the new view's `<h1 tabindex="-1">` or `<main>`, restore scroll on back and forward, scroll to top on forward. Check: navigate with a screen reader running; the new page title is spoken.
19. **Hit areas: 24px floor, 44 touch, 40 pointer.** Expand with a pseudo-element on the wrapping `<button>` or `<label>`, never on the `<input>` (replaced elements do not render pseudo-elements reliably). Two hit areas never overlap. The 24px floor has a spacing exception: a 24px circle centred on the target must not intersect another target. Check: DevTools, hover each control, read the box.
20. **Colour never carries meaning alone.** Pair with a symbol, a label, or a pattern. Check: view in greyscale; can you still tell error from success?
21. **Respect `prefers-contrast: more` and `prefers-reduced-transparency`.** Widen the lightness gap by at least 0.15 L; swap translucent surfaces for solid. Check: emulate both in DevTools.

### Cheat sheet: what the kill switch does not reach

| Not reached | Why | Fix |
|---|---|---|
| Motion, GSAP, `element.animate()` | JS and WAAPI animations are not CSS; no selector touches them | `<MotionConfig reducedMotion="user">` at the root; `useReducedMotion()` to guard hand-rolled WAAPI |
| `::view-transition-*` | The transition pseudo-elements live in their own tree, outside the document | A separate `@media` block targeting `::view-transition-group(*)` and siblings |
| Canvas and WebGL render loops | A `requestAnimationFrame` loop is code, not style | `matchMedia("(prefers-reduced-motion: reduce)")` before you start the loop |
| `<video autoplay>`, animated GIF and WebP | Playback is not animation | Drop `autoplay`, or swap the poster for the animated source only under `no-preference` |
| Scroll-linked effects | `animation-timeline: scroll()` is still an animation, but a JS scroll handler is not | Guard the handler with the same `matchMedia` check |

### Cheat sheet: APG keyboard contracts

| Widget | Keys |
|---|---|
| Dialog | Tab / Shift+Tab cycle inside and wrap; Escape closes; focus returns to trigger |
| Tabs | Arrows move between tabs (wrap); Tab exits to the panel; Home / End jump |
| Menu button | Enter / Space / ArrowDown opens to first item; ArrowUp opens to last; arrows move; Escape closes and refocuses the button |
| Disclosure | A `<button aria-expanded>`; Enter and Space toggle |
| Combobox | ArrowDown opens or moves into the list; Enter accepts; Escape closes and returns to the input; typing filters |
| Listbox / radio group | Arrows move selection; one Tab stop for the group |

Universal: arrows move inside a composite, Tab moves between composites. Enter submits the focused input's form; in a `<textarea>` Enter inserts a newline and Cmd/Ctrl+Enter submits.

### Cheat sheet: announcement ladder

This is the canonical statement of the ladder. Other references point here rather than repeating it.

| Change | Mechanism | Example |
|---|---|---|
| A new view or step | Move focus to its heading | route change, wizard step |
| Extra context on a control | `aria-describedby` | "Must be at least 8 characters" |
| Polite status | `role="status"` (stable empty region, update its text) | "Saved", "3 results" |
| Urgent interruption | `role="alert"` | "Connection lost. Changes not saved." |

Pick the lowest rung that works. Two rungs for one change is a double announcement.

### Cheat sheet: units

| Use `rem` | Use `px` |
|---|---|
| `font-size` | borders and hairlines |
| text container `max-width` | focus outline width and offset |
| media-query breakpoints | `box-shadow` offsets and blur |
| spacing that should scale with text | fixed decorations and icons inside buttons |

### Code

```css
.sr-only {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  clip-path: inset(50%);
  white-space: nowrap;
  border: 0;
}

:focus-visible { outline: 2px solid var(--focus-ring); outline-offset: 2px; }

/* Motion is opt-in */
@media (prefers-reduced-motion: no-preference) {
  .card { transition: transform 200ms cubic-bezier(0.165, 0.84, 0.44, 1); }
}
/* Fallback kill switch for legacy code. A floor, not a solution: this
   reaches CSS animations and transitions in the document and nothing else. */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* View transitions live in their own tree, which the rule above cannot enter. */
@media (prefers-reduced-motion: reduce) {
  ::view-transition-group(*),
  ::view-transition-old(*),
  ::view-transition-new(*) {
    animation: none !important;
  }
}

/* Hit area on the button, not the input */
.check { position: relative; }
.check::after { content: ""; position: absolute; inset: -10px; }
```

```tsx
// Form errors
<label htmlFor="email">Email</label>
<input id="email" type="email" autoComplete="email" inputMode="email"
  aria-invalid={!!error} aria-describedby={error ? "email-error" : undefined} />
{error && <p id="email-error" role="alert">{error}</p>}

// Motion, GSAP, and any WAAPI animation need their own guard.
<MotionConfig reducedMotion="user">
  <App />
</MotionConfig>

// A render loop is code, so ask before you start it.
const still = matchMedia("(prefers-reduced-motion: reduce)");
function start() {
  if (still.matches) { drawOneFrame(); return; }
  raf = requestAnimationFrame(tick);
}
still.addEventListener("change", () => { cancelAnimationFrame(raf); start(); });

// Route change
useEffect(() => {
  document.title = `${pageTitle} · ${appName}`;
  headingRef.current?.focus();
}, [pathname]);
<h1 ref={headingRef} tabIndex={-1}>{pageTitle}</h1>
```

### Checks

1. Keyboard-only pass through the primary path: every control reachable, ring visible, Escape ladder correct, focus returns after every overlay.
2. VoiceOver on Safari (Cmd+F5): headings navigable, controls named as shown, errors announced once.
3. axe or Lighthouse: zero critical issues; read every "needs review".
4. 200% zoom at 1280 and 320px width: no clipping, no horizontal scroll.
5. Emulate `prefers-reduced-motion`, `prefers-contrast: more`, `prefers-reduced-transparency`, `forced-colors`.
6. Greyscale screenshot: state still legible.
7. `grep -rn 'tabindex="[1-9]'`, `grep -rn "<img" | grep -v alt=`, `grep -rn 'autocomplete="off"'`: zero hits or each justified.
8. **Audit every role against its keyboard handling.** A role is a contract, and a broken one is invisible to a mouse, which is why this is often the most productive grep in a review. Count the composite roles you ship, then count the keyboard code in the same files:

   ```bash
   grep -rEn 'role="(radiogroup|tablist|menu|menubar|listbox|tree|grid)"' src | wc -l
   grep -rn 'onKeyDown\|tabIndex' src | wc -l
   # then, per file:
   grep -rlE 'role="(radiogroup|tablist|menu|listbox)"' src \
     | xargs -I{} sh -c 'printf "%s roles=%s keys=%s\n" {} \
         "$(grep -cE "role=\"(radiogroup|tablist|menu|listbox)\"" {})" \
         "$(grep -c "onKeyDown" {})"'
   ```

   Any file with roles and zero `onKeyDown` is a promise the markup makes and the code does not keep.

### Do not

- Remove the focus ring without replacing it with one you verified.
- Use `display: none` for text a screen reader should read.
- Disable submit until the form validates.
- Set `autocomplete="off"` on a name, email, address, card, or OTP field.
- Block paste.
- Announce the same change twice (focus move plus alert).
- Handle reduced motion with `animation: none`.
- Ship a global kill switch and assume JavaScript animation is covered.
- Ship a `role=` without its keyboard contract.

<!-- references/buttons-and-controls.md -->

## Buttons and controls

Use this when you are building or reviewing any clickable thing: buttons, icon buttons, toggles, segmented controls, sliders, footers with Save and Cancel, anything with a loading or disabled state.
The project's own control tokens win; these are the defaults and the checks.

### Rules

1. **Six states, every button.** Rest, hover, active, focus-visible, loading, disabled. A button with four of the six is unfinished. Check: tab to it, hover it, hold it, submit with it, disable it.
2. **Hover changes colour, not position.** Motion on hover promises a destination; a card that lifts but is not a link lies. ≤ 150ms, `ease`. A lift of 1px is acceptable only on links to other pages. Check: does the hovered element navigate somewhere? If not, colour only.
3. **Press scale from the ladder.** Rows 0.99, surfaces and CTAs 0.97, icon buttons 0.94, floor 0.90. `transition: transform 150ms ease-out`. Never animate from `scale(0)`; start at 0.95. Check: hold a button; it should feel pressed, not shrunk.
4. **Focus ring only on `:focus-visible`.** Keep the browser ring plus `outline-offset: 2px`, or a custom `outline: 2px solid var(--focus-ring)` verified against every colour it crosses. Never `outline: none` without a replacement. Check: tab through the page; every stop is visible.
5. **Loading locks the width.** Measure the resting width, fix it, swap the label for a spinner inside the same box. Nothing else on the page moves. Keep the accessible name (`aria-label` = original label, `aria-busy="true"`). Check: click and watch the layout; zero shift.
6. **Disabled is a muted token, not opacity, and it says why.** Opacity-based disabled states pass or fail contrast at random. Pair the state with a reason in text nearby ("Add a title to publish"). Check: any disabled control with no visible reason is a finding.
7. **`disabled` or `aria-disabled`, never both.** `disabled` removes it from the tab order; `aria-disabled` keeps it reachable and announces the state, but then you block pointer, keyboard, and submission in code. Use `aria-disabled` when the reason should be discoverable by keyboard users. Check: tab to it; does it behave as announced?
8. **Targets 44px touch, 40px pointer, 24px WCAG floor.** Expand with a pseudo-element on the `<button>` or `<label>`, never on an `<input>` (replaced elements do not render `::before` reliably). Two hit areas never overlap; the 24px floor has a spacing exception: a 24px circle centred on the target must not intersect another. Check: DevTools, hover the pseudo-element, measure.
9. **`touch-action: manipulation` on every control.** Removes the 300ms double-tap delay where it still exists and stops accidental zoom. Set `-webkit-tap-highlight-color` to match the design (usually transparent, with your own active state). Check: tap fast twice on mobile; no zoom.
10. **One filled primary per view.** Colour goes on the background of the primary, never on its label. Blue text reads as a link. Secondary is outlined or tinted; tertiary is text-only with a hover background. Check: count filled buttons in the viewport; more than one is a finding.
11. **Icon-only buttons have names.** `aria-label` always; a tooltip does not count. Check: screen reader reads "Close", not "button".
12. **Tooltips open after 200ms, then warm.** First tooltip waits 200ms; while a tooltip is open or was open within the last 300ms, siblings open instantly with no animation. Check: sweep across a toolbar; the first waits, the rest follow the cursor.
13. **Optical alignment: icon side gets 2px less padding.** An icon next to text has less visual mass on that side. `padding-inline-start: 14px; padding-inline-end: 16px` (Tailwind `ps-3.5 pe-4`). A play triangle nudges `translateX(2px)` in a circle. Check: squint; the label looks centred.
14. **Confirmation and copy states hold for 1.5s.** Copy-to-clipboard swaps to a check, "Publishing…" becomes "Published", then reverts. Long enough to read, short enough not to feel stuck. Check: time it.
15. **Footers reserve their final width.** "Done" becomes "Cancel · Save" when dirty; the footer keeps the wider layout from the start and cross-fades labels in 150ms. Nothing reflows. Check: type in a field and watch the footer edge.
16. **The button is the spinner.** On submit, the working button swaps its label for an inline spinner at locked width and stops accepting clicks. No separate loading UI, no second click window. Check: double-click submit; one request.
17. **Toggles are switches.** `<button role="switch" aria-checked>`. The label names the ON state ("Send read receipts"). The thumb moves in ≤ 150ms or instantly; a toggle is a 100×-a-day control. Check: read the label; does "on" make sense?
18. **Segmented controls slide one indicator.** The selected background is one element that moves with the `snappy` spring; labels do not animate. Arrow keys move selection; one Tab stop. Check: press ← → with focus on the control.
19. **Sliders are native inputs, styled.** 6px track, 16px thumb, `:focus-visible` ring via `color-mix`, `:active` scale 1.15 in 120ms. Never a custom drag implementation for a value picker. Check: keyboard arrows change the value.
20. **Every press animation has an escape hatch.** A `static` prop (or class) that removes scale for buttons inside lists, tables, and toolbars where the motion becomes noise. Check: any button pressed 100+ times a day is static.

### Cheat sheet

| State | Value |
|---|---|
| Hover | colour change ≤ 150ms `ease`; no transform unless it navigates |
| Active | `scale(0.97)` CTAs, 0.94 icon buttons, 0.99 rows; `150ms ease-out` |
| Focus | `:focus-visible` ring, `outline-offset: 2px` |
| Loading | width locked, spinner replaces label, `aria-busy` |
| Disabled | muted token (not opacity) + visible reason |
| Target | 44px touch, 40px pointer, 24px floor |
| Tooltip | 200ms delay, warm for 300ms |
| Confirm hold | 1.5s |
| Search debounce | 300ms |
| Label crossfade | 150ms |

| Button role | Fill | Where |
|---|---|---|
| Primary | filled with the accent | once per view |
| Secondary | outlined or tinted surface | beside the primary |
| Tertiary | text only, hover background | menus, toolbars, inline |
| Destructive | filled only in a confirm dialog; text elsewhere | named noun ("Delete project") |

### Code

```css
.btn {
  position: relative;
  min-height: 40px;
  padding-inline: 16px;
  border-radius: var(--radius-md);
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
  transition: background-color 150ms ease, color 150ms ease, transform 150ms ease-out;
}
.btn:active:not([data-static]) { transform: scale(0.97); }
.btn:focus-visible { outline: 2px solid var(--focus-ring); outline-offset: 2px; }
.btn[aria-disabled="true"], .btn:disabled { background: var(--surface-muted); color: var(--ink-muted); }
.btn[aria-busy="true"] > .label { visibility: hidden; }
.btn[aria-busy="true"] > .spinner { position: absolute; inset: 0; display: grid; place-items: center; }

/* icon-side optical padding */
.btn:has(> .icon:first-child) { padding-inline-start: 14px; }

/* hit-area expansion on a small icon button (24px visual, 44px target) */
.icon-btn { position: relative; inline-size: 24px; block-size: 24px; }
.icon-btn::after { content: ""; position: absolute; inset: -10px; }

/* native range, styled */
.range {
  -webkit-appearance: none; appearance: none;
  width: 100%; height: 6px; border-radius: 999px;
  background: var(--track); cursor: pointer; outline: none;
}
.range::-webkit-slider-thumb {
  -webkit-appearance: none; appearance: none;
  width: 16px; height: 16px; border-radius: 50%;
  background: var(--thumb); border: 2px solid var(--canvas);
  box-shadow: 0 1px 3px rgb(0 0 0 / 0.25);
  transition: transform 0.12s ease;
}
.range::-webkit-slider-thumb:active { transform: scale(1.15); }
.range::-moz-range-thumb { width: 16px; height: 16px; border-radius: 50%; background: var(--thumb); border: 2px solid var(--canvas); }
.range:focus-visible { box-shadow: 0 0 0 3px color-mix(in srgb, var(--thumb) 35%, transparent); }
```

```tsx
// Button.tsx: one component, six states, width lock on loading.
import { useLayoutEffect, useRef, useState } from "react";

type Props = React.ComponentProps<"button"> & {
  loading?: boolean;
  static?: boolean;          // disables press scale (lists, toolbars)
  variant?: "primary" | "secondary" | "tertiary";
};

export function Button({ loading, static: isStatic, variant = "secondary", children, ...rest }: Props) {
  const ref = useRef<HTMLButtonElement>(null);
  const [width, setWidth] = useState<number>();
  useLayoutEffect(() => {
    if (loading && ref.current && width === undefined) setWidth(ref.current.offsetWidth);
    if (!loading) setWidth(undefined);
  }, [loading]);
  return (
    <button
      ref={ref}
      className={`btn btn-${variant}`}
      data-static={isStatic || undefined}
      aria-busy={loading || undefined}
      aria-label={loading ? String(children) : undefined}
      style={width ? { width } : undefined}
      onClick={loading ? undefined : rest.onClick}
      {...rest}
    >
      <span className="label">{children}</span>
      {loading && <span className="spinner" aria-hidden="true">…</span>}
    </button>
  );
}
// If you need the styles on an <a>, expose an `asChild` prop (Base UI / Radix Slot pattern)
// rather than rendering a <button> inside a link. A link is not a button.
```

```tsx
// Copy to clipboard: check for 1.5s, then revert.
const [copied, setCopied] = useState(false);
async function copy(text: string) {
  await navigator.clipboard.writeText(text);
  setCopied(true);
  setTimeout(() => setCopied(false), 1500);
}
```

```tsx
// Done → Cancel · Save: reserve the wider width; cross-fade the labels.
<div className="footer" style={{ minWidth: "var(--footer-dirty-width)" }}>
  {dirty ? (
    <>
      <Button variant="tertiary" onClick={reset}>Cancel</Button>
      <Button variant="primary" loading={saving} onClick={save}>Save</Button>
    </>
  ) : (
    <Button variant="primary" onClick={close}>Done</Button>
  )}
</div>
```

```css
.footer > * { transition: opacity 150ms ease; }
```

### Checks

- Tab through every control; the ring shows on every stop and only on keyboard focus.
- Hold each button; the scale matches the ladder and nothing below 0.90 exists.
- Click submit twice fast; the network tab shows one request.
- Disable every control in turn; each has a visible reason.
- Measure icon buttons in DevTools; the pseudo-element reaches 44px.
- Sweep a toolbar with the cursor; the first tooltip waits, the rest are instant.
- Type in a form with a Done footer; the footer edge does not move.
- Screen reader over icon buttons; each reads a verb.

### Do not

- Animate hover position on anything that does not navigate.
- Put two filled buttons side by side.
- Use `opacity` to mean disabled.
- Put both `disabled` and `aria-disabled` on one element.
- Expand hit areas on an `<input>`; do it on the `<label>`.
- Render a `<div onClick>` where a `<button>` belongs.
- Show a spinner anywhere except inside the button that is working, at locked width.
- Build a slider from divs when `<input type="range">` will do.

See `references/forms-and-inputs.md` for submit rules, `references/overlays.md` for confirm dialogs, `references/motion.md` for the easing tokens.

<!-- references/canvas-and-media.md -->

## Canvas and generated media

Use this when the product *is* the pixels: a design tool, an editor, a chart engine, a generative or game surface, anything drawn with `<canvas>`, WebGL, or WebGPU and anything that exports an image or a video.
A canvas is invisible to every tool the rest of this skill relies on. The DOM inspector shows one element, the accessibility tree shows nothing, and CSS reaches none of it. Everything below has to be done by hand.

### Rules

1. **A canvas is an image with no alt.** Give it `role="img"` and an `aria-label` that describes the current state in words, rebuilt whenever the state changes ("Isometric grid, 12 by 8, amber on charcoal"). A canvas with no name is announced as "canvas" or skipped entirely. Check: turn on VoiceOver or NVDA, land on the canvas, and hear a sentence that tells you what is drawn.
2. **A canvas that takes input is a control surface, not an image.** Pointer handlers on the element give a keyboard user nothing. Every action reachable by clicking the canvas needs a real focusable DOM control somewhere: a toolbar button, a list of layers, an arrow-key handler on a `tabIndex={0}` wrapper with `role="application"`. Check: unplug the mouse and complete the primary task.
3. **Changes that exist only as pixels must be announced in words.** A slider that redraws the canvas gives a sighted user instant feedback and a screen reader user silence. Put the meaning in `aria-valuetext`, not the raw number: `aria-valuetext="Grid spacing 24 pixels"`, not `24`. Check: drag every slider with a screen reader on; each one says what it changed, not a bare integer.
4. **Ask for the colour space or lose it silently.** `getContext("2d", { colorSpace: "display-p3" })` is required for wide-gamut output; without it every P3 value is clamped to sRGB with no warning. WebGL needs `drawingBufferColorSpace` and `unpackColorSpace`. Check: draw the same colour as P3 and as sRGB side by side on a wide-gamut display; if they match, the flag did not take.
5. **An invalid `fillStyle` is a silent no-op.** Assign an unparseable or out-of-gamut string and the assignment is ignored, the *previous* fill stays, and nothing throws. A whole render can come out in the last colour that happened to parse. Validate before assigning, or read the property back and compare. Check: assign a deliberately broken colour in the console; the canvas keeps painting, which is the bug.
6. **Back the canvas at `devicePixelRatio`, size it in CSS.** Set `canvas.width = cssWidth * dpr` and `canvas.style.width = cssWidth + "px"`, then `ctx.scale(dpr, dpr)`. A canvas sized only in CSS is blurry on every retina screen. Re-back it on resize *and* on a DPR change, which fires when a window moves between displays. Check: drag the window from a retina display to an external monitor and back; the drawing stays sharp.
7. **The render loop is the performance budget, not page load.** A 60fps loop leaves 16.7ms per frame and 8.3ms at 120Hz. Nothing else in `references/performance.md` matters if the loop misses. Check: the Performance panel shows frames inside budget while the loop runs, not just a fast first paint.
8. **Stop the loop when nobody can see it.** `IntersectionObserver` to stop when the canvas scrolls off screen, `visibilitychange` to stop when the tab is hidden. An unattended `requestAnimationFrame` is a battery bug that only shows up in someone else's laptop fan. Check: scroll the canvas away and hide the tab; the loop's frame counter stops.
9. **Restart from now, not from where you left off.** On resume, reset the loop's time origin. Restarting from a stale timestamp replays every millisecond the tab was hidden as one enormous jump. Check: hide the tab for a minute, return, and nothing fast-forwards.
10. **Never drive a render loop from React state.** A `setState` per frame re-renders the tree sixty times a second to change numbers React does not own. Keep the loop outside React and let it read a ref that React writes. Check: React DevTools' profiler records no commits while the canvas animates.
11. **Reduced motion reaches the loop only if you check it.** A CSS kill switch cannot touch `requestAnimationFrame`. Read `matchMedia("(prefers-reduced-motion: reduce)")` before starting ambient animation and render the settled frame instead, and listen for changes so a mid-session toggle takes effect. Motion that is the point of the product (a preview the user pressed play on) may continue; ambient drift may not. Check: enable Reduce Motion and reload; nothing moves on its own.
12. **One renderer, never a second draw path for export.** The export must call the same function as the preview with a different scale, or the file will diverge from what was on screen, quietly, forever. Check: export at preview size and diff against a screenshot of the canvas.
13. **Draw in design space and scale once.** Author coordinates against a fixed design size (`1920 × 1080`, say), and pass a scale factor into the renderer. Reading the on-screen size inside drawing code is what makes exports depend on the size of the browser window. Check: resize the window and export again; the file is identical.
14. **If changing the export resolution does not change the number of pixels in the file, the export path is a lie.** A resolution control that only changes metadata is worse than no control. Check: export at 1× and 4× and compare the actual pixel dimensions and file size.
15. **Await fonts and images before rendering for export.** `document.fonts.ready` and decoded images, or the export races the preview and drops a typeface that was visible on screen. Check: hard-reload and export immediately; the file has the right font.
16. **Give the result a real filename and a real type.** `toBlob` over `toDataURL` for anything large, an explicit MIME type and quality, and a filename with the document name and dimensions in it, not `download.png`. Check: export twice with different settings; the two files are distinguishable in a Downloads folder.
17. **Drag out and paste in.** A canvas people build things in should support dragging the result to the desktop (`DataTransfer` with `DownloadURL`) and pasting an image from the clipboard. Both are cheap and both are expected. Check: drag the canvas to the desktop; paste a screenshot into the app.
18. **Long jobs are states, not spinners.** An encode or a large export follows the loading ladder, keeps a cancel, and survives failure without unmounting the progress surface. See `references/states.md`; do not invent a second pattern here.
19. **Test in greyscale.** A generative surface is exactly where colour becomes the only channel carrying meaning. Check: DevTools Rendering, emulate achromatopsia; the drawing still reads.
20. **Guard the context.** `getContext` returns `null` when the canvas is too large, memory is exhausted, or the GPU process has died, and WebGL contexts are lost on sleep and on tab pressure. Handle `webglcontextlost` and re-create. Check: force a context loss with `WEBGL_lose_context`; the app recovers instead of showing a blank rectangle.

### Cheat sheet

| Budget | Value |
|---|---|
| Frame at 60Hz | 16.7ms |
| Frame at 120Hz | 8.3ms |
| Backing store | `cssSize × devicePixelRatio` |
| Design space | one fixed size, scale passed in |
| Export | `toBlob`, explicit MIME and quality |

| Concern | Mechanism |
|---|---|
| Name the canvas | `role="img"` + live `aria-label` |
| Announce a pixel-only change | `aria-valuetext` on the control that caused it |
| Keyboard access | real DOM controls, or `role="application"` + arrow keys |
| Wide gamut | `{ colorSpace: "display-p3" }` on the context |
| Stop off screen | `IntersectionObserver` |
| Stop when hidden | `visibilitychange` |
| Reduced motion | `matchMedia`, checked in JS |
| Long export | `references/states.md` ladder |

| Trap | What happens |
|---|---|
| No `colorSpace` | wide-gamut values clamp to sRGB, silently |
| Invalid `fillStyle` | assignment ignored, previous colour persists, no error |
| CSS-only sizing | blurry on every retina display |
| Loop resumed from stale time | one enormous jump on return |
| Second draw path for export | file diverges from preview, quietly |
| `setState` per frame | sixty React commits a second |

### Code

Backing store, DPR, and re-backing on display change:

```ts
function fit(canvas: HTMLCanvasElement, cssW: number, cssH: number) {
  const dpr = window.devicePixelRatio || 1;
  canvas.width = Math.round(cssW * dpr);
  canvas.height = Math.round(cssH * dpr);
  canvas.style.width = `${cssW}px`;
  canvas.style.height = `${cssH}px`;
  const ctx = canvas.getContext("2d", { colorSpace: "display-p3" });
  ctx?.setTransform(dpr, 0, 0, dpr, 0, 0);
  return ctx;
}

// devicePixelRatio changes when the window moves between displays.
function watchDpr(onChange: () => void) {
  let mq: MediaQueryList;
  const listen = () => {
    mq = matchMedia(`(resolution: ${window.devicePixelRatio}dppx)`);
    mq.addEventListener("change", () => { onChange(); listen(); }, { once: true });
  };
  listen();
}
```

An invalid colour is a no-op, so validate before assigning:

```ts
const probe = document.createElement("canvas").getContext("2d")!;
export function isPaintable(colour: string) {
  probe.fillStyle = "#000";
  probe.fillStyle = colour;            // ignored if unparseable
  const black = probe.fillStyle;
  probe.fillStyle = "#fff";
  probe.fillStyle = colour;
  return black === probe.fillStyle;    // same result from both starts means it parsed
}
```

A loop that stops when unseen, respects reduced motion, and never sets React state:

```ts
export function startLoop(canvas: HTMLCanvasElement, state: { current: Params }) {
  const reduce = matchMedia("(prefers-reduced-motion: reduce)");
  let raf = 0, origin = 0, visible = true, onScreen = true;

  const frame = (now: number) => {
    if (!origin) origin = now;              // restart from now, not from a stale origin
    render(canvas, state.current, now - origin);
    raf = requestAnimationFrame(frame);
  };
  const run = () => {
    if (raf || !visible || !onScreen) return;
    if (reduce.matches) { render(canvas, state.current, Number.POSITIVE_INFINITY); return; }
    origin = 0;
    raf = requestAnimationFrame(frame);
  };
  const stop = () => { cancelAnimationFrame(raf); raf = 0; };

  const io = new IntersectionObserver(([e]) => { onScreen = e.isIntersecting; onScreen ? run() : stop(); });
  io.observe(canvas);
  const onVis = () => { visible = !document.hidden; visible ? run() : stop(); };
  document.addEventListener("visibilitychange", onVis);
  reduce.addEventListener("change", () => { stop(); run(); });

  run();
  return () => { stop(); io.disconnect(); document.removeEventListener("visibilitychange", onVis); };
}
```

One renderer, two callers, design space in and a scale factor:

```ts
const DESIGN = { w: 1920, h: 1080 };

export function render(target: CanvasRenderingContext2D, p: Params, t: number, scale = 1) {
  target.save();
  target.scale(scale, scale);            // every coordinate below is design space
  drawScene(target, p, t, DESIGN);
  target.restore();
}

export async function exportPng(p: Params, multiplier: number) {
  await document.fonts.ready;
  const c = document.createElement("canvas");
  c.width = DESIGN.w * multiplier;       // resolution really changes the pixels
  c.height = DESIGN.h * multiplier;
  const ctx = c.getContext("2d", { colorSpace: "display-p3" })!;
  render(ctx, p, 0, multiplier);         // the same function the preview calls
  return new Promise<Blob>((res) => c.toBlob((b) => res(b!), "image/png"));
}
```

Name the canvas and announce what a control changed:

```tsx
<canvas
  ref={ref}
  role="img"
  aria-label={`Isometric grid, ${cols} by ${rows}, ${paletteName}`}
/>

<input
  type="range"
  min={8} max={64}
  value={spacing}
  aria-label="Grid spacing"
  aria-valuetext={`Grid spacing ${spacing} pixels`}
  onChange={(e) => setSpacing(+e.target.value)}
/>
```

Drag the artwork out as a file, and accept a pasted image:

```ts
canvas.addEventListener("dragstart", (e) => {
  const url = canvas.toDataURL("image/png");
  e.dataTransfer?.setData("DownloadURL", `image/png:${name}.png:${url}`);
});

window.addEventListener("paste", async (e) => {
  const file = [...(e.clipboardData?.files ?? [])].find((f) => f.type.startsWith("image/"));
  if (file) place(await createImageBitmap(file));
});
```

Recover a lost WebGL context:

```ts
canvas.addEventListener("webglcontextlost", (e) => { e.preventDefault(); stop(); });
canvas.addEventListener("webglcontextrestored", () => { rebuildResources(); run(); });
```

### Checks

- Screen reader lands on the canvas and hears a description of what is drawn, not "canvas".
- Every slider announces meaning, not a bare number.
- Unplug the mouse and complete the primary task.
- Enable Reduce Motion, reload; nothing moves on its own; a pressed play still plays.
- Scroll away and hide the tab; the frame counter stops. Return; nothing fast-forwards.
- React profiler records no commits while the canvas animates.
- Move the window between displays; the canvas stays sharp.
- Export at 1× and 4×; pixel dimensions differ by exactly 4.
- Export at preview size and diff against a screenshot of the canvas.
- DevTools Rendering, emulate achromatopsia; the drawing still reads.
- Force a context loss with `WEBGL_lose_context`; the app recovers.

### Do not

- Ship a `<canvas>` with no accessible name.
- Put the only path to an action behind a click on the canvas.
- Send a raw number to `aria-valuetext`.
- Assume a colour assigned to `fillStyle` was accepted.
- Size a canvas in CSS alone.
- Leave `requestAnimationFrame` running off screen or in a hidden tab.
- Resume a loop from the timestamp it was paused at.
- Call `setState` inside a frame callback.
- Write a second draw path for export.
- Ship a resolution control that does not change the file's pixel dimensions.
- Export before `document.fonts.ready`.
- Name the file `download.png`.

See `references/performance.md` for the frame budget and `visibilitychange`, `references/states.md` for long exports, `references/color.md` for OKLCH and gamut, `references/accessibility.md` for live regions and reduced motion.

<!-- references/color.md -->

## Colour

Use this when you are choosing, converting, checking, or auditing colour on the web: tokens, palettes, contrast, dark pairs, gamut, and how colour carries meaning.
Pair with `references/theming-and-dark-mode.md` for the switching mechanism and `references/surfaces-and-depth.md` for shadows and outlines.

### Rules

1. **Work in OKLCH.** It is perceptually uniform, so equal steps in L look equal and hue does not drift as you lighten. Format: `oklch(L C H / alpha)`, three decimals for L and C, integer or one decimal for H, `0` never `-0`. Check: no new colour is authored in hex or HSL; hex appears only as a legacy fallback.
2. **Do not convert notation because this skill loaded.** A project in hex that is consistent is not a finding. Convert only when the project asks, or when you are adding a token and the token file is already OKLCH.
3. **L above 0.73 wants dark text.** Below it, light text. The boundary is soft, so verify the pair with a contrast measurement rather than the rule. Check: every background token has a paired foreground that passes below.
4. **Measure contrast with APCA first, WCAG second.** APCA |Lc| targets: body 75 minimum and 90 preferred, non-body text 60 (75 preferred), large text at 36px+ 45 (60 preferred), UI components and icons 30, absolute floor 15. WCAG 2: 4.5:1 normal text, 3:1 large text (24px, or 18.5px bold) and UI. Report both when a client or regulator cares about WCAG.
5. **Mid-lightness backgrounds cap contrast.** On a background at L 0.75, even pure black text only reaches about Lc 60. If a surface sits between L 0.35 and 0.75, expect to move the surface, not the text.
6. **Fix contrast by adjusting L.** Hold C and H, move L until the pair passes, remeasure. Changing hue or chroma to fix contrast produces a colour that no longer matches its siblings.
7. **Report, do not repaint.** When auditing, list the failing pairs with measured values. Repaint only when asked; polish does not own the palette.
8. **Build scales by lightness, clamp chroma per step.** For a base colour, set `delta = 0.4`, `minL = max(0.05, baseL - 0.4)`, `maxL = min(0.95, baseL + 0.4)`, distribute L evenly across 50 to 950, then clamp each step's chroma to `(chroma% / 100) × maxChroma(L, H, space)`. Without the clamp, light and dark steps fall out of gamut and get silently pulled toward grey.
9. **Multi-hue palettes share L and chroma percentage, not absolute chroma.** At L 0.5 in sRGB, purple near H 285 can reach C 0.29 while cyan near H 195 peaks near 0.09. Same absolute C makes some hues look more vivid than others; same percentage of each hue's maximum keeps them siblings.
10. **One colour, one meaning.** A hue within ±15° of the accent on something non-interactive tells users to click it. Reserve the accent for the primary action and selected state; give status its own hues (success, warning, danger) and use each for exactly one thing.
11. **One filled primary per view, colour on the background.** `bg-accent text-on-accent` reads as the primary. Accent-coloured text on a neutral background reads as a link. A selected state may tint a glyph or label; that is state, not emphasis.
12. **Disabled uses a muted token, not opacity.** Opacity-based disabled states pass or fail contrast depending on what is behind them. A named token is predictable and testable.
13. **Semantic tokens in components, base tokens in one file.** Base tokens say what a value is (`--base-neutral-300`); semantic tokens say what it does (`--color-text-muted`, `--color-bg-raised`). Components reference semantic tokens only. Enforce it with a lint rule (a Stylelint `declaration-property-value-disallowed-list` on `var(--base-`, or a grep in CI) so nobody reaches past the semantic layer.
14. **Provide an increased-contrast variant.** Under `@media (prefers-contrast: more)`, widen the foreground/background lightness gap by at least 0.15 L, then re-verify at Lc 90 for body and 75 for non-body.
15. **Test colour on translucency over the extremes.** A colour on a `backdrop-filter` surface shifts with what scrolls behind it. Verify the pair over the lightest and darkest content the page can produce.
16. **Ship P3 as an enhancement.** sRGB value first, then the wider value inside `@supports (color: oklch(0 0 0))` nested in `@media (color-gamut: p3)`. Never let the P3 value be the only value.
17. **Make gain and loss per-locale tokens.** Red means gains in Chinese financial interfaces and losses in most Western ones; white carries mourning in parts of East Asia. Colour that encodes money or status must be a token the locale can swap.
18. **Dark mode is not a mirror.** Do not reverse the scale mechanically. See `references/theming-and-dark-mode.md`.

### Cheat sheet

| Measure | Body text | Non-body | Large (36px+) | UI / icons | Floor |
|---|---|---|---|---|---|
| APCA |Lc| | 75 min, 90 preferred | 60 min, 75 preferred | 45 min, 60 preferred | 30 | 15 |
| WCAG 2 | 4.5:1 (7:1 AAA) | 4.5:1 | 3:1 (4.5:1 AAA) | 3:1 | n/a |

| Situation | Move |
|---|---|
| Pair fails contrast | Adjust L only; remeasure |
| Surface at L 0.35–0.75 | Move the surface; text cannot fix it |
| Two hues look unequal in vividness | Match chroma percentage, not absolute C |
| Same hue as accent on a non-link | Change the hue or make it interactive |
| `opacity: .4` on disabled | Replace with a muted token |
| Hex in a project already on OKLCH | Convert on touch, not in bulk |

Hue drift proof, why HSL fails: `hsl(240 80% 20%)` converts to roughly OKLCH H 269; `hsl(240 80% 90%)` converts to roughly H 285. Same HSL hue, 16° of visible drift across one ramp. Anything beyond 10° across a scale is visible.

Culture table (example, extend per product):

| Meaning | Default (Western) | Chinese financial UIs | Note |
|---|---|---|---|
| Gain | green | red | token: `--color-gain` |
| Loss | red | green | token: `--color-loss` |
| Mourning | black | white (parts of East Asia) | avoid as a "clean" empty-state wash in those locales |

### Code

Token layers with a P3 enhancement (values are examples):

```css
/* tokens/base.css: private. Nothing outside tokens/ may reference --base-*. */
:root {
  --base-neutral-950: oklch(0.180 0.006 260);
  --base-neutral-050: oklch(0.985 0.003 260);
  --base-brand-600: oklch(0.560 0.160 262);
}

/* tokens/semantic.css: public. Components use only these. */
:root {
  --color-bg: var(--base-neutral-050);
  --color-text: var(--base-neutral-950);
  --color-text-muted: oklch(from var(--color-text) l c h / 0.62);
  --color-accent: var(--base-brand-600);
  --color-on-accent: var(--base-neutral-050);
  --color-text-disabled: oklch(from var(--color-text) l c h / 0.38); /* a token, not opacity on the element */
}

@media (color-gamut: p3) {
  @supports (color: oklch(0 0 0)) {
    :root { --base-brand-600: oklch(0.560 0.190 262); } /* example: more chroma, same L and H */
  }
}

@media (prefers-contrast: more) {
  :root {
    --color-text-muted: oklch(from var(--color-text) l c h / 0.80);
  }
}
```

Tailwind v4 scale in `@theme` (example values):

```css
@theme {
  --color-brand-50: oklch(0.970 0.020 262);
  --color-brand-500: oklch(0.623 0.141 262);
  --color-brand-900: oklch(0.300 0.090 262);
}
/* bg-brand-500/50 compiles to oklch(0.623 0.141 262 / 0.5) */
```

Multi-hue siblings, same L and same percentage of each hue's max chroma (example): `--blue-500: oklch(0.623 0.141 250)` (80% of 0.176), `--green-500: oklch(0.623 0.157 145)`, `--red-500: oklch(0.623 0.202 25)`.

Scale generation, in words, for a script: for each step L in the even distribution between `minL` and `maxL`, compute the maximum in-gamut chroma at that L and H for the target space, multiply by the base colour's chroma percentage, and emit `oklch(L C H)`. Libraries such as culori expose `clampChroma` for the gamut step.

Lint guard, Stylelint (example):

```json
{
  "rules": {
    "declaration-property-value-disallowed-list": {
      "/.*/": ["/var\\(--base-/"]
    }
  },
  "overrides": [{ "files": ["src/tokens/**/*.css"], "rules": { "declaration-property-value-disallowed-list": null } }]
}
```

### Checks

- Every background/foreground pair measured in both themes; values recorded in the findings table.
- Grep for `var(--base-` outside the token directory returns nothing.
- Grep for `opacity: 0.4` and `opacity-40` on disabled controls returns nothing.
- Only one filled accent element per view in the primary path.
- A screenshot of the page in greyscale still shows the primary action first.
- `@media (color-gamut: p3)` blocks all have an sRGB sibling outside them.
- Any hue used within ±15° of the accent is interactive.

### Do not

- Convert a consistent hex palette to OKLCH because this skill loaded.
- Fix contrast by darkening chroma or nudging hue.
- Put the accent on link text and on a button in the same view.
- Use `opacity` for disabled, muted, or placeholder states.
- Reverse a light palette to make the dark one.
- Ship a P3-only value.
- Introduce a second accent during polish. If the project needs one, it goes in the design contract first.

<!-- references/copy-and-naming.md -->

## Copy and naming

Use this when you write or review any text a person reads in the interface: button labels, links, errors, empty states, settings, navigation, placeholders, toasts, pricing.
Preserve the project's voice. Flag a difference from plain language only when it creates inconsistency, ambiguity, translation risk, or the wrong tone for the stakes.

### Rules

1. **Buttons are verb-first and name the noun.** "Delete project", "Save changes", "Send invite". Never "OK", "Yes", "Submit", "Let's go!". The reader should know what happens from the button alone. Check: cover everything but the buttons; can you still tell what each does?
2. **Sentence case by default, one policy per element type.** Title Case is a house choice; if the project uses it, use it everywhere in that element type. Mixed policies read as carelessness. Check: list every heading and button; one case each.
3. **Pick one advance verb.** "Continue" or "Next", not both. "Get started" enters a flow; "Done" leaves it. Check: grep for both; keep one.
4. **An action keeps its name through the flow.** "Publish" produces "Publishing…" then "Published". Not "Submit" → "Success!". Check: follow one action from button to confirmation; the verb never changes.
5. **Links describe their destination.** "Read the billing docs", never "Click here" or "here". When several "Learn more" links share a view, suffix each: "Learn more about exports". Check: read the links out of context; each says where it goes.
6. **Toggles label the ON state.** "Send read receipts", never "Don't send read receipts". A negated toggle makes "on" mean "off". Check: read the label with "on" appended; it makes sense.
7. **Errors say what happened and what to do.** Calm, plain, no playfulness, no apology. "Unable to save. Check your connection and try again." Never "Oops!", "Something went wrong", "We're having trouble". Check: every error has a next step.
8. **Tone follows stakes.** Success, onboarding, and empty states can be warm. Routine and settings are neutral and minimal. Errors and destructive actions are calm and plain. Data loss and security are serious and explicit. Check: no exclamation mark near a destructive action.
9. **Device verbs match the device.** "Tap" on touch, "click" with a pointer, "select" when you cannot know. Check: instructions on a responsive page use "select" or are conditional.
10. **Never concatenate strings around variables.** `"You have " + n + " messages"` breaks in every language with different plural rules and word order. Use full templated strings and `Intl.PluralRules` or ICU messages. Check: grep for `+ " "` in UI strings.
11. **Placeholders are examples, not labels.** `name@example.com`, `DD/MM/YYYY`, `Search projects`. The label is separate and stays visible. Check: every input has a visible label.
12. **Empty states name the thing, say why, and offer one action.** "No invoices yet. They appear here once you send one. [Create invoice]". Search empties name the query and offer "Clear filters". Check: no empty state says "No items".
13. **Navigation is named by contents.** "Library", "Progress", "Invoices". Not "Home", "Dashboard", "Stuff". Specific labels beat safe umbrellas. Check: could a new user guess what is behind each item?
14. **Name things as users understand them, not as the system is built.** "Notifications", not "Webhook config". "Your team", not "Organisation members". Check: no internal noun appears in the interface.
15. **Each written element does one job.** A heading names; a description explains; a button acts. A heading that also explains is two elements in one. Check: split anything doing two jobs.
16. **Numbered markers only for real sequences.** 01 / 02 / 03 on features that are not steps is decoration pretending to be structure. Check: could the items be reordered without loss? Then no numbers.
17. **No accenting a single headline word.** Italic, colour, or weight on one word in a headline is a template tell. Emphasis comes from the sentence. Check: headlines are one style throughout.
18. **ALL-CAPS labels are a house choice, not a default.** If the project uses them, 11–13px with +0.05em tracking, and everywhere consistently. Do not add them in a polish pass. Check: no eyebrow label was introduced by you.
19. **Middle-dot meta strings and arrows in links are tells.** `Author · Date · 5 min` and "Read more →" read as generated. Use a sentence, a comma, or layout instead. House style may keep them if it already has them; do not add them. Check: none introduced by you.
20. **Emoji: off in interface chrome by default.** Buttons, navigation, headings, errors, and labels carry no emoji. User content and deliberately warm moments (a first-run greeting) may. House style may override in the design contract. Check: grep chrome strings for emoji.
21. **Em-dashes: off in UI copy by default.** Use an en dash for ranges (2010–2020), a comma or colon otherwise. House style may override in the design contract. Check: grep UI strings for the em-dash character.
22. **Skip unnecessary gender.** "Subscribers can post recipes", not "A subscriber can post his or her recipes". Check: no gendered pronoun stands in for a generic user.
23. **Protect what must not translate.** `translate="no"` on brand names, codes, and identifiers. Set `lang` on the document and on any run of text in another language. Check: run the page through a translator; brand names survive.
24. **Pricing is plain.** "$99 per month per listing." Never hidden behind "Contact us" when there is a number, never a per-day figure to shrink it, always the total beside any per-month equivalent. Check: the real charge appears in words on the page.
25. **Preserve intentional brand character.** A house voice that is warm, dry, or terse is not a finding. Flag only when it creates inconsistency, ambiguity, translation risk, or the wrong tone for the stakes. Check: before rewriting, ask what the voice is doing on purpose.

### Cheat sheet

#### Error rewrites

| Before | After |
|---|---|
| Invalid email | Enter an email address with an @ |
| That password is too short | Choose a password with at least 8 characters |
| Invalid name | Use only letters for your name |
| Oops! Something went wrong. | Unable to save. Check your connection and try again. |
| We're having trouble loading this. | Unable to load projects. Retry |
| Error 500 | Unable to publish right now. Try again in a minute. |
| Are you sure? | Delete this project? Its 12 files are removed. [Delete project] [Cancel] |
| Payment failed | Your card was declined. Try another card or contact your bank. |
| Session expired | You were signed out after 30 minutes. Sign in to continue. |
| Field required | Enter a title to save |
| Upload failed | Files must be PNG or JPG under 10 MB |
| Nothing found | No results for "quarterly". Clear filters |

#### Tone by stakes

| Moment | Tone |
|---|---|
| Success, onboarding, empty | warm; may be light |
| Routine, settings, navigation | neutral, minimal |
| Errors, destructive actions | calm, plain, zero playfulness |
| Data loss, security, billing | serious, explicit, complete |

#### Vocabulary

| Use | Not |
|---|---|
| Continue (or Next; pick one) | Proceed, Go, Onwards |
| Get started | Let's go!, Begin your journey |
| Done | Finish, Complete, OK |
| Delete project | Delete, Remove, Yes |
| Save changes | Submit, Apply, OK |
| Sign in / Sign out | Log in / Log out (either is fine; pick one) |
| Read the billing docs | Click here, Learn more |
| Send read receipts | Don't send read receipts |

### Code

```ts
// Plurals and word order belong to the locale, not the string.
const rules = new Intl.PluralRules(locale);
const forms: Record<Intl.LDMLPluralRule, string> = {
  zero: "No new messages", one: "1 new message", two: "{n} new messages",
  few: "{n} new messages", many: "{n} new messages", other: "{n} new messages",
};
export const messagesLabel = (n: number) => forms[rules.select(n)].replace("{n}", String(n));
```

```tsx
// An action keeps its name.
const label = state === "idle" ? "Publish" : state === "working" ? "Publishing…" : "Published";
<Button loading={state === "working"}>{label}</Button>
```

```html
<!-- Toggle labels the ON state; brand name does not translate. -->
<label>
  <button role="switch" aria-checked="true">Send read receipts</button>
</label>
<p>Sync with <span translate="no">Acme Drive</span> every hour.</p>
```

```ts
// Lint: no em-dash, no emoji in chrome strings (adjust the allowlist per contract).
const CHROME_STRINGS = ["Delete project", "Save changes" /* ... */];
const bad = CHROME_STRINGS.filter((s) => /\u2014|\p{Extended_Pictographic}/u.test(s)); // U+2014 is the em-dash
```

### Checks

- Read only the buttons on each screen; the flow is clear.
- Follow one action from button to confirmation; the verb is stable.
- Read every link out of context; each names a destination.
- Append "on" to every toggle label; each still makes sense.
- Every error has a next step and no apology.
- Grep UI strings for `+ "`, em-dashes, emoji, "Click here", "Oops".
- Run the page through machine translation; brand names and codes survive.
- Ask what the house voice is doing before changing it.

### Do not

- Write "OK", "Yes", "Submit" on a consequential button.
- Mix Title Case and sentence case within one element type.
- Apologise in an error, or make one playful.
- Concatenate around a variable.
- Use a placeholder as a label.
- Add eyebrow labels, middle dots, arrows, or emoji the project did not already have.
- Rename a house voice into generic plain language without a stated reason.
- Hide a price.

See `references/states.md` for empty and error placement, `references/onboarding-and-pricing.md` for pricing pages, `references/accessibility.md` for accessible names.

<!-- references/forms-and-inputs.md -->

## Forms and inputs

Use this when you are building or reviewing anything a person types into: sign-up, checkout, settings, search, a single text field in a sheet.
The project's own input tokens win; these are the defaults and the checks.

### Rules

1. **Inputs are 16px or larger on mobile.** iOS Safari zooms any field smaller than 16px on focus and never zooms back. `font-size: max(16px, 1rem)`; Tailwind `text-base sm:text-sm`. Never `maximum-scale=1` to hide it; that fails WCAG 1.4.4 in every other browser. Check: focus a field on a phone; no zoom.
2. **Strip the platform chrome, keep the platform behaviour.** `-webkit-appearance: none` plus your own border and radius. Keep the native `type` so keyboards, autofill, and validation still work. Check: the date field still opens a native picker.
3. **40–44px tall.** 44 on touch-first products, 40 on desktop tools. Match the button height beside it. Check: input and its submit button share a baseline and a height.
4. **The label is always visible.** Placeholders vanish on the first keystroke and fail contrast when they do not. A placeholder is an example (`name@example.com`, `DD/MM/YYYY`), never the label. Check: fill every field; can you still tell what each is?
5. **Submit is never disabled until valid.** A dead button does not explain itself. Keep it enabled, validate on submit, mark each invalid field, focus the first one. Disable only while the request runs, and keep the label beside the spinner. Check: submit an empty form; you land on the first problem with a sentence telling you what to do.
6. **Errors sit on the label row.** Above the field, next to the label, so the eye reads label, error, field in one pass and nothing below shifts. `aria-invalid="true"` on the input, `aria-describedby` pointing at the error. Check: screen reader announces the error when the field gains focus.
7. **Hints come before mistakes, phrased positively.** "Use at least 8 characters" under the label from the start beats "Password too short" after the fact. Check: could a user get it right on the first try from what is on screen?
8. **A repeated error is a design bug.** If the same error fires for many users, redesign the interaction; do not reword the message. Check: analytics on error frequency per field.
9. **`autocomplete` tokens are required.** WCAG 1.3.5. They also make sign-up take four seconds instead of forty. Never `autocomplete="off"` on identity, address, or payment fields. Check: the browser offers to fill every field it should.
10. **`inputmode` and `type` are separate decisions.** OTP, PIN, and card numbers are `type="text" inputmode="numeric"` (keeps text semantics, no spinner, allows spaces). Money is `inputmode="decimal"`. `type="number"` only for a real quantity you would add up. Check: the numeric keyboard appears, and leading zeros survive.
11. **Never block paste.** Password managers, OTP autofill, and people copying a card number all depend on it. Check: paste into every field.
12. **Trim before validating.** A trailing space from autofill is not a wrong email. Check: type `a@b.com ` with a space; it passes.
13. **`autofocus` only where a pointer is likely.** On touch devices it opens the keyboard over the content the person has not read yet. Gate it on `!('ontouchstart' in window)`. Check: open the page on a phone; no keyboard until a tap.
14. **Focus a sheet's field after the sheet has landed.** Focusing during the entrance animation fights the keyboard and the spring. Wait for `onAnimationComplete` or ~350ms. Check: open the sheet; the keyboard rises after, not during.
15. **Handle the virtual keyboard inset.** `navigator.virtualKeyboard.overlaysContent = true` and `env(keyboard-inset-height, 0px)` where supported; fall back to `visualViewport` and apply the offset as a `transform`, never `bottom`, so the browser does not repaint the whole layer. Check: a bottom-pinned action row stays visible above the keyboard.
16. **Freeze timers when the tab hides.** A form with a countdown or autosave interval should pause on `visibilitychange`; background tabs throttle timers and you will fire late or twice. Check: switch tabs during a countdown.
17. **Counters are quiet.** "12 of 48", tabular numbers, quaternary ink. Turn to the warning colour only past the limit. Never "36 characters remaining!". Check: type past the limit; the counter is the only thing that changes.
18. **Selects and comboboxes follow the APG.** ↓ opens to the first option, ↑ opens to the last, Enter accepts, Escape returns to the input without clearing it, typing filters. One Tab stop. Check: complete a selection with the keyboard only.
19. **`enterkeyhint` matches the action.** `search`, `send`, `done`, `next`, `go`. The keyboard's blue key then says what will happen. Check: the key label matches the button label.
20. **Preserve the draft on failure.** A failed submit keeps every value and shows the error; a network error never empties a form. Check: kill the network and submit.
21. **Success is a state, not a redirect.** After submit, show what happened where the form was (or where the result lives) and move focus there. Check: submit with a screen reader; the outcome is announced.
22. **Page-level errors get a summary with links.** When several fields fail, list them at the top, each linking to its field, and move focus to the summary. Check: three invalid fields produce a three-item summary.
23. **`spellcheck="false"` only on identifiers.** Usernames, codes, URLs. Everywhere else the red underline is doing its job. Check: no red underline under an email address; one under a misspelled note.
24. **Password fields reveal, never re-type.** A show/hide toggle (`aria-pressed`) beats a confirm field. `autocomplete="new-password"` on sign-up so managers generate one. Check: the manager offers a generated password.
25. **File inputs describe what they accept.** Types and size limit in text before the picker opens; a preview after. Reject in the UI, not only on the server. Check: drop a wrong type; the message names the allowed types.

### Cheat sheet

| Field | `type` | `inputmode` | `autocomplete` | `enterkeyhint` |
|---|---|---|---|---|
| Full name | text | | `name` | next |
| First / last | text | | `given-name` / `family-name` | next |
| Email | email | email | `email` | next |
| Phone | tel | tel | `tel` | next |
| Street | text | | `street-address` or `address-line1` | next |
| Postcode | text | | `postal-code` | next |
| Country | select | | `country` | |
| Card number | text | numeric | `cc-number` | next |
| Expiry | text | numeric | `cc-exp` | next |
| CVC | text | numeric | `cc-csc` | done |
| Name on card | text | | `cc-name` | next |
| Username | text | | `username` | next |
| Password (sign in) | password | | `current-password` | go |
| Password (sign up) | password | | `new-password` | next |
| One-time code | text | numeric | `one-time-code` | done |
| Amount | text | decimal | | done |
| Quantity | number | numeric | | done |
| Search | search | search | | search |

Section prefixes: `autocomplete="shipping street-address"`, `"billing cc-number"`.

| Timing | Value |
|---|---|
| Focus after sheet opens | ~350ms or `onAnimationComplete` |
| Search debounce | 300ms |
| Validation | on submit; then live per field after first failure |
| Error reveal | 150ms fade, no movement of the field |

### Code

```css
.field input, .field select, .field textarea {
  -webkit-appearance: none; appearance: none;
  font-size: max(16px, 1rem);
  min-height: 44px;
  padding-inline: 12px;
  border: 1px solid var(--hairline);
  border-radius: var(--radius-sm);
  background: var(--surface);
}
.field input:focus-visible { outline: 2px solid var(--focus-ring); outline-offset: 2px; }
.field input[aria-invalid="true"] { border-color: var(--danger); }
.field .label-row { display: flex; justify-content: space-between; gap: 12px; }
.field .error { color: var(--danger); font-size: 0.8125rem; }
.field .counter { font-variant-numeric: tabular-nums; color: var(--ink-quaternary); font-size: 0.8125rem; }
```

```tsx
// Validate on submit, mark, focus the first invalid field. Never disable submit for validity.
function onSubmit(e: React.FormEvent<HTMLFormElement>) {
  e.preventDefault();
  const form = e.currentTarget;
  const errors = validate(new FormData(form)); // { email: "Enter an email with an @" }
  setErrors(errors);
  const first = Object.keys(errors)[0];
  if (first) {
    (form.elements.namedItem(first) as HTMLElement)?.focus();
    return;
  }
  setSubmitting(true);
  submit(form).catch((err) => setErrors({ form: err.message })).finally(() => setSubmitting(false));
}

<div className="field">
  <div className="label-row">
    <label htmlFor="email">Email</label>
    {errors.email && <span id="email-error" className="error">{errors.email}</span>}
  </div>
  <input
    id="email" name="email" type="email" inputMode="email" autoComplete="email" enterKeyHint="next"
    aria-invalid={errors.email ? true : undefined}
    aria-describedby={errors.email ? "email-error" : undefined}
    placeholder="name@example.com"
  />
</div>
<Button variant="primary" loading={submitting}>Create account</Button>
```

```ts
// Virtual keyboard inset: prefer the API, fall back to visualViewport. Apply as a transform.
export function useKeyboardInset(el: React.RefObject<HTMLElement>) {
  useEffect(() => {
    const vk = (navigator as any).virtualKeyboard;
    if (vk) { vk.overlaysContent = true; return; } // then use env(keyboard-inset-height) in CSS
    const vv = window.visualViewport;
    if (!vv) return;
    const update = () => {
      const kb = Math.max(0, window.innerHeight - vv.height - vv.offsetTop);
      el.current?.style.setProperty("transform", `translateY(-${kb}px)`);
    };
    vv.addEventListener("resize", update); vv.addEventListener("scroll", update);
    return () => { vv.removeEventListener("resize", update); vv.removeEventListener("scroll", update); };
  }, [el]);
}
```

```css
/* With the VirtualKeyboard API */
.sheet-actions { padding-bottom: calc(16px + env(keyboard-inset-height, 0px)); }
```

```tsx
// Focus after the sheet lands, not during.
<Sheet onAnimationComplete={() => inputRef.current?.focus()} />
```

### Checks

- On a phone, focus every field: no zoom, correct keyboard, correct blue key label.
- Submit empty: focus lands on the first invalid field and its error is read aloud.
- Autofill the whole form from the browser; every field is offered.
- Paste into every field; nothing is blocked.
- Kill the network, submit: values remain, error appears, submit re-enables.
- Type past a limit: only the counter changes.
- Tab through a select with the keyboard and complete it.
- Open a sheet with a field: keyboard appears after the sheet settles.

### Do not

- Disable submit until the form is valid.
- Put the error below the field where it pushes everything down.
- Use placeholders as labels.
- Set `autocomplete="off"` on anything a password manager should fill.
- Use `type="number"` for codes, cards, or phone numbers.
- Block paste, ever.
- Autofocus on touch.
- Apply keyboard offsets with `bottom`; use `transform`.

See `references/buttons-and-controls.md` for the submit button, `references/states.md` for error placement, `references/accessibility.md` for the announcement ladder.

<!-- references/haptics-and-sound.md -->

## Haptics and sound on the web

Use this when someone asks for vibration, "a satisfying click", or sound effects in a web app or PWA. The honest answer is usually "less than you think": the web has a thin haptic API on Android, none on iOS Safari, and sound that ignores the ringer switch. Visual and motion feedback carry the load; see `references/motion.md` and `references/buttons-and-controls.md`.

### Rules

1. **Haptics fire on `pointerdown`, never on `click`.** A haptic must arrive within ~50ms of contact to read as "the button heard me"; `click` fires on release, 100–150ms later, and the pulse lands after the visual change. Check: the vibrate call is in an `onPointerDown` handler.
2. **Only for commit moments.** Press-down on a primary action, a toggle flip, a successful submit, an error. Never on scroll, hover, page load, an element appearing, or a list item rendering. Check: no vibrate call lives in a scroll, intersection, or effect-on-mount handler.
3. **Feature-detect and expect absence.** `navigator.vibrate` exists on Android Chrome and Firefox. It does not exist on iOS Safari or desktop, and it returns `false` silently when blocked. The interface must feel complete with zero haptics. Check: with `navigator.vibrate` deleted in the console, nothing errors and nothing feels missing.
4. **Do not rely on the iOS switch trick.** Creating an `<input type="checkbox" switch>` and clicking it inside a user-gesture task triggers the system toggle haptic on iOS 17.4+. It is undocumented, breaks across versions, and can fire an unwanted change event. If you use it, feature-detect the `switch` attribute, wrap it in try/catch, remove the element on the next frame, and treat it as a bonus. Check: the app has no code path that requires it to work.
5. **Keep pulses short and few.** Light 8ms, medium 15ms, heavy 25ms, error `[10, 40, 10]`. Anything longer reads as a notification, not a touch. Check: no single pulse over 25ms outside an explicit error pattern.
6. **Sound is almost always wrong.** Web audio ignores the hardware ringer switch, plays through whatever the user is listening to, and needs a gesture to unlock. Interface sounds in a general-purpose site or app surprise people in meetings. Check: a sound cue exists only in an app where sound is the product (metronome, timer, game, meditation, music).
7. **When sound is the product, it is opt-in with a persistent toggle and its own volume.** `prefers-reduced-motion` says nothing about sound; provide a separate control, remember it, and default to the quieter option. Check: a sound toggle is reachable from settings and is persisted.
8. **Unlock audio on the first gesture, then keep it warm.** Create one `AudioContext` on the first `pointerdown`, `resume()` it, and reuse it. Preload buffers. A cue that arrives late is worse than no cue. Check: the first cue plays with no delay after the first interaction.
9. **Cues are under 200ms and land in the same frame as the visual.** A cue is punctuation; a haptic, a cue, and the visual change should be indistinguishable in time. Check: trigger the visual change and the cue from the same handler, not from a `setTimeout` or a network callback.
10. **Respect the platform's own feedback.** Native `<input type="range">`, `<select>`, and switches on mobile already tick or click on some devices; do not layer your own on top. Check: no vibrate call on a native control's `change`.

### Cheat sheet

| Moment | Pattern (ms) | Where |
|---|---|---|
| Primary press-down | `8` | `onPointerDown` |
| Toggle flip, chip select | `8` | `onPointerDown` |
| Commit (submit, save) | `15` | on success, same frame as the visual |
| Destructive confirm | `25` | on the confirm press-down |
| Error | `[10, 40, 10]` | with the inline error |
| Scroll, hover, load, appear | none | |

| Platform | `navigator.vibrate` | Notes |
|---|---|---|
| Android Chrome / Firefox | yes | may be throttled or disabled by the OS |
| iOS Safari | no | switch-input trick is fragile |
| Desktop browsers | no | |

| Sound | Allowed |
|---|---|
| General app or site | no |
| Sound-first product (timer, metronome, game, meditation, music) | yes, opt-in, own toggle, own volume, cues < 200ms |

### Code

A guarded haptic helper:

```ts
type Pulse = "light" | "medium" | "heavy" | "error";
const PATTERN: Record<Pulse, number | number[]> = { light: 8, medium: 15, heavy: 25, error: [10, 40, 10] };

export function haptic(kind: Pulse = "light") {
  if (typeof navigator === "undefined" || typeof navigator.vibrate !== "function") return;
  try { navigator.vibrate(PATTERN[kind]); } catch { /* blocked or unsupported: nothing to do */ }
}
```

Wired to press-down, alongside the visual press:

```tsx
<button onPointerDown={() => haptic("light")} className="press">Save</button>
```

The iOS switch trick, only as a bonus and only inside a user gesture:

```ts
export function iosSwitchHaptic() {
  const input = document.createElement("input");
  input.type = "checkbox";
  input.setAttribute("switch", "");
  if (!("switch" in input) && !input.hasAttribute("switch")) return; // no support, no attempt
  input.style.cssText = "position:fixed;opacity:0;pointer-events:none";
  document.body.appendChild(input);
  try { input.click(); } catch { /* ignore */ }
  requestAnimationFrame(() => input.remove());
}
```

Audio, unlocked once and reused:

```ts
let ctx: AudioContext | null = null;
const buffers = new Map<string, AudioBuffer>();

export async function unlockAudio() {
  ctx ??= new AudioContext();
  if (ctx.state === "suspended") await ctx.resume();
}

export async function loadCue(name: string, url: string) {
  ctx ??= new AudioContext();
  const data = await (await fetch(url)).arrayBuffer();
  buffers.set(name, await ctx.decodeAudioData(data));
}

export function playCue(name: string, volume = 0.3) {
  if (!ctx || !buffers.has(name) || !settings.soundEnabled) return;
  const src = ctx.createBufferSource();
  const gain = ctx.createGain();
  gain.gain.value = volume;
  src.buffer = buffers.get(name)!;
  src.connect(gain).connect(ctx.destination);
  src.start();
}

document.addEventListener("pointerdown", unlockAudio, { once: true });
```

Same frame, same handler:

```tsx
function onComplete() {
  setDone(true);          // visual
  haptic("medium");       // touch
  playCue("done", 0.3);   // sound, only if the product is sound-first
}
```

### Checks

- Every vibrate call is inside `onPointerDown` or a commit handler; none inside scroll, hover, mount, or intersection code.
- Delete `navigator.vibrate` in the console; the app behaves identically.
- On iOS Safari with the switch trick disabled, nothing is missing.
- Sound cues, if any, are under 200ms and play only when the persisted toggle is on.
- First cue after page load plays with no delay.
- Toggling `prefers-reduced-motion` does not silence or enable sound; the separate toggle does.

### Do not

- Vibrate on `click`, on scroll, on hover, or on appearance.
- Ship a code path that depends on the iOS switch trick.
- Play interface sounds in a general-purpose app.
- Autoplay any sound before a user gesture.
- Tie sound to the reduced-motion preference.
- Layer a haptic on a native control that already provides one.

<!-- references/icons.md -->

## Icons

Use this when you are choosing, sizing, colouring, animating, or auditing icons and the buttons built from them.
Pair with `references/typography.md` for weight matching and `references/accessibility.md` for names and announcements.

### Rules

1. **One family, everywhere.** Two icon sets in one interface never match in stroke, corner, or optical size. If a glyph is missing from the family, draw it in the family's grid; do not import a second set for one icon.
2. **Stroke matches the adjacent text weight.** 1.5px beside 400 text at 14–16px; 2px beside 500–600; 2.5px beside 700. An icon heavier than its label shouts; lighter, it disappears. Lucide's default stroke of 2 is heavy beside most body text: use 1.5–1.75 with `absoluteStrokeWidth` so the stroke does not scale with size.
3. **`currentColor` only.** Icons inherit the colour of the text they sit beside. No hardcoded fills, no per-icon colour props. Then every state (hover, disabled, selected, error) is one CSS rule on the parent.
4. **One asset per icon, recoloured per state.** Never two SVGs for "active" and "inactive" that differ only in fill. State is CSS.
5. **Two states: outline at rest, fill when active.** Outline is the default; the filled variant marks selected, on, or current. Three-state schemes (stroke, duotone, solid) triple the asset count for no gain in meaning.
6. **Size inline icons at 1em–1.25em.** They follow the type scale. Standalone icons use the family's native grids: 16, 20, 24. Never 18 or 22 from a 24-grid; the strokes land on half pixels and blur.
7. **Design and test at 16px.** If an icon is unreadable at 16px, simplify it. Detail that only reads at 32px is decoration.
8. **Icon-only controls have a name.** `aria-label` on the button, or a visually hidden label. A tooltip is not a name. See `references/accessibility.md`.
9. **Decorative SVGs are hidden; meaningful ones are images.** Decorative: `aria-hidden="true" focusable="false"`. Meaningful (the icon is the only content): `role="img"` with `aria-label`. An icon inside a labelled button is decorative.
10. **Optically align, then measure.** The icon-side padding of a button is 2px less than the text-side (`ps-4 pe-3.5` when the icon leads). A play triangle inside a circle shifts `translateX(2px)`. A square glyph in a circle renders at about 92% of the circle's diameter to look equal.
11. **Contextual swaps animate with fixed values.** Copy to check, plus to close, play to pause: scale 0.25 to 1, opacity 0 to 1, `blur(4px)` to 0, spring `{ type: "spring", duration: 0.3, bounce: 0 }`. Bounce is always 0 on an icon swap. Hold a success glyph 1.5s before reverting. CSS fallback: both icons in the DOM, one absolute, cross-fade with `cubic-bezier(0.2, 0, 0, 1)` over 300ms.
12. **Flip for RTL by meaning, not by default.** Flip glyphs that encode reading direction: back and forward chevrons, text-alignment and list glyphs, send arrows, volume waves, progress arrows. Do not flip logos, checkmarks, physical objects (a phone, a clock), media playback (play, fast-forward), or anything with text in it.
13. **Disabled icon buttons use a muted token.** `color: var(--color-icon-disabled)`, not `opacity: 0.4`. Opacity changes contrast unpredictably over different backgrounds.
14. **Inline SVG or sprite, never an icon font.** Icon fonts break with font loading, reflow on swap, and read as characters to assistive tech. Inline SVG for a handful; a `<symbol>` sprite with `<use>` for many.
15. **Corners follow the type.** A rounded typeface wants round-capped strokes; a sharp one wants square caps and joins. Check the family's `stroke-linecap` against the letterforms.
16. **No idle animation.** An icon that breathes, pulses, or wiggles while nothing is happening is the loudest template tell. Animate only on a state change, and pair it with the change.
17. **Selected state is the fill, not the colour.** A filled glyph in `currentColor` marks selection without the accent. The accent on a selected tab is a house choice; record it in the design contract.

### Cheat sheet

| Text weight | Icon stroke |
|---|---|
| 400 at 14–16px | 1.5px |
| 500–600 | 2px |
| 700 | 2.5px |

| Context | Size |
|---|---|
| Inline with text | 1em–1.25em |
| Standalone, dense UI | 16px |
| Toolbar, list rows | 20px |
| Navigation, hero controls | 24px |
| Touch target around any of these | 44px (40px pointer) |

| RTL | Flip | Do not flip |
|---|---|---|
| | chevron-left/right, arrow-left/right, back, forward, send, reply, undo/redo, align-left/right, list indent, volume, progress | logos, check, x, plus, minus, search, clock, phone, camera, play, pause, skip, anything containing letters |

| State | Mechanism |
|---|---|
| Hover | parent `color` change, ≤ 150ms |
| Active / selected | filled variant |
| Disabled | muted token |
| Swap (copy to check) | scale 0.25 to 1, blur 4 to 0, spring bounce 0, 300ms |

### Code

Inline icon that inherits everything:

```tsx
export function Icon({ children, size = "1em", ...rest }: React.SVGProps<SVGSVGElement> & { size?: string | number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor"
         strokeWidth={1.5} strokeLinecap="round" strokeLinejoin="round"
         aria-hidden="true" focusable="false" {...rest}>
      {children}
    </svg>
  );
}
```

Lucide with an honest stroke:

```tsx
import { Copy } from "lucide-react";
<Copy size={16} strokeWidth={1.5} absoluteStrokeWidth aria-hidden="true" />
```

Icon-only button with a name and a 44px target:

```tsx
<button type="button" aria-label="Copy link" className="icon-button">
  <Copy size={16} strokeWidth={1.5} absoluteStrokeWidth aria-hidden="true" />
</button>
```

```css
.icon-button { position: relative; inline-size: 32px; block-size: 32px; color: var(--color-icon); }
.icon-button::after { content: ""; position: absolute; inset: -6px; } /* 44px hit area */
.icon-button:hover { color: var(--color-icon-hover); transition: color 150ms ease; }
.icon-button:disabled { color: var(--color-icon-disabled); }
.icon-button[aria-pressed="true"] svg { fill: currentColor; } /* fill = active */
[dir="rtl"] .icon-directional { transform: scaleX(-1); }
```

Contextual swap, Motion:

```tsx
<AnimatePresence mode="wait" initial={false}>
  <motion.span key={copied ? "check" : "copy"}
    initial={{ scale: 0.25, opacity: 0, filter: "blur(4px)" }}
    animate={{ scale: 1, opacity: 1, filter: "blur(0px)" }}
    exit={{ scale: 0.25, opacity: 0, filter: "blur(4px)" }}
    transition={{ type: "spring", duration: 0.3, bounce: 0 }}>
    {copied ? <Check size={16} /> : <Copy size={16} />}
  </motion.span>
</AnimatePresence>
```

CSS-only swap, both glyphs in the DOM:

```css
.swap { position: relative; display: inline-grid; }
.swap > svg { grid-area: 1 / 1; transition: opacity 300ms cubic-bezier(0.2, 0, 0, 1), transform 300ms cubic-bezier(0.2, 0, 0, 1); }
.swap > .alt { opacity: 0; transform: scale(0.25); }
.swap[data-on] > .base { opacity: 0; transform: scale(0.25); }
.swap[data-on] > .alt { opacity: 1; transform: scale(1); }
```

Optical padding on a leading-icon button:

```css
.button-with-icon { padding-inline: 14px 16px; gap: 8px; } /* icon side 2px less */
.play-glyph { transform: translateX(2px); }
```

Tailwind mapping: `size-4` / `size-5` / `size-6`; `[&_svg]:size-4 [&_svg]:shrink-0` on buttons; `ps-3.5 pe-4`; `rtl:-scale-x-100` on directional icons.

### Checks

- Grep the bundle for a second icon package or an icon font.
- Every `<svg>` has either `aria-hidden="true"` or `role="img"` plus a label.
- Every icon-only `<button>` has `aria-label` or a hidden label.
- Stroke width beside body text is 1.5–1.75px, measured with the inspector.
- Sizes are 16, 20, or 24, or `1em`; no 18 or 22.
- `dir="rtl"` pass: chevrons and send flip; checks and logos do not.
- Hover and disabled use tokens; grep `opacity-40` on icon buttons returns nothing.
- Nothing animates at rest; the Animations panel is empty on an idle screen.

### Do not

- Mix two icon families.
- Hardcode fills or pass colour props per icon.
- Keep a filled and an outline SVG as separate assets for one state pair.
- Size a 24-grid icon at 18px or 22px.
- Use a tooltip as the only name for an icon button.
- Animate an icon while nothing happens.
- Ship an icon font.

<!-- references/layout-and-spacing.md -->

## Layout and spacing

Use this when you are structuring a page or component, spacing or aligning controls, deciding what collapses at small sizes, handling safe areas or RTL, or auditing hierarchy.
Pair with `references/typography.md` for measure and `references/surfaces-and-depth.md` for radii and elevation.

### Rules

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

### Cheat sheet

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

### Code

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

### Checks

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

### Do not

- Use an 8-only grid and then invent 10 and 14 to make things fit.
- Add a divider where a gap already separates.
- Use `env(safe-area-inset-*)` as the whole padding.
- Pick 768 and 1024 because they are familiar.
- Hardcode a button width to fit English.
- Put a submit button at the bottom of a scrolling modal body.
- Let a card's inner radius equal its outer radius.

<!-- references/marketing-pages.md -->

## Marketing pages

Use this when building or reviewing a landing page, a product page, a pricing page, a launch post, or the OG image that represents any of them. Marketing pages are where generic defaults show fastest, because every visitor has seen a thousand of them.

### Rules

1. **No scroll-triggered entrances.** No fade-up, fade-in, or translateY on sections as they scroll into view. Why: it is the single most recognisable generic default, it delays content, and it fails reduced motion by default. Check: `grep -rn "whileInView\|IntersectionObserver\|data-aos\|animate-on-scroll"`; each hit is a finding.
2. **No scroll hijacking, no non-1:1 parallax, no auto-advancing carousels.** Scroll belongs to the reader. Parallax that moves at a different rate than the finger is a vestibular trigger. A carousel that advances on its own hides content from the person reading it. Check: scroll with the trackpad; the page moves exactly as far as your fingers did.
3. **One orchestrated moment beats scattered effects.** Spend the motion budget on a single hero sequence, gated to once per session with `sessionStorage`, and keep everything else still. Why: one considered moment reads as craft; ten small ones read as a template. Check: count animated elements above the fold; one sequence, or none.
4. **Spend your boldness in one place.** One display face, or one unusual layout, or one strong colour field. Not all three. Check: name the one bold decision in a sentence.
5. **Hover transitions on every card are a tell.** Cards that are not links do not lift. Cards that are links change one thing (colour or underline), not three. Check: hover every card; it moves only if it goes somewhere.
6. **Refuse the five generic clusters.** These read as machine-made because they are the statistical average of every template:
   - Cream near `#F4F1EA`, a high-contrast serif display, a terracotta accent near `#D97757`.
   - Near-black background plus one acid green or vermilion accent.
   - Broadsheet layout: hairline rules, zero border-radius, dense newspaper columns.
   - The SaaS card kit: identical rounded cards, one radius on everything, the same `rgba(0,0,0,.1)` shadow under each, gradient washes as decoration.
   - Template chrome: tracked-out ALL-CAPS eyebrow above every heading; meta joined with middle dots; headlines shaped as a WORD, a spaced em dash, then a fragment; tinted near-blacks (`#0B0B0B`, `#111`) posing as black; a mono face for every small label; an arrow glyph appended to link text.
   Check: hold the page against each cluster; if two or more traits match, redesign that part. A project that already owns one of these as its house style keeps it; the tell is choosing it by default.
7. **Three typographic tells.** Accenting one word in a headline with italic, bold, or colour; all caps for labels; a typographic label above content that did not need one. Check: remove each; if nothing is lost, it was a tell.
8. **Numbered markers only for sequences.** 01 / 02 / 03 on three unrelated features is decoration. Check: could the items be reordered without loss? Then drop the numbers.
9. **Type discipline.** Line length under 80ch (serifs may run slightly longer and need more line-height). One or two families; if two, clearly distinct. Headlines 3–8 words. `text-wrap: balance` on headings. Check: measure the widest paragraph.
10. **The CTA says exactly what happens.** "Start a free trial", "Book a demo", "Download for Mac". Never "Get started", "Learn more" alone, "Submit". Check: every CTA is a verb plus its object.
11. **Pricing is on the page.** If the price is knowable, it is visible. See `references/onboarding-and-pricing.md`.
12. **Performance is part of the design.** `fetchpriority="high"` on the LCP image, explicit `width` and `height` on every image, `font-display: swap` with `size-adjust` so nothing shifts, `content-visibility: auto` on below-fold sections, no layout shift on load. Check: Lighthouse CLS is 0; LCP under 2.5s on a throttled mobile.
13. **Mobile first-fold check.** On a 375px phone, the first screen shows the headline, one line of what it is, and the CTA, with no scroll. Check: screenshot at 375×667.
14. **Accessibility floor, without announcing it.** Keyboard focus visible, reduced motion respected, contrast passes, real headings in order. Do not put an "accessible" badge on the page. See `references/accessibility.md`.
15. **Two passes.** First, write a compact token plan: 4–6 named colours, the type roles, a one-sentence layout idea. Review that plan against the brief and against rule 6 before building. Then build. Then screenshot and review again at 375 and 1280. Why: genericness is cheapest to catch before the CSS exists. Check: the plan exists as a comment or a file.

### OG images

The unfurl is the first impression on Slack, iMessage, LinkedIn, and X, and it renders at 200px wide in a sidebar.

| Spec | Value |
|---|---|
| Master | 1200×630 (1.91:1); X large card 1200×675 |
| Safe centre | 1000×500; nothing critical within 100px of any edge |
| Headline | ≥ 80px at master, 3–8 words, one weight contrast |
| Subhead | ≥ 40px; labels ≥ 28px; body ≥ 22px; floor 16px |
| Words that survive | ~4–6 at 200px, 6–10 at 300px, 12–18 at 600px |
| Focal point | One. Brand colour is the background, not an accent |
| Colour space | sRGB only; wide gamut desaturates in feeds |
| Weight | Under 1MB; JPEG for photo, PNG for crisp text; no GIF |
| Text in image | Never the URL; never "Click here"; the unfurl is the CTA |
| Test | 200×105 and greyscale; centre-crop the outer 100px |
| Cache | `?v=2` on change; Slack and iMessage cache for days |

```html
<meta property="og:image" content="https://example.com/og.png?v=2">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="Plain-language description of the image">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://example.com/og.png?v=2">
```

### Cheat sheet

| Element | Default |
|---|---|
| Scroll-triggered motion | none |
| Hero sequence | one, ≤ 1.2s total, once per session |
| Section rhythm | 64–96px desktop, 48–64px mobile |
| Headline | 3–8 words, `text-wrap: balance`, negative tracking only above 28px |
| Measure | ≤ 80ch |
| CTA | verb + object, one primary per fold |
| Images | explicit dimensions, `fetchpriority="high"` on the first |
| Below fold | `content-visibility: auto` |
| Cards | lift only if they navigate |

### Code

```css
.hero-media { content-visibility: visible; }
.section { content-visibility: auto; contain-intrinsic-size: auto 600px; }

h1, h2 { text-wrap: balance; }
p { text-wrap: pretty; max-width: 65ch; }

/* Links change one thing */
a.card:hover { border-color: var(--ink-3); }
```

```html
<img src="/hero.jpg" width="1200" height="800" fetchpriority="high" alt="The dashboard showing this week's revenue">
```

```ts
if (!sessionStorage.getItem("hero-played")) {
  playHero();
  sessionStorage.setItem("hero-played", "1");
}
```

### Copy on marketing pages

| Instead of | Write |
|---|---|
| "We're thrilled to announce" | The thing, in one sentence |
| "Get started" | "Start a free trial" |
| "Learn more" (alone, three times) | "Read the pricing", "See how sync works" |
| "Revolutionary AI-powered platform" | What it does, for whom, in plain words |
| Emoji bullets in a feature list | Plain bullets, or no list |
| A headline with one word in italic | The same headline, all one weight |
| "Trusted by 10,000+ teams" with no names | Three real names, or nothing |

Active voice, sentence case, no filler. Each written element does exactly one job.

### Checks

- Scroll the page with DevTools Animations panel open; nothing fires except the once-per-session hero.
- Screenshot at 375×667: headline, one line, CTA, no scroll.
- Hold the page against the five clusters; note matches.
- Every CTA reads as verb + object.
- Lighthouse: CLS 0, LCP under 2.5s throttled.
- OG image at 200×105 and in greyscale; still says one thing.
- Keyboard pass and reduced-motion pass.

### Do not

- Animate sections into view on scroll.
- Auto-advance a carousel.
- Lift a card that is not a link.
- Put an arrow glyph after link text.
- Cap every heading with an ALL-CAPS eyebrow.
- Number things that are not a sequence.
- Print the URL on the OG image.
- Introduce a display face the project does not already own.

<!-- references/motion.md -->

## Motion and transitions

Use this when you add, review, or tune any transition, entrance, exit, hover, or state change on the web. It covers the discipline (which properties, which curves, how long) and the vocabulary (named tokens with jobs). Springs and gestures live in `references/springs-and-gestures.md`; scroll-linked motion in `references/scroll.md`.

### Rules

1. **Name every property you transition.** `transition: all` animates properties you did not intend (layout, colour on theme switch, `border-radius` on hover) and costs a style recalc on each. Write `transition: transform 150ms var(--ease), opacity 150ms var(--ease)`. Check: grep for `transition: all` and `transition-property: all`; both should return nothing. Tailwind's bare `transition` is a curated list (colors, opacity, shadow, transform), not `all`; `transition-transform` covers `transform, translate, scale, rotate`.
2. **Build a vocabulary, then refuse anything outside it.** Five to eight named tokens, each with a stated job, in one file. Add the line: "If a new animation does not fit one of these, the answer is usually don't." Check: every `transition` and `animate` in the codebase references a token, not a literal.
3. **Frequency decides motion.** Seen 100+ times a day: instant, or a colour change ≤ 150ms. Seen a few times a day: 150–250ms. Seen rarely (onboarding, a milestone, a first paint): the theatre. Check: list the three most frequent interactions; none should have a transform animation over 150ms.
4. **Entrances decelerate, exits accelerate.** Enter on an ease-out (`cubic-bezier(0.165, 0.84, 0.44, 1)` for small, `cubic-bezier(0.16, 1, 0.3, 1)` for large). Exit on `cubic-bezier(0.4, 0, 1, 1)` at about 0.65× the entrance duration, never with bounce. Check: exits are visibly shorter when replayed at 10% speed.
5. **Paired elements share timing.** Modal and backdrop, tooltip and arrow, drawer and scrim, a number and its bar: identical easing and duration, or the pair reads as two things. Check: the two `transition` declarations are the same token.
6. **Stagger by kind.** List items 30–40ms apart, cap around 8 (240ms total). Semantic chunks (title, body, actions) 80–100ms apart. First appearance only, never re-run on scroll into view. Check: item 9 onward has no delay.
7. **Skip entrance animation on page load for above-the-fold chrome.** Navigation, headers, and the first visible content should be present at first paint. Animate only what arrives after interaction or after data. Check: reload the page; nothing in the viewport moves before you touch it.
8. **Opacity and colour tween; transforms may spring.** A bouncing opacity is an artefact. Use a 100–200ms ease for opacity, background, colour, border colour. See `references/springs-and-gestures.md` for what springs.
9. **Loops act, rest, then ease home.** A demo or ambient loop does the thing, parks the payoff so it dwells, then eases back. It never snaps to the start. Check: watch two cycles; the reset is invisible.
10. **Reduced motion is opt-in.** Wrap motion in `@media (prefers-reduced-motion: no-preference)`. Where a global kill switch is unavoidable, use `0.01ms`, never `none`, so `animationend` and `transitionend` still fire. Replace travel and scale with crossfades; keep functional feedback. Check: toggle the OS setting; nothing slides, everything still changes state.
11. **Review at 10% speed.** Open the browser's Animations panel, set playback to 10%, and trigger each pair. Overshoot, mismatched pairs, and late stagger are obvious at that speed and invisible at 100%. Check: done before any motion PR merges.

### Cheat sheet

#### Easing ladder

| Name | Curve | Job |
|---|---|---|
| ease / micro | `cubic-bezier(0.2, 0, 0, 1)` | hover, colour, opacity, tiny state |
| out-quad | `cubic-bezier(0.25, 0.46, 0.45, 0.94)` | subtle enters |
| out-cubic | `cubic-bezier(0.215, 0.61, 0.355, 1)` | small enters |
| out-quart | `cubic-bezier(0.165, 0.84, 0.44, 1)` | default enter: dropdowns, tooltips, popovers |
| out-quint | `cubic-bezier(0.23, 1, 0.32, 1)` | medium surfaces |
| out-expo | `cubic-bezier(0.19, 1, 0.22, 1)` | large surfaces, page |
| enter (expo-ish) | `cubic-bezier(0.16, 1, 0.3, 1)` | modals, sheets, hero reveals |
| exit | `cubic-bezier(0.4, 0, 1, 1)` | every exit |
| in-out | `cubic-bezier(0.455, 0.03, 0.515, 0.955)` | on-screen moves (reorder, resize) |
| linear | `linear` | marquees, hold-to-confirm, progress |

Bigger surface, stronger curve. `ease-in` on an entering element is almost never right.

#### Durations

| Job | Duration |
|---|---|
| Hover, colour, opacity | 100–150ms |
| Micro state (checkbox, toggle, chip) | 120–180ms |
| Enter: dropdown, tooltip, popover | 150–250ms |
| Enter: modal, sheet, drawer | 250–300ms |
| Page or view transition | 300–400ms |
| Exit, anything | 0.65× the entrance, ≤ 200ms |

#### Enter and exit recipes

| | Transform | Opacity | Filter | Timing |
|---|---|---|---|---|
| Enter | `translateY(8–12px) → 0` (or `scale(0.95) → 1`) | 0 → 1 | `blur(4px) → 0` (optional; skip on lists > 20) | 200–300ms, out-quart or enter |
| Exit | `translateY(-8px)` (or `scale(0.97)`) | 1 → 0 | none | 150ms, exit |

Never animate from `scale(0)`. Start at 0.95.

#### Contextual icon swap (copy → check)

| Property | From | To |
|---|---|---|
| scale | 0.25 | 1 |
| opacity | 0 | 1 |
| filter | `blur(4px)` | `blur(0)` |
| transition | spring `{ duration: 0.3, bounce: 0 }` | bounce is always 0 |

Hold the check 1.5s, then swap back. CSS fallback: both icons in the DOM, one `position: absolute`, cross-fade over 300ms with `cubic-bezier(0.2, 0, 0, 1)`.

#### Motion library vs CSS

| Need | Use |
|---|---|
| Hover, focus, active, non-interruptible enter/exit | CSS transition with a token |
| Anything retriggerable mid-flight or continuing from a gesture | `motion/react` spring (velocity handoff) |
| Layout change (size, position, reorder) | `motion/react` `layout` |
| Shared element between routes | View Transitions API, or `layoutId` |
| Scroll-linked | `animation-timeline: scroll()` |
| Sequenced multi-element storyboard | `motion/react` with a stage integer |

`framer-motion` exports the same API; `import { motion } from "motion/react"` is the current package name.

### Code

Tokens, once, in one file:

```css
:root {
  --ease:       cubic-bezier(0.2, 0, 0, 1);    /* hover, colour, micro state */
  --ease-enter: cubic-bezier(0.16, 1, 0.3, 1); /* entrances, large surfaces */
  --ease-out-quart: cubic-bezier(0.165, 0.84, 0.44, 1); /* small entrances */
  --ease-exit:  cubic-bezier(0.4, 0, 1, 1);    /* every exit; accelerates away */
  --dur-micro:   120ms;
  --dur-ui:      200ms;
  --dur-overlay: 260ms;
  --dur-page:    340ms;
}
/* Springs live as --ease-<token> linear() strings with --dur-spring-<token> settle times; see assets/motion.css. */
/* If a new animation does not fit one of these, the answer is usually don't. */
```

A named-property transition (Tailwind alternative: `transition-[transform,background-color] duration-[var(--dur-micro)] ease-[var(--ease)]`):

```css
.button {
  transition: transform var(--dur-micro) var(--ease),
              background-color var(--dur-micro) var(--ease);
}
.button:active { transform: scale(0.97); }
```

Enter and exit as a pair, opt-in to motion:

```css
@media (prefers-reduced-motion: no-preference) {
  .panel[data-state="open"]  { animation: panel-in  var(--dur-ui) var(--ease-enter) both; }
  .panel[data-state="closed"] { animation: panel-out calc(var(--dur-ui) * 0.65) var(--ease-exit)  both; }
}
@keyframes panel-in  { from { opacity: 0; transform: translateY(8px);  filter: blur(4px); } }
@keyframes panel-out { to   { opacity: 0; transform: translateY(-8px); } }
```

Stagger without JavaScript (first appearance only, capped):

```css
.list > * { animation: rise var(--dur-ui) var(--ease-enter) both; animation-delay: calc(var(--i, 0) * 35ms); }
.list > :nth-child(n + 9) { animation-delay: 280ms; }
```

Set `style="--i: 3"` per item from the render loop.

The storyboard pattern for a sequenced moment. Timing lives in one object; the JSX reads from config objects, never literals:

```tsx
/* STORYBOARD (ms after trigger)
 *    0   waiting for mount
 *  120   card rises, scale 0.96 -> 1
 *  200   heading fades in
 *  320   rows rise, staggered 35ms
 *  520   action button fades in
 */
const TIMING = { card: 120, heading: 200, rows: 320, action: 520 };
const CARD = { fromScale: 0.96, spring: { type: "spring", visualDuration: 0.4, bounce: 0 } as const };
const ROWS = { stagger: 0.035, offsetY: 8 };

function Figure() {
  const [stage, setStage] = useState(0);
  useEffect(() => {
    const t = [
      setTimeout(() => setStage(1), TIMING.card),
      setTimeout(() => setStage(2), TIMING.heading),
      setTimeout(() => setStage(3), TIMING.rows),
      setTimeout(() => setStage(4), TIMING.action),
    ];
    return () => t.forEach(clearTimeout);
  }, []);
  return (
    <motion.div animate={{ opacity: stage >= 1 ? 1 : 0, scale: stage >= 1 ? 1 : CARD.fromScale }} transition={CARD.spring}>
      {rows.map((r, i) => (
        <motion.div key={r.id}
          animate={{ opacity: stage >= 3 ? 1 : 0, y: stage >= 3 ? 0 : ROWS.offsetY }}
          transition={{ duration: 0.2, ease: "easeOut", delay: i * ROWS.stagger }} />
      ))}
    </motion.div>
  );
}
```

One `stage` integer, one effect, one cleanup. Opacity tweens; scale springs.

Reduced-motion global fallback, only where per-element opt-in is impossible:

```css
@media (prefers-reduced-motion: reduce) {
  *, ::before, ::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### Checks

- `grep -rn "transition: all\|transition-property: all" src` returns nothing.
- Every duration and easing in the codebase resolves to a token.
- Replay each enter/exit pair at 10% in the Animations panel: exits shorter, no overshoot on exits, pairs move together.
- Reload: nothing above the fold animates in.
- Toggle reduced motion: state changes still happen, nothing travels.
- Count staggered items: the ninth has the same delay as the eighth.

### Do not

- Animate `height`, `width`, `top`, `left`, `margin`, or `padding`. Use `transform` and `grid-template-rows: 0fr → 1fr` for accordions.
- Put `will-change` on anything before you have seen a first-frame stutter. Never `will-change: all`.
- Add a hover transform to an element that does not navigate or open something.
- Fade-and-slide every section as it scrolls into view. See `references/marketing-pages.md`.
- Bounce an icon swap, an opacity, or an exit.
- Use `animation: none` as the reduced-motion switch; it breaks `animationend` listeners.

<!-- references/native-feel.md -->

## Native feel (opt-in)

**This is a style choice. Load only when the project wants to feel like a native iOS app.** Everything universal lives in the neutral references; this file adds the iOS-specific layer on top. If the project's design contract does not say "feels like a native app", close this file.

Use this when building a PWA, an app-like web product, or a companion web view that should be indistinguishable from SwiftUI. Do not use it to make a marketing site or a data tool "feel iOS".

### Rules

1. **Body is 17px, not 16.** The whole scale shifts with it (cheat sheet). Why: every web default is 16; the one pixel is subliminal and it is most of the difference. Check: computed `font-size` on `<p>` is 17px.
2. **Tracking is size-specific and negative above 20px.** Display −0.022em, title −0.019em, body −0.011em, caption 0, all-caps micro +0.006em. `font-optical-sizing: auto`. Why: SF Pro Display is tighter than SF Pro Text; browsers render everything at 0. Check: headlines carry negative `letter-spacing`.
3. **`-apple-system` first in the stack.** `system-ui` alone resolves inconsistently. `ui-rounded` gives SF Pro Rounded for glanceable numerals. Check: the stack begins `-apple-system, BlinkMacSystemFont`.
4. **Labels are one ink with four alphas.** Primary 1, secondary `rgb(60 60 67 / 0.6)`, tertiary `0.3`, quaternary `0.18`; dark uses `rgb(235 235 245 / …)`. Separators `rgb(60 60 67 / 0.29)`. Check: no secondary text is a flat grey hex.
5. **Backgrounds come in three levels.** Light: `#FFFFFF`, `#F2F2F7`, `#FFFFFF`. Dark: `#000000` or `#1C1C1E` as the base, then `#1C1C1E`, `#2C2C2E`. True black is a written decision in the design contract, not a default; if chosen, elevation comes from the level ladder, never from shadows. See `references/theming-and-dark-mode.md`.
6. **Elevation is three layers with a half-pixel ring.** `0 0 0 0.5px rgb(0 0 0 / 0.04), 0 1px 2px rgb(0 0 0 / 0.04), 0 8px 24px -4px rgb(0 0 0 / 0.08)`. The ring does more than the blur. Check: no single-shadow cards.
7. **Materials need `saturate(180%)`.** ultraThin `blur(20px)` at white 0.30; thin `30px` / 0.50; regular `40px` / 0.68; thick `50px` / 0.80; dark regular `rgb(28 28 30 / 0.68)`. Two or three per screen, static, on chrome only. Never on a scrolling element. Check: every `backdrop-filter` includes `saturate`.
8. **Sheets have physics.** Backdrop tween 250ms ease-out; sheet springs in (`smooth`); contents arrive at +80ms with a 30ms stagger; the source view scales to 0.94 and rounds to 14px behind it. Dismiss on velocity > 500px/s or offset > 50%; an upward flick always cancels. Rubber-band past the edge with `c = 0.55`. Scroll-versus-drag arbitration: at scrollTop 0 a downward drag moves the sheet, otherwise the content scrolls. Check: flick from 10% down; it dismisses.
9. **Navigation pushes with parallax and an interruptible edge swipe.** The outgoing view slides to −30%; the incoming from 100%; both on the same spring. Back-swipe tracks the finger 1:1 and commits on velocity sign. Use the View Transitions API or Motion `layoutId` for shared elements; keep titles in a surviving parent. Check: start a back swipe, reverse, release; it returns smoothly with no jump.
10. **Grouped lists look grouped.** 0.5px separators at `rgb(60 60 67 / 0.29)` inset to the content start (16px), last row no separator, press state fills edge to edge with `rgb(0 0 0 / 0.06)` as an overlay, chevrons 14px at 30%, groups on a 10px radius over the secondary background. Check: separators are half a pixel on a retina screen.
11. **Press is a highlight, not a colour change.** Overlay `rgb(0 0 0 / 0.06)` (light) on down; scale 0.97 for large surfaces, 0.94 for small icons, never below 0.9. Check: press a list row; the whole row tints.
12. **Squircles only where the radius is load-bearing.** `corner-shape: superellipse(4)` (Chrome 139+) or a clip-path for radius > 20px on hero cards and icons. Below that nobody can tell. Check: grep `corner-shape`; every use is above 20px.
13. **Liquid Glass, honestly.** Real refraction needs `backdrop-filter: url(#svg-filter)` with a displacement map, and only Chromium supports it; Safari and Firefox get nothing. Ship blur + saturate + an inset specular highlight first; it is 90% of the effect for 2% of the cost. Add refraction only for a hero element on a Chromium-first audience, and animate `scale` on the filter, never the element size. Check: the `@supports` fallback exists and looks finished on Safari.
14. **Haptics are a hack on iOS Safari.** `navigator.vibrate` does not exist there. The `<input type="checkbox" switch>` trick fires the system switch haptic when clicked inside a user gesture; feature-detect and treat it as a bonus. Android gets `vibrate` on `pointerdown` (8 / 15 / 25ms). See `references/haptics-and-sound.md`.
15. **Standalone mode gets the PWA meta.** `apple-touch-icon`, `apple-mobile-web-app-capable`, `apple-mobile-web-app-status-bar-style: black-translucent`, per-scheme `theme-color`, and `overscroll-behavior: none` only inside `display-mode: standalone`. See `references/touch-and-mobile.md`.
16. **Momentum is the platform's.** iOS decelerates at 0.998 per millisecond. Do not build a custom scroller; use native scroll with `scroll-snap` where paging is wanted. Check: no scroll library in the bundle.

### What this file does not repeat

Everything below is universal and lives in the neutral references. Apply it first; layer this file on top.

| Topic | Reference |
|---|---|
| Spring tokens, exits, stagger | `references/motion.md`, `references/springs-and-gestures.md` |
| Base layer, safe areas, keyboard, `dvh` | `references/touch-and-mobile.md` |
| Focus, roving tabindex, reduced motion | `references/accessibility.md` |
| Loading ladder, optimistic ghosts | `references/states.md` |
| Icon stroke and states | `references/icons.md` |
| OKLCH tokens, theme switch | `references/color.md`, `references/theming-and-dark-mode.md` |

### Cheat sheet: the iOS type scale in px

| Role | Size | Weight | Tracking | Line height |
|---|---|---|---|---|
| Large Title | 34 | 700 | −0.026em | 1.21 |
| Title 1 | 28 | 700 | −0.022em | 1.21 |
| Title 2 | 22 | 700 | −0.019em | 1.27 |
| Title 3 | 20 | 600 | −0.019em | 1.25 |
| Headline | 17 | 600 | −0.011em | 1.29 |
| Body | 17 | 400 | −0.011em | 1.29 |
| Callout | 16 | 400 | −0.009em | 1.31 |
| Subhead | 15 | 400 | −0.006em | 1.33 |
| Footnote | 13 | 400 | 0 | 1.38 |
| Caption 1 | 12 | 400 | 0 | 1.33 |
| Caption 2 | 11 | 400 | +0.006em | 1.18 |

### Cheat sheet: springs and constants

| Thing | Value |
|---|---|
| Sheet in | Motion `{ type: "spring", visualDuration: 0.4, bounce: 0 }` |
| Sheet out | `visualDuration: 0.26, bounce: 0` |
| Dismiss | velocity > 500px/s, or offset > 0.5 × height; upward flick cancels |
| Rubber-band | `(1 − 1 / (offset / dimension × 0.55 + 1)) × dimension` |
| Nav push parallax | outgoing `translateX(-30%)` |
| Source behind sheet | scale 0.94, radius 14px |
| Deceleration | 0.998 / ms (do not reimplement) |
| Press overlay | `rgb(0 0 0 / 0.06)` |

### Code

```css
@theme {
  --font-sans: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI Variable", "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  --font-rounded: ui-rounded, "SF Pro Rounded", var(--font-sans);
}
:root { font-optical-sizing: auto; }
body { font-size: 17px; line-height: 1.29; letter-spacing: -0.011em; }
.text-display { font-size: 28px; font-weight: 700; letter-spacing: -0.022em; line-height: 1.21; }

.material-regular { backdrop-filter: blur(40px) saturate(180%); background: rgb(255 255 255 / 0.68); }
.dark .material-regular { background: rgb(28 28 30 / 0.68); }

.elevated {
  box-shadow: 0 0 0 0.5px rgb(0 0 0 / 0.04), 0 1px 2px rgb(0 0 0 / 0.04), 0 8px 24px -4px rgb(0 0 0 / 0.08);
}

.row + .row { border-top: 0.5px solid rgb(60 60 67 / 0.29); margin-inline-start: 16px; }
.row:active::after { content: ""; position: absolute; inset: 0; background: rgb(0 0 0 / 0.06); }

.glass {
  backdrop-filter: blur(24px) saturate(180%);
  background: rgb(255 255 255 / 0.2);
  box-shadow: inset 1px 1px 0 rgb(255 255 255 / 0.6);
}
@supports (backdrop-filter: url(#glass)) { .glass { backdrop-filter: url(#glass); } }
```

```ts
const DISMISS_DISTANCE = 0.5;
const DISMISS_VELOCITY = 500;
export function shouldDismiss(offsetY: number, velocityY: number, height: number) {
  if (velocityY > DISMISS_VELOCITY) return true;
  if (velocityY < -DISMISS_VELOCITY) return false;
  return offsetY > height * DISMISS_DISTANCE;
}
export function rubberBand(offset: number, dimension: number, c = 0.55) {
  return (1 - 1 / ((offset / dimension) * c + 1)) * dimension;
}
```

### Checks

- Computed body size is 17px; headlines have negative tracking.
- Every `backdrop-filter` has `saturate(180%)` and sits on static chrome.
- Sheet dismisses on a fast flick from any position; upward flick cancels.
- Back swipe reverses without a jump.
- Separators render at half a pixel on a 2x screen.
- Safari shows a finished glass fallback.
- No scroll library in the bundle.

### Do not

- Load this file for a project whose contract does not say "native feel".
- Use `system-ui` alone.
- Ship glass refraction without the Safari fallback.
- Set true black without writing the decision down.
- Reimplement momentum, rubber-banding, or the edge swipe from scratch when Vaul, Base UI, or the View Transitions API already does it.

<!-- references/onboarding-and-pricing.md -->

## Onboarding and pricing

Use this when you are building or reviewing a first-run flow, a sign-up, a trial, a pricing page, or an in-app upgrade wall. The first thirty seconds decide whether someone stays; the pricing page decides whether they pay without feeling tricked.

### Rules: onboarding

1. **Value in three seconds.** The first screen shows the thing the product does, with the user's own input or a real preview, before any form. Why: people leave when the first thing they see is work. Check: cover the CTA with your thumb; can a stranger say what the product does from what remains?
2. **Four or five steps, one purpose each.** Value moment, the one input, the payoff preview, a permission or connection step only if the very next thing needs it, handoff. Why: every extra screen is a place to leave. Check: name each step's single job in three words. If a screen does two jobs, split it or cut it.
3. **Sign-in and the paywall are not steps.** Guest-first. Ask for an account when something needs saving across devices; ask for money after a value moment. Why: both are exits disguised as entrances. Check: can a new user reach the payoff with zero fields filled?
4. **The payoff preview uses real components.** The same card, chart, or list the product ships, filled with the user's input. Why: a mockup promises; the real component proves. Check: grep the onboarding directory for components not imported from the product's own library.
5. **Progress is dots, never a bar.** A bar reads as loading. Dots read as position in a short, finite journey. The active dot is a capsule 2.5–3× the width of the others, same height, and it glides to the new index over ~300ms. Inactive dots sit at ~25% of the ink. Do not count the permission step or the celebration as dots. Do not show dots on a one-screen flow. Why: five dots that only ever reach three is a small broken promise. Check: number of dots equals number of screens the user can actually stand on.
6. **The CTA never moves.** Pin it a fixed distance from the bottom safe area; let body copy grow upward. Why: a button that jumps between screens is the classic "made by nobody in particular" tell. Check: screenshot two consecutive steps and overlay them.
7. **Directional transitions.** Forward enters from the trailing edge; back returns to it. Use one curve for the whole flow and reserve any bounce for the final handoff. Why: direction is how people keep their place. Check: press back on step three; the previous screen must arrive from the side it left to.
8. **Intro animations run once per session.** Gate with `sessionStorage`, not `localStorage`. Why: a returning tab should not replay the show; a returning day may. Check: reload; the intro does not replay. Open a new window; it does.
9. **Ask for feedback or a review only after a value moment.** Never on launch, never on a timer. Check: find the trigger; it must be a completed action, not a count of sessions.
10. **Every step has its error, loading, and empty state.** A failed connection on step four must not strand the user. Check: kill the network on each step.

### Rules: pricing and paywalls

11. **State the price plainly.** Never "Contact us" for a price the product knows. Why: a hidden price reads as a trap. Check: the number is on the page without a click.
12. **Show the total and the per-month equivalent.** "$79.99 per year, about $6.67 a month." Why: showing only the flattering number is anchoring; showing both is honesty. Check: both figures visible, both computed from the same source of truth, never hand-typed.
13. **Free plus one paid tier.** Or annual plus monthly. Never hide or grey out monthly to make annual look better. Why: three tiers exist to make one look right by comparison. Check: count the columns; every visible option must be a real choice.
14. **Annual as default is fine. Charm pricing is fine.** $4.99 is a convention people read fluently, not a trick. A preselected annual with a visible, equally styled monthly is honest. Check: monthly has the same contrast and hit area as annual.
15. **No fake anchors, no countdowns, no "only 3 left".** Why: urgency that is manufactured teaches people the product lies. Check: any timer must correspond to a real expiry that the code enforces.
16. **Feature table: six rows or fewer, one highlighted difference.** Why: nobody compares twelve rows; they look for the one thing they need. Check: remove rows until the difference between tiers fits in one sentence.
17. **Close is visible from frame one.** Full-size hit area, same contrast as any other control. Why: an invisible or delayed X is the single most reported dark pattern. Check: screenshot at t=0; the Close must be there at full opacity.
18. **Restore, terms, and privacy are always present.** A quiet row under the CTA. Check: three links, real destinations.
19. **Trial copy names the date and the price.** "Free until 14 March, then $79.99 a year. Cancel any time in Settings." Why: the only surprise allowed is a good one. Check: the date is computed, the price is the live price, the cancel path is real.
20. **Placement, ranked.** After a value moment (best) > at a metered limit > in onboarding only after a value preview > cold landing (worst). Never to an existing subscriber. Re-prompt on the next value moment, never on a timer or every launch. Check: find every call site of the paywall; each must be preceded by a completed action or a hit limit.
21. **The honesty test.** Would this still work if the person understood it completely? If it only works while they are confused or rushed, it is a dark pattern. Check: read the page aloud to a colleague who has not seen it.
22. **Nothing on a paywall pulses, throbs, glows, or counts down.** Calm converts and keeps. Check: `grep -rn "animation:" paywall/` returns only entrances and exits.

### Cheat sheet

| Element | Value |
|---|---|
| Steps | 4–5, one job each |
| Active dot | 2.5–3× width, glides ~300ms, others at 25% ink |
| CTA | pinned, fixed distance from bottom safe area |
| Step transition | 250–350ms ease-out-quart, directional |
| Intro replay gate | `sessionStorage` |
| Tiers | free + one paid, or annual + monthly |
| Price display | total and per-month, both computed |
| Feature rows | ≤ 6, one highlighted difference |
| Close | visible from frame one, ≥ 44px |
| Trial copy | date + price + cancel path |
| Re-prompt | next value moment, never a timer |

### Code

Dots that glide (CSS only, no library):

```css
.dots { display: flex; gap: 6px; }
.dot {
  width: 6px; height: 6px; border-radius: 999px;
  background: var(--ink); opacity: 0.25;
  transition: width 300ms cubic-bezier(0.165, 0.84, 0.44, 1), opacity 200ms ease;
}
.dot[aria-current="step"] { width: 18px; opacity: 1; }
```

```tsx
<div className="dots" role="group" aria-label={`Step ${i + 1} of ${total}`}>
  {steps.map((_, n) => <span key={n} className="dot" aria-hidden="true" {...(n === i && { "aria-current": "step" })} />)}
</div>
```

Pinned CTA with a growing body:

```css
.step { display: grid; grid-template-rows: 1fr auto; min-height: 100svh; }
.step-body { overflow-y: auto; padding: 24px; }
.step-cta { padding: 16px 24px calc(16px + env(safe-area-inset-bottom, 0px)); }
```

Once-per-session intro:

```ts
const seen = sessionStorage.getItem("intro");
if (!seen) { playIntro(); sessionStorage.setItem("intro", "1"); }
```

Price derived once:

```ts
const yearly = plan.priceCents / 100;
const monthlyEquivalent = yearly / 12;
// render: `${fmt(yearly)} per year, about ${fmt(monthlyEquivalent)} a month`
```


### Copy that holds up

| Instead of | Write |
|---|---|
| "Get started!" | "Create your first project" |
| "Unlock premium" | "Continue with Pro" |
| "Are you sure you want to skip?" | "Skip for now" |
| "Best value" badge on a greyed monthly | Two equal options, annual preselected |
| "Only 2 hours left" (no real expiry) | Nothing, or the real expiry date |
| "Free trial" | "Free until 14 March, then $79.99 a year" |
| "Contact sales" for a known price | The price |
| "Upgrade now" on launch | The same wall after the third completed task |

### Checks

- Walk the flow with the network throttled to 3G; every step still has something to look at within 300ms.
- Overlay screenshots of consecutive steps; the CTA does not move by a pixel.
- Count dots; count screens a user can stand on; they match.
- On the paywall, take a screenshot at t=0; Close is there.
- Tab through the paywall; the order is headline, options, CTA, quiet row.
- Grep the paywall for `setInterval`, `countdown`, `animation:`; justify each hit in writing.
- Read the trial copy; it names a date and the live price.

### Do not

- Put a form on the first screen.
- Use a progress bar for a finite flow.
- Count the celebration as a step.
- Show the paywall on landing, on launch, or to someone who already pays.
- Hide monthly, grey monthly, or make monthly a smaller hit target.
- Add a countdown that the server does not enforce.
- Animate anything on a paywall except its entrance and exit.

<!-- references/overlays.md -->

## Overlays

Use this when you are building or reviewing anything that floats above the page: modals, sheets and drawers, popovers and menus, tooltips, toasts, confirmation dialogs.
The project's overlay library is fine; these rules apply on top of Vaul, Base UI, Radix, or a hand-rolled `<dialog>`.

### Rules

1. **Paired elements share easing and duration.** Modal and backdrop, tooltip and arrow, drawer and scrim move as one object. Two curves on one gesture read as two things. Check: replay at 10% speed; nothing lags its partner.
2. **Exits are shorter and accelerate.** 0.65× the entrance, `cubic-bezier(0.4, 0, 1, 1)`, no bounce. Sometimes the right exit is none: remove immediately when the user is already looking elsewhere. Check: close feels faster than open.
3. **Use `<dialog>` with `showModal()`.** You get the focus trap, `inert` on everything else, Escape, and the top layer for free. Check: Tab never leaves the modal; Escape closes it.
4. **A hand-rolled portal owes you the three things `<dialog>` gave you free.** `createPortal` with `role="dialog"` is the common case in React and it is usually 90% right, which is why the missing 10% survives review. You owe: `aria-modal="true"` on the panel, `inert` on the app root while it is open and removed after, and `document.activeElement` stored before you open and refocused on close. Of those, `aria-modal` is the one to check first: without it you have not merely failed to trap focus, you have actively told assistive technology the background is still available while it is covered. That is a worse failure than no trap at all, because it is a lie rather than an omission. Check: with the overlay open, run the screen reader's next-item command past the last control; you should not reach the page underneath.
5. **Focus the least destructive action on destructive confirms.** The default focus in "Delete project?" is Cancel. Enter should never delete. Check: open the confirm, press Enter, nothing is lost.
6. **Return focus to the trigger on close.** Otherwise keyboard users land at the top of the document. Check: close with Escape; the opening button has the ring.
7. **`overscroll-behavior: contain` inside every scrolling overlay.** Reaching the end of a sheet's content must not scroll the page behind it. Check: scroll to the bottom of the sheet and keep going.
8. **Lock page scroll without `position: fixed` on body.** `html { overflow: hidden; scrollbar-gutter: stable }` while open, so the layout does not jump by the scrollbar width and iOS does not lose its scroll position. Check: open and close a modal; the page has not moved.
9. **Escape closes what opened last.** Tooltip, then menu, then dialog. One press, one layer. Check: open a menu inside a modal, press Escape twice.
10. **Popovers grow from their trigger.** `transform-origin` at the trigger's edge; scale 0.95 → 1 plus opacity, 150–200ms, ease-out-quart. Flip placement near viewport edges. Check: the popover appears to come out of the button.
11. **Submenus get a diagonal safe area.** A triangle (`clip-path: polygon(0 0, 100% 0, 100% 100%)`) over the gap so the cursor can travel diagonally without the submenu closing. Check: move the cursor from the parent item to the far corner of the submenu.
12. **Sheets arrive as containers with contents inside.** Backdrop: opacity tween 250ms ease-out at t=0. Panel: `y: 100% → 0` on the `smooth` spring at t=0. Contents: fade and rise at t=80ms with a 30ms stagger. The 80ms offset is why native sheets feel like they carry things. Check: contents never lead the panel.
13. **Sheets dismiss on velocity.** Down-flick over 500px/s dismisses regardless of position; otherwise over 50% of height. An upward flick always cancels, even below the threshold. Velocity beats position. Check: a short fast flick closes it; a long slow drag under half snaps back.
14. **Pad sheet contents for the safe area, not the sheet's position.** `padding-bottom: calc(16px + env(safe-area-inset-bottom))` on the content. The sheet itself sits at `bottom: 0`. Check: on a phone with a home indicator the last row is fully visible.
15. **The source view may recede.** Scaling the page to 0.94 with a 14px radius behind a full sheet is a legitimate depth cue. Only for full-height sheets. Check: never combined with a half sheet.
16. **Stacked overlays differ in height by 25% or more.** Two same-height sheets read as one sheet that swapped content. Check: measure both.
17. **Toasts: 5s floor, pause on hover and focus, persist when they carry an action or an error.** A toast holding the only Undo that vanishes on a timer is data loss on a schedule. Check: hover a toast; the timer stops.
18. **One toast visible.** Queue the rest. A stack of toasts is a log, not feedback. Check: fire three; one shows.
19. **Toasts are `role="status"`, never focused.** Bottom-centre on mobile, top-right on desktop, or the project's own corner used consistently. Check: screen reader announces without moving focus.
20. **Contextual outcomes go inline, not in a toast.** A field error belongs on the field; a saved row shows saved on the row. Toasts are for minor, reversible, global outcomes ("Archived. Undo"). Check: could the person be looking somewhere else when this appears? If not, do not toast it.
21. **Confirmation dialogs name the noun.** "Delete this project?" with "Delete project" and "Cancel". Never "Are you sure?" with OK. Check: read only the buttons; you know what happens.
22. **`position: fixed` breaks inside a transformed ancestor.** A parent with `transform`, `filter`, or `will-change: transform` becomes the containing block. Render overlays in a portal at the document root. Check: open the overlay inside an animated card.
23. **Reduced motion: crossfade.** Sheets and modals fade in place, 150–200ms. Keep the backdrop. Check: enable Reduce Motion; nothing slides.

### Cheat sheet

| Overlay | Enter | Exit | Focus on open | Dismiss |
|---|---|---|---|---|
| Modal | 200–300ms ease-out-expo, scale 0.96 → 1 + opacity; backdrop same duration | 0.65×, accelerate | first field, or least-destructive action | Escape, backdrop click, Close |
| Sheet / drawer | `smooth` spring on `y`; backdrop 250ms; contents +80ms, stagger 30ms | `exitOf(smooth)` | first field after animation (~350ms) | drag > 50% or > 500px/s; up-flick cancels; Escape |
| Popover / menu | 150–200ms from trigger origin | 100–150ms | first item (menu) or none (popover) | Escape returns to trigger; outside click |
| Tooltip | 150ms after 200ms delay; instant when warm | instant | never | pointer leave, Escape |
| Toast | 200ms rise + fade | 150ms | never | 5s floor; pause on hover; persist with action or error |

| z-index | Value |
|---|---|
| dropdown | 100 |
| sticky | 150 |
| overlay / modal | 200 |
| popover | 300 |
| toast | 400 |

Never 9999. Prefer the top layer (`<dialog>`, `popover` attribute) where it exists.

### Code

```tsx
// Modal with <dialog>: trap, inert, Escape, top layer for free.
export function Modal({ open, onClose, children }: Props) {
  const ref = useRef<HTMLDialogElement>(null);
  const trigger = useRef<HTMLElement | null>(null);
  useEffect(() => {
    const d = ref.current!;
    if (open && !d.open) {
      trigger.current = document.activeElement as HTMLElement;
      d.showModal();
      document.documentElement.classList.add("scroll-locked");
    }
    if (!open && d.open) {
      d.close();
      document.documentElement.classList.remove("scroll-locked");
      trigger.current?.focus();
    }
  }, [open]);
  return (
    <dialog ref={ref} className="modal" onCancel={(e) => { e.preventDefault(); onClose(); }}
      onClick={(e) => { if (e.target === ref.current) onClose(); }}>
      <div className="modal-panel">{children}</div>
    </dialog>
  );
}
```

```tsx
// If you cannot use <dialog>: aria-modal, inert on the root, focus restored.
export function PortalModal({ open, onClose, children }: Props) {
  const trigger = useRef<HTMLElement | null>(null);
  useEffect(() => {
    if (!open) return;
    trigger.current = document.activeElement as HTMLElement;
    const root = document.getElementById("app-root")!;
    root.inert = true;
    document.documentElement.classList.add("scroll-locked");
    return () => {
      root.inert = false;
      document.documentElement.classList.remove("scroll-locked");
      // Restore after the overlay has gone, or focus lands on a dying node.
      requestAnimationFrame(() => trigger.current?.focus());
    };
  }, [open]);
  if (!open) return null;
  return createPortal(
    <div className="scrim" onClick={onClose}>
      <div role="dialog" aria-modal="true" aria-labelledby="t"
           className="modal-panel" onClick={(e) => e.stopPropagation()}>
        {children}
      </div>
    </div>,
    document.body,
  );
}
```

```css
html.scroll-locked { overflow: hidden; scrollbar-gutter: stable; }

.modal::backdrop { background: rgb(0 0 0 / 0.4); animation: fade 240ms var(--ease-enter); }
.modal[open] .modal-panel { animation: modal-in 240ms var(--ease-enter); }
@keyframes fade { from { opacity: 0 } }
@keyframes modal-in { from { opacity: 0; transform: scale(0.96) } }
.modal-panel { overscroll-behavior: contain; max-height: 85dvh; overflow: auto; }

/* exit: shorter, accelerating */
.modal[data-closing] .modal-panel { animation: modal-out 160ms var(--ease-exit) forwards; }
@keyframes modal-out { to { opacity: 0; transform: scale(0.98) } }

@media (prefers-reduced-motion: reduce) {
  .modal[open] .modal-panel, .modal[data-closing] .modal-panel { animation: fade 180ms ease; }
}
```

```tsx
// Sheet dismissal predicate: velocity beats position.
const DISMISS_VELOCITY = 500; // px/s
const DISMISS_DISTANCE = 0.5; // of sheet height
export function shouldDismiss(offsetY: number, velocityY: number, height: number) {
  if (velocityY < -DISMISS_VELOCITY / 2) return false;  // upward flick always cancels
  if (velocityY > DISMISS_VELOCITY) return true;
  return offsetY > height * DISMISS_DISTANCE;
}
```

```tsx
// Sheet choreography with Motion: panel at t=0, contents at t=0.08, stagger 0.03.
<motion.div className="backdrop" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.25, ease: "easeOut" }} />
<motion.div className="sheet" initial={{ y: "100%" }} animate={{ y: 0 }} exit={{ y: "100%" }} transition={SPRING.smooth}>
  <motion.div initial="hidden" animate="show" variants={{ show: { transition: { delayChildren: 0.08, staggerChildren: 0.03 } } }}>
    {rows.map((r) => <motion.div key={r.id} variants={{ hidden: { opacity: 0, y: 8 }, show: { opacity: 1, y: 0 } }} />)}
  </motion.div>
</motion.div>
```

```css
/* submenu safe area so the cursor can travel diagonally */
.submenu::before {
  content: ""; position: absolute; inset: 0 100% 0 auto; width: 24px;
  clip-path: polygon(0 0, 100% 0, 100% 100%);
}

/* toast */
.toast { position: fixed; inset-block-end: calc(16px + env(safe-area-inset-bottom)); inset-inline: 0; margin-inline: auto; width: max-content; z-index: 400; }
@media (min-width: 768px) { .toast { inset-block-end: auto; inset-block-start: 16px; inset-inline: auto 16px; margin: 0; } }
```

```ts
// Toast timer: 5s floor, pauses on hover/focus, persists if it has an action.
function schedule(toast: Toast) {
  if (toast.action || toast.kind === "error") return;
  let remaining = Math.max(5000, toast.duration ?? 5000);
  let started = Date.now();
  let t = setTimeout(dismiss, remaining);
  toast.el.addEventListener("pointerenter", () => { clearTimeout(t); remaining -= Date.now() - started; });
  toast.el.addEventListener("pointerleave", () => { started = Date.now(); t = setTimeout(dismiss, remaining); });
  toast.el.addEventListener("focusin", () => clearTimeout(t));
}
```

### Checks

- Open each overlay; Tab stays inside; Escape closes; focus returns to the trigger.
- Open a destructive confirm and press Enter; nothing is deleted.
- Scroll to the end of a sheet and keep scrolling; the page behind does not move.
- Open and close a modal; the page has not shifted by a scrollbar width.
- Flick a sheet down fast from the top; it closes. Drag it slowly to 40% and release; it returns.
- Fire three toasts; one shows, two queue. Hover it; the timer stops.
- Open an overlay from inside an animated card; it is not clipped or misplaced.
- Enable Reduce Motion; every overlay fades in place.

### Do not

- Ship `role="dialog"` without `aria-modal="true"`; it tells assistive tech the background is reachable while it is not.
- Leave focus where it was when an overlay closes.

- Animate the backdrop and the panel on different curves or durations.
- Put the only Undo in a toast that expires.
- Focus the destructive action by default.
- Lock scroll with `position: fixed` on `body`.
- Render overlays inside a transformed parent.
- Show a field error in a toast.
- Use `z-index: 9999`.
- Stack two sheets of the same height.

See `references/buttons-and-controls.md` for the buttons inside, `references/springs-and-gestures.md` for drag physics, `references/accessibility.md` for focus and announcement rules.

<!-- references/performance.md -->

## Performance as a design property

Use this when an interface feels heavy, late, or jumpy, and when you review anything that animates, loads, or lists. Speed is felt before it is measured; a polished interface responds within the frame. Motion curves live in `references/motion.md`; scroll containers in `references/scroll.md`.

### Rules

1. **Respond within 100ms, settle within 200ms.** Any click or tap must produce visible change within 100ms; Interaction to Next Paint (INP) stays under 200ms, ideally under 100. On a 120Hz display a frame is 8.3ms, not 16. Check: the Performance panel shows the first paint after input inside 100ms on the primary path.
2. **No layout shift, ever.** Reserve every box: `width` and `height` (or `aspect-ratio`) on images and embeds, skeletons at final dimensions, loading buttons that lock their width, `font-variant-numeric: tabular-nums` on changing numbers, `size-adjust` on the fallback font so the swap does not reflow. Check: CLS is 0 in the Performance panel's Layout Shift track during load, font swap, data arrival, and button loading.
3. **Know the frame killers, in order.** (1) `backdrop-filter` on an element that scrolls or animates. (2) Animating layout properties (`height`, `width`, `top`, `left`, `margin`). (3) A large blurred `box-shadow` on an animated element. (4) React re-renders during a gesture. (5) Unbounded lists. Fix in that order. Check: the Performance panel's flame chart shows no purple layout bars during an animation.
4. **`will-change` is a last resort, not a prefix.** Only `transform`, `opacity`, or `filter`; only on an element you have watched stutter on its first frame; never `all`. Each promoted layer costs memory and can blur text. Check: `grep -rn will-change src` returns a handful of lines, each with a comment naming the stutter it fixed.
5. **Never animate blur above 20px.** Static `backdrop-filter: blur(40px)` on a fixed header is fine. Animating blur, or blurring something that moves, is the most expensive thing a page can do in Safari. Check: any `blur()` inside `@keyframes` or a transition is ≤ 20px.
6. **Make long content cheap before making it virtual.** `content-visibility: auto; contain-intrinsic-size: auto 72px` on list rows skips rendering off-screen rows in one line and gets most of the win. Virtualise past ~100 rows or when rows are heavy (images, charts). Check: a 500-row list scrolls at frame rate; DevTools Rendering shows off-screen rows unpainted.
7. **Prefetch on `pointerdown`, not `click`.** The gap between press and release is 100–150ms of free time. Prefetch the route or data on `pointerdown` (or `mouseenter` on desktop). Mark the largest above-the-fold image `fetchpriority="high"` and never lazy-load it. Check: the Network panel shows the route request starting before the click event.
8. **Switch themes in one frame.** Add a `.theme-switching` class that disables transitions, flip the theme attribute, remove the class after two nested `requestAnimationFrame`s, with a 120ms `setTimeout` backstop because rAF does not fire in a background tab. Without it every control cross-fades its own colours on its own curve and the switch reads as a ripple. Check: toggle the theme; everything changes in the same frame.
9. **Freeze timers when the tab is hidden.** Ambient loops, countdowns, and polling pause on `visibilitychange` and resume on return, so the page does not burn battery in the background and does not jump on return. Check: hide the tab for a minute; on return nothing catches up in a burst.
10. **Debounce search at 300ms; throttle scroll and resize with rAF.** 300ms is under the threshold where typing feels laggy and over the threshold where every keystroke hits the network. Check: typing five characters fast produces one request.
11. **Images arrive, they do not pop.** Reserve the box with `aspect-ratio`, show a blurred placeholder (blurhash or a 20px-wide inline version), and fade the real image in over ~320ms once decoded. Check: no image causes shift; no image flashes from blank to full.
12. **Intro animation plays once per session.** Gate first-visit theatre on `sessionStorage`, not `localStorage`, so a returning user sees it again tomorrow but not on every route change today. Check: navigate away and back; the intro does not replay.

### Cheat sheet

| Budget | Value |
|---|---|
| Input to visible change | < 100ms |
| INP | < 200ms, ideally < 100ms |
| Frame at 120Hz | 8.3ms |
| CLS | 0 on load, font swap, data, button loading |
| Spinner delay | 300ms |
| Search debounce | 300ms |
| Image fade-in | ~320ms |
| Theme-switch backstop | 120ms |
| Virtualise past | ~100 rows |

| Frame killer | Fix |
|---|---|
| `backdrop-filter` on moving element | Static chrome only; ≤ 3 per screen; never in a transition |
| Animating layout | `transform` / `opacity`; `grid-template-rows: 0fr → 1fr` for accordions |
| Blurred shadow on animated element | Put the shadow on a pseudo-element and animate its opacity |
| Re-render per pointer move | `useMotionValue` + `useTransform`; never `setState` in `onDrag` |
| Unbounded list | `content-visibility: auto`, then virtualise |

### Code

Reserve boxes and stabilise fonts:

```css
img, video { max-width: 100%; height: auto; }
.thumb { aspect-ratio: 4 / 3; }
@font-face {
  font-family: "Fallback";
  src: local("Arial");
  size-adjust: 104%;        /* match the web font's width so the swap does not reflow */
  ascent-override: 92%;
}
.count { font-variant-numeric: tabular-nums; }
```

Cheap long lists:

```css
.row { content-visibility: auto; contain-intrinsic-size: auto 72px; }
```

Prefetch on press, LCP image priority:

```tsx
<a href="/settings" onPointerDown={() => router.prefetch("/settings")}>Settings</a>
<img src={hero} width={1200} height={630} fetchpriority="high" decoding="async" alt="" />
```

Theme switch in one frame (see `assets/theme-switch.ts`):

```ts
export function applyTheme(dark: boolean) {
  const root = document.documentElement;
  root.classList.add("theme-switching");
  root.dataset.theme = dark ? "dark" : "light";
  const clear = () => root.classList.remove("theme-switching");
  requestAnimationFrame(() => requestAnimationFrame(clear));
  setTimeout(clear, 120); // rAF does not fire in a background tab
}
```

```css
.theme-switching *, .theme-switching *::before, .theme-switching *::after {
  transition: none !important;
}
```

Freeze on hide:

```ts
document.addEventListener("visibilitychange", () => {
  if (document.hidden) stopLoop(); else startLoop();
});
```

Shadow that animates cheaply:

```css
.card { position: relative; }
.card::after {
  content: ""; position: absolute; inset: 0; border-radius: inherit;
  box-shadow: 0 8px 24px -4px oklch(0 0 0 / 0.16);
  opacity: 0; transition: opacity 150ms var(--ease-micro);
}
.card:hover::after { opacity: 1; }
```

Image fade-in with a placeholder:

```tsx
<div className="thumb" style={{ backgroundImage: `url(${blurDataUrl})`, backgroundSize: "cover" }}>
  <img src={src} alt={alt} width={w} height={h} loading="lazy" decoding="async"
       onLoad={(e) => e.currentTarget.classList.add("is-loaded")} />
</div>
```

```css
.thumb img { opacity: 0; transition: opacity 320ms var(--ease-micro); }
.thumb img.is-loaded { opacity: 1; }
```

Intro gate:

```ts
const seen = sessionStorage.getItem("intro");
if (!seen) { playIntro(); sessionStorage.setItem("intro", "1"); }
```

### Checks

- Performance panel, record the primary path: INP < 200ms; no layout bars inside animations.
- Layout Shift track is empty across load, font swap, first data, and a loading button.
- Rendering panel with "Paint flashing": scrolling a list paints only new rows.
- Network panel: route prefetch starts on pointerdown; the hero image is first in the queue.
- Theme toggle changes every colour in one frame with no ripple.
- Hide the tab for 60s: on return, no loop catches up.
- `grep -rn "will-change" src` shows only justified lines.

### Do not

- Put `will-change` in a base stylesheet.
- Animate `height`, `blur()` above 20px, or a blurred `box-shadow` directly.
- Lazy-load the above-the-fold image.
- Show a spinner before 300ms.
- Store the "intro seen" flag in `localStorage`.
- Set React state from a scroll or drag handler.

<!-- references/scroll.md -->

## Scroll

Use this when building or reviewing anything that scrolls: pages, panels, carousels, sticky headers, anchored sections, long lists. Momentum and gestures on non-scroll surfaces live in `references/springs-and-gestures.md`; virtualisation budgets in `references/performance.md`.

### Rules

1. **Momentum is the platform's.** Native overflow scrolling runs off the main thread with per-device deceleration. Any JavaScript that reimplements scrolling feels wrong on at least one device and breaks accessibility scrolling. Check: no `wheel` or `touchmove` handler calls `preventDefault` to drive scroll position.
2. **Contain overscroll inside overlays; leave the page alone in a browser.** `overscroll-behavior: contain` on modals, sheets, and side panels stops scroll chaining to the page. `overscroll-behavior: none` on `html`/`body` only inside `@media (display-mode: standalone)`; in a browser tab users expect pull-to-refresh and edge bounce. Check: scroll to the end of a modal's content; the page behind does not move.
3. **Paging needs `scroll-snap-stop: always`.** `scroll-snap-type: x mandatory` alone lets a hard flick skip three pages. `always` on each item makes it one page per swipe. Check: a hard flick advances exactly one page.
4. **Show the next item peeking.** A horizontal scroller whose last visible card ends exactly at the edge looks complete, and nobody scrolls it. Let 16–32px of the next item show, with `scroll-padding-inline` matching the container padding so snapped items align. Check: at every viewport width, a partial item is visible at the trailing edge.
5. **Sticky chrome shrinks on the compositor.** Use `animation-timeline: scroll()` inside `@supports` for headers that shrink or fade as you scroll; JS scroll listeners run on the main thread and stutter on mid-range devices. Check: the header animates with no `scroll` event handler attached.
6. **Edge effects, not hard dividers.** Where content scrolls under floating chrome, fade it with a gradient or blur mask instead of a 1px line; the eye reads depth, not a border. Check: a translucent header shows content fading beneath it.
7. **Anchors land clear of fixed headers.** `scroll-margin-top` on every `[id]` equal to the header height plus breathing room, so in-page links and browser find-in-page do not hide the target. Check: click a table-of-contents link; the heading sits fully below the header.
8. **Scrollbars only inside panels, never on the page.** Restyle scrollbars within bounded panes where a thin, inset bar reads as part of the component. The page scrollbar belongs to the OS and the user's settings. Check: `::-webkit-scrollbar` rules are scoped to a class, never to `*`, `html`, or `body`.
9. **`scroll-behavior: smooth` only for in-page anchors, and off under reduced motion.** Smooth scrolling on every navigation makes back/forward and find-in-page crawl. Check: `scroll-behavior` is on `html` only inside `@media (prefers-reduced-motion: no-preference)` and only affects anchor jumps.
10. **Restore position on back, start at top on forward.** Browsers restore automatically for full loads; SPAs must do it themselves (`history.scrollRestoration = "manual"` plus saving `scrollY` per entry). Check: navigate into a detail and back; the list is where you left it.
11. **`scrollIntoView` with `block: "nearest"`.** `"start"` or `"center"` yank the page when the element is already visible. Check: focusing an already-visible row does not scroll.
12. **Infinite scroll needs a floor.** Pagination or "Load more" for anything a user might want to reach the end of (search results, settings, footers). Infinite scroll only for feeds with no end, and even then with a visible position marker. Check: the footer is reachable.

### Cheat sheet

| Need | Property |
|---|---|
| Stop scroll chaining in an overlay | `overscroll-behavior: contain` |
| Stop page bounce in a PWA only | `@media (display-mode: standalone) { html, body { overscroll-behavior: none } }` |
| One page per swipe | `scroll-snap-type: x mandatory` on the container, `scroll-snap-align: center; scroll-snap-stop: always` on items |
| Peek | container `padding-inline: 24px; scroll-padding-inline: 24px`, items `flex: 0 0 calc(100% - 72px)` |
| Anchor offset | `[id] { scroll-margin-top: 80px }` |
| Header shrink on scroll | `animation-timeline: scroll(nearest block); animation-range: 0 120px` |
| Content fade under chrome | `mask-image: linear-gradient(to bottom, transparent, black 24px)` on the scroll container |
| Panel scrollbar | scoped `scrollbar-width: thin` + `::-webkit-scrollbar-thumb { background-clip: padding-box; border: 3px solid transparent }` |
| Cheap long lists | `content-visibility: auto; contain-intrinsic-size: auto 72px` (see `references/performance.md`) |

### Code

Paging carousel with a peek:

```css
.pager {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding-inline: 24px;
  scroll-padding-inline: 24px;
  scroll-snap-type: x mandatory;
  overscroll-behavior-x: contain;
  scrollbar-width: none;            /* the pager is its own affordance */
}
.pager > * {
  flex: 0 0 calc(100% - 48px - 24px); /* margins + 24px peek of the next item */
  scroll-snap-align: start;
  scroll-snap-stop: always;
}
```

Tailwind alternative: `flex gap-3 overflow-x-auto px-6 scroll-px-6 snap-x snap-mandatory` on the container, `shrink-0 w-[80%] snap-start snap-always` on items.

Header that shrinks on the compositor, with a static fallback:

```css
.header { height: 72px; }
@supports (animation-timeline: scroll()) {
  @media (prefers-reduced-motion: no-preference) {
    .header {
      animation: shrink linear both;
      animation-timeline: scroll(nearest block);
      animation-range: 0 120px;
    }
  }
}
@keyframes shrink { to { height: 48px; } }
```

Overlay scroll containment and anchors:

```css
.dialog { overscroll-behavior: contain; }
[id] { scroll-margin-top: calc(var(--header-h, 64px) + 16px); }
@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; } /* affects anchor jumps only */
}
```

Scrollbar restyle, scoped to panels only:

```css
.panel-scroll {
  scrollbar-width: thin;
  scrollbar-color: var(--scrollbar-thumb) transparent;
}
.panel-scroll::-webkit-scrollbar { width: 10px; height: 10px; }
.panel-scroll::-webkit-scrollbar-thumb {
  background-color: var(--scrollbar-thumb);
  background-clip: padding-box;   /* the transparent border fakes an inset track */
  border: 3px solid transparent;
  border-radius: 999px;
}
.panel-scroll::-webkit-scrollbar-thumb:hover { background-color: var(--scrollbar-thumb-hover); }
```

Content fading under a floating toolbar:

```css
.scroll-area {
  mask-image: linear-gradient(to bottom, transparent 0, black 24px, black calc(100% - 24px), transparent 100%);
}
```

SPA scroll restoration:

```ts
if ("scrollRestoration" in history) history.scrollRestoration = "manual";
// on navigate away: sessionStorage.setItem(`scroll:${key}`, String(window.scrollY))
// on popstate: window.scrollTo({ top: Number(sessionStorage.getItem(`scroll:${key}`) ?? 0) })
// on push: window.scrollTo({ top: 0 })
```

Focus without yanking:

```ts
row.scrollIntoView({ block: "nearest", inline: "nearest" });
```

### Checks

- Hard flick in a paged carousel advances one page.
- A partial next card is visible at every breakpoint.
- Scroll a modal to its end; the page does not move behind it.
- In a browser tab, pull-to-refresh still works on mobile.
- Anchor links land with the heading fully visible below any fixed header.
- Header shrink happens with no `scroll` listener in the Event Listeners panel.
- Only panels have custom scrollbars; the page scrollbar is native.
- Back navigation restores the list position.

### Do not

- Implement momentum or smooth scrolling in JavaScript.
- Put `overscroll-behavior: none` on the body of a site that runs in a browser tab.
- Restyle the page scrollbar.
- Use `position: fixed` on `body` to lock scroll behind a modal; use `overscroll-behavior: contain` and, if needed, `scrollbar-gutter: stable`.
- Autoplay a carousel. See `references/marketing-pages.md`.
- Attach a `scroll` listener that sets React state per frame.

<!-- references/springs-and-gestures.md -->

## Springs and gestures

Use this when something has mass, follows a finger, or can be interrupted mid-flight: sheets, drawers, drag-to-reorder, swipe-to-dismiss, pull-to-refresh, shared-element moves. For curves and durations on ordinary transitions see `references/motion.md`; for scroll containers see `references/scroll.md`.

### Rules

1. **Parameterise springs by `visualDuration` and `bounce`.** `visualDuration` is the time to first reach the target; the settle happens after. `duration` in Motion means total time including settle and makes every spring feel slow. Stiffness, damping, and mass are for modelling something physical, not for UI. Check: no `stiffness:` in the codebase outside a physics demo.
2. **Springs are for mass and interruption.** Drag release, sheet dismiss, reorder, anything a second gesture can retrigger before it settles. Hover, colour, opacity, and tooltips use curves. Opacity never springs. Check: every `type: "spring"` is on `x`, `y`, `scale`, or `rotate`.
3. **Exit with `exitOf()`.** Exit springs use `visualDuration × 0.65` and `bounce: 0`. Out is faster than in, and an exit that overshoots looks like it changed its mind. Check: no exit transition carries a nonzero bounce.
4. **Bake springs into CSS for anything non-interruptible.** A `linear()` easing with 100+ sampled points costs the same as `linear(0, 1)` at runtime. Generate strings at build time from the same tokens (`assets/gen-springs.mjs`) and pair each with its measured settle duration, which is always longer than the visual duration. Check: `--ease-snappy` and `--dur-spring-snappy` exist as a pair.
5. **Velocity beats position.** Dismiss when velocity exceeds 500px/s regardless of distance. An upward flick always cancels. Only when velocity is small does position decide, at 50% of the height. The user's intent is in the derivative. Check: a hard flick from 10% down dismisses.
6. **Rubber-band past the boundary with Apple's constant.** `(1 − 1 / (offset / dimension × 0.55 + 1)) × dimension` is asymptotic: you can drag forever and never reach the dimension. That is why it feels like elastic and not a wall. Check: overscroll slows smoothly and never hits a stop.
7. **Animate from the current value, never the target.** When a gesture reverses or a second tap lands mid-flight, start the new animation from where the element is now and blend the velocity. A hard cut in velocity reads as a brick wall. Motion does this by default; do not reset state before animating. Check: tap open, tap close halfway; the element turns back from where it was.
8. **Decompose 2D motion into independent X and Y springs.** One spring on a 2D distance desynchronises the axes and the object curves. Check: a diagonal drag release travels straight.
9. **Recognise, then commit.** Tap tolerance ~10px (allow cancel by dragging away and back). Drag commits to an axis after ~10px of movement. Detect all plausible gestures in parallel from the first move, then cancel the losers. Check: a slight wobble while tapping still taps; a diagonal drag picks one axis.
10. **Never `setState` in a drag handler.** Bind the drag to a `MotionValue` and transform it; a React re-render per pointer move drops frames on mid-range devices. Check: React DevTools highlight shows no renders during a drag.
11. **Sheets arbitrate scroll and drag.** If the sheet's content is scrolled to the top and the finger moves down, the sheet moves. Otherwise the content scrolls. Getting this wrong is what makes web sheets feel broken. Check: scroll a long sheet up, then drag down; it scrolls back to top before the sheet moves.
12. **Do not build a custom scroller.** Platform momentum (iOS decelerates at ~0.998 per ms) is tuned per device and runs off the main thread. Use native overflow and `scroll-snap`. Check: no `wheel` or `touchmove` handler implements scrolling.

### Cheat sheet

| Token | Motion config | CSS settle (approx.) | Use |
|---|---|---|---|
| micro | `{ type: "spring", visualDuration: 0.2, bounce: 0.12 }` | ~320ms | press, checkbox, icon swap |
| snappy | `{ type: "spring", visualDuration: 0.3, bounce: 0.18 }` | ~480ms | default: toggles, tab indicators, chips |
| smooth | `{ type: "spring", visualDuration: 0.4, bounce: 0 }` | ~400ms | sheets, modals, panes |
| bouncy | `{ type: "spring", visualDuration: 0.35, bounce: 0.32 }` | ~700ms | likes, badges, one celebration |
| gentle | `{ type: "spring", visualDuration: 0.6, bounce: 0 }` | ~600ms | backdrops, hero reveals |
| exit | `exitOf(token)` | | every exit |
| instant | `{ duration: 0 }` | | reduced motion, live drag tracking |

Bigger element: longer duration, less bounce. A full-screen sheet with `bounce: 0.3` looks like a bug. Anything the user did not initiate: `gentle`.

| Threshold | Value |
|---|---|
| Dismiss velocity | 500px/s |
| Dismiss distance | 50% of height |
| Rubber-band constant | 0.55 (Motion `dragElastic` ≈ 0.2–0.3) |
| Tap tolerance | ~10px |
| Drag axis commit | ~10px |
| Sheet content offset | +80ms after the container, stagger 30ms |

| Shared element | Use when |
|---|---|
| View Transitions API | Cross-route, DOM replaced, no JS state needed; snapshot-based |
| `layoutId` | Same React tree, element persists, must be interruptible |

### Code

Tokens and `exitOf()` (see `assets/motion.ts`):

```ts
import type { Transition } from "motion/react";

export const SPRING = {
  micro:  { type: "spring", visualDuration: 0.2,  bounce: 0.12 },
  snappy: { type: "spring", visualDuration: 0.3,  bounce: 0.18 },
  smooth: { type: "spring", visualDuration: 0.4,  bounce: 0 },
  bouncy: { type: "spring", visualDuration: 0.35, bounce: 0.32 },
  gentle: { type: "spring", visualDuration: 0.6,  bounce: 0 },
} as const satisfies Record<string, Transition>;

export const TWEEN = { fade: { duration: 0.2, ease: "easeOut" } } as const;

export const exitOf = (s: { visualDuration: number }): Transition =>
  ({ type: "spring", visualDuration: s.visualDuration * 0.65, bounce: 0 });
```

Generate CSS springs at build time (`node assets/gen-springs.mjs > motion.generated.css`):

```js
import { spring } from "motion";
const gen = spring({ visualDuration: 0.3, bounce: 0.18, keyframes: [0, 1] });
// sample until done to find settle, then 60 points across it -> linear(...)
```

Dismissal predicate and rubber band:

```ts
const DISMISS_VELOCITY = 500; // px/s
const DISMISS_DISTANCE = 0.5; // of height

export function shouldDismiss(offsetY: number, velocityY: number, height: number) {
  if (velocityY > DISMISS_VELOCITY) return true;    // flick beats position
  if (velocityY < -DISMISS_VELOCITY) return false;  // upward flick always cancels
  return offsetY > height * DISMISS_DISTANCE;
}

export function rubberBand(offset: number, dimension: number, c = 0.55) {
  return (1 - 1 / ((offset / dimension) * c + 1)) * dimension;
}
// apply only past the boundary
const y = raw < 0 ? -rubberBand(-raw, sheetHeight) : raw;
```

A draggable sheet with velocity handoff:

```tsx
import { motion, useMotionValue, useTransform } from "motion/react";

function Sheet({ height, onDismiss }: { height: number; onDismiss: () => void }) {
  const y = useMotionValue(0);
  const backdrop = useTransform(y, [0, height], [1, 0]); // no setState, no re-render
  return (
    <>
      <motion.div className="backdrop" style={{ opacity: backdrop }} />
      <motion.div
        className="sheet"
        style={{ y, borderRadius: 16 }}       /* inline radius so layout animations correct it */
        drag="y"
        dragConstraints={{ top: 0, bottom: 0 }}
        dragElastic={0.2}
        dragTransition={{ bounceStiffness: 500, bounceDamping: 40 }}
        initial={{ y: "100%" }}
        animate={{ y: 0 }}
        exit={{ y: "100%", transition: exitOf(SPRING.smooth) }}
        transition={SPRING.smooth}
        onDragEnd={(_, info) => {
          if (shouldDismiss(info.offset.y, info.velocity.y, height)) onDismiss();
        }}
      >
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}
          transition={{ ...TWEEN.fade, delay: 0.08 }}>
          {/* contents arrive 80ms after the container */}
        </motion.div>
      </motion.div>
    </>
  );
}
```

Vaul handles the arbitration and snap points and is the pragmatic default; its gap is no spring settle. Build on a headless dialog plus the code above when that settle matters.

Interruptible back-swipe shape (edge gesture drives a MotionValue; release decides):

```ts
onDragEnd: (_, info) => {
  const commit = info.velocity.x > 500 || info.offset.x > width * 0.5;
  animate(x, commit ? width : 0, commit ? SPRING.smooth : exitOf(SPRING.smooth));
}
```

`layout` gotchas:

```tsx
<motion.div layout style={{ borderRadius: 12 }}>      {/* radius inline, not in CSS */}
  <motion.p layout="position">Text does not shimmer</motion.p>
</motion.div>
<motion.ul layoutScroll style={{ overflow: "auto" }} />  {/* scroll containers */}
<motion.div layoutRoot style={{ position: "fixed" }} /> {/* fixed ancestors */}
```

A shared-layout element under a continuously animating ancestor transform
does not travel. `layout` and `layoutId` work by measuring the box before and
after and inverting the difference; if a parent carries a CSS animation on
`transform`, every measurement reads a different origin and the element lands
at its destination instead of moving to it. The same applies to a parent
being dragged, or to any ancestor whose transform is driven outside React.
When an indicator has to slide inside a surface that is itself moving, drive
it by index rather than by measurement: one absolutely positioned element,
`x` animated as a percentage of its own width. A percentage of self needs no
box read, so it is immune to whatever the ancestor is doing.

### Checks

- Flick a sheet down from 10%: it dismisses. Drag slowly to 40% and release: it returns.
- Drag past the top: movement slows asymptotically, never stops dead.
- Open then close mid-animation: the element reverses from its current position with no jump.
- Diagonal drag release travels in a straight line.
- React DevTools shows zero renders during a drag.
- `--ease-*` and `--dur-*` pairs exist for every token used in CSS.

### Do not

- Spring opacity, colour, or blur.
- Use `duration` with `bounce` on a Motion spring; use `visualDuration`.
- Decide dismissal by position alone.
- Reset a MotionValue to its start before re-animating.
- Put `border-radius` in a stylesheet on a `layout` element.
- Reimplement momentum scrolling in JavaScript.

<!-- references/states.md -->

## States

Use this when anything on screen can be empty, loading, failing, succeeding, offline, or overflowing. Which is everything that talks to data.
Every state gets the same care as the happy path; the empty state is the first thing every new user sees.

### Rules

1. **Follow the loading ladder.** 0–300ms: nothing, or the optimistic result. 300ms–2s: a skeleton at the exact final size, or inline progress where the result will land. 2s+: explicit progress with a label and a cancel. 10s+: let the person leave and notify them. Check: throttle the network to Slow 3G and watch each threshold.
2. **The spinner travels.** Progress appears where the result will appear, not only on the control that was clicked. A sent comment shows pending in the list; an uploaded file shows progress on its row. The control may carry progress as well once the result has a home of its own, which is why a button that doubles as a progress bar is right when the work also appears where it will land and wrong when that is the only place it appears. Check: after a click, where does the eye go? That is where the indicator belongs, and it is not allowed to be nowhere.
3. **No spinner before 300ms.** A flash of spinner for a 120ms request reads as slower than no indicator at all. Check: set a 300ms delay before any spinner mounts.
4. **Skeletons match the structure.** Same number of lines, same widths, same positions as the content that will replace them. Three bars for five lines is a broken promise. Shimmer 1.2–1.5s, subtle, static under `prefers-reduced-motion`. Check: overlay the skeleton on the loaded state; edges align.
5. **Optimistic first, ghost while pending.** Apply the change immediately at 60% opacity, confirm to 100% on success, revert with an inline reason on failure. Not a spinner; a ghost. Check: send a message with the network off; it appears, then reverts with a reason next to it.
6. **Empty states have three parts.** The name of what is missing, one line of why, one action. "No projects yet. Create one to start tracking time. [New project]". Never "No items". Check: every empty state has exactly one button.
7. **Search and filter empties name the query and offer an exit.** "No results for 'quarterly'. Clear filters." Check: filter to zero results; the filter can be cleared from the empty state.
8. **Never park crucial persistent information in an empty state.** It disappears the moment there is one item. Settings, limits, and instructions live somewhere permanent. Check: add one item; did any important text vanish?
9. **First-run is not the empty state.** First-run invites and can show an example; empty after deletion is quieter and offers the same action without the tour. Check: delete everything; you do not see the welcome again.
10. **Offline is a state, not an error.** A quiet banner, cached content still readable, writes queued with a visible pending mark. Check: go offline; can you still read what you loaded?
11. **Design for two and for two hundred.** Test every list with 0, 1, 2, and 200 rows; every title at 60 characters; every description at 4 lines. Check: nothing overlaps, truncates without a tooltip, or breaks the grid.
12. **Denied, missing, and broken pages offer a way forward.** 403 says what you need and who to ask. 404 offers search and the nearest parent. 500 keeps the navigation and offers retry. Check: each page has at least one link that is not "Home".
13. **Errors sit next to the thing that failed.** Field errors on the label row; row errors on the row; page-level errors at the top with focus moved to them. Never a toast for a contextual error. Check: could the person be looking elsewhere? If not, inline.
14. **Feedback follows the taxonomy.** Minor and reversible: a toast with Undo. Contextual: inline at the thing that changed. The app acted for you: a receipt card that stays. Destructive: confirm with the noun, then resolve in place. Check: classify each feedback moment; the mechanism follows.
15. **Undo actually undoes.** The row comes back, the server is told, the state matches. Hiding the toast is not undo. Check: delete, undo, reload.
16. **Success is acknowledged once, where the result appears.** A saved row shows "Saved" on the row for 1.5s, or the new item appears in its place. Not a toast plus a banner plus a checkmark. Check: count the acknowledgements; one.
17. **Announce state changes with the ladder.** Pick the lowest rung that works and use each change once; the ladder itself lives in `references/accessibility.md`. Check: screen reader hears each transition once.
18. **Suspense boundaries wrap components, not pages.** A page-level boundary turns one slow widget into a blank page. Wrap the widget. Check: slow one query; the rest of the page renders.
19. **Stream without shifting.** Reserve the box before the data arrives (`min-height`, aspect ratio, skeleton at final size). Content that streams in must land in space that already exists. Check: record the load; CLS is zero.
20. **Retry is visible and backed off.** Automatic retry with exponential backoff behind the scenes, plus a Retry control the person can press. Never an infinite spinner. Check: fail three times; the person sees a button.
21. **A long local job needs a surface of its own.** The ladder above is written for a network request that returns JSON. A forty-second export, encode, or render on the person's own CPU is a different shape, and five things follow from it. Progress lives in a surface that survives the whole job and shows the artefact being worked on, not only as a sweep on the control that started it. The cancel is reachable throughout and actually stops the work, rather than hiding the progress. When the job fails, the progress surface does not unmount in the same frame the error appears, or the failure lands somewhere the eye is not; hold the surface and show the reason inside it. Completion while the person has tabbed away is announced through `role="status"`, not a toast that expires before they look. And when the result is a file, the download or the save is the completion; progress reaching 100% is not. Check: start the job, switch tabs, come back. Then fail it on purpose and watch where your eye goes.
22. **One channel per severity, and grep for a second.** The taxonomy above assumes one implementation of each mechanism. The common failure is two: a toast system, plus an older status string in a toolbar or a status bar that predates it and still has call sites, usually on the paths that were written first and matter most. The symptom is a message surface that nothing new is wired to and nothing old was migrated off. Check: grep for every function that displays a message; if there are two, list the call sites of the older one and route them through the newer.

### Cheat sheet

| Elapsed | Show |
|---|---|
| 0–300ms | nothing, or the optimistic result |
| 300ms–2s | skeleton at final size, or inline progress where the result lands |
| 2s+ | explicit progress with label and cancel |
| 10s+ | let them leave; notify on completion |

| Outcome | Mechanism |
|---|---|
| Minor, reversible, global | toast with Undo, 5s floor |
| Contextual | inline at the thing |
| App acted on your behalf | receipt card that stays |
| Destructive | confirm naming the noun, resolve in place |
| Field invalid | error on the label row |
| Page-level failure | summary at top, focus moved |

| Long local job | Where it belongs |
|---|---|
| Progress | a surface that outlives the job, showing the artefact |
| Cancel | reachable throughout; stops the work, not just the display |
| Failure | inside the progress surface, which stays put |
| Completion, tabbed away | `role="status"`, not an expiring toast |
| Completion, result is a file | the save or download, not 100% |

| State | Must exist for |
|---|---|
| Empty | every list, table, search, filter |
| Loading | every fetch |
| Error | every fetch, every submit |
| Success | every submit |
| Offline | every app with writes |
| Overflow | every list (200 rows), every title (60 chars) |

### Code

```tsx
// Spinner only after 300ms.
export function DelayedSpinner({ delay = 300 }: { delay?: number }) {
  const [show, setShow] = useState(false);
  useEffect(() => { const t = setTimeout(() => setShow(true), delay); return () => clearTimeout(t); }, [delay]);
  return show ? <Spinner /> : null;
}
```

```css
/* Skeleton: final size, subtle shimmer, static under reduced motion. */
.skeleton {
  background: var(--surface-muted);
  border-radius: var(--radius-sm);
  position: relative; overflow: hidden;
}
.skeleton::after {
  content: ""; position: absolute; inset: 0;
  background: linear-gradient(90deg, transparent, rgb(255 255 255 / 0.25), transparent);
  transform: translateX(-100%);
  animation: shimmer 1.4s linear infinite;
}
@keyframes shimmer { to { transform: translateX(100%) } }
@media (prefers-reduced-motion: reduce) { .skeleton::after { animation: none; } }
```

```tsx
// Optimistic with ghost and revert (React 19 useOptimistic; adapt if older).
const [optimistic, add] = useOptimistic(items, (state, next: Item) => [...state, { ...next, pending: true }]);
async function send(item: Item) {
  add(item);
  try { await api.create(item); }
  catch (e) { setError(item.id, "Could not send. Tap to retry."); }
}
// row
<li style={{ opacity: item.pending ? 0.6 : 1 }} aria-busy={item.pending || undefined}>
  {item.text}
  {item.error && <button className="inline-error" onClick={() => send(item)}>{item.error}</button>}
</li>
```

```tsx
// Empty state: name, why, one action. Search variant names the query.
function Empty({ query, onClear, onCreate }: Props) {
  if (query) return (
    <div className="empty" role="status">
      <p>No results for "{query}".</p>
      <Button onClick={onClear}>Clear filters</Button>
    </div>
  );
  return (
    <div className="empty">
      <p>No projects yet. Create one to start tracking time.</p>
      <Button variant="primary" onClick={onCreate}>New project</Button>
    </div>
  );
}
```

```tsx
// Undo that undoes: keep the item, tell the server, restore on undo.
async function archive(item: Item) {
  setItems((s) => s.filter((i) => i.id !== item.id));
  const { undo } = await api.archive(item.id); // server returns an undo token
  toast({ text: "Archived", action: { label: "Undo", onClick: async () => { await api.unarchive(undo); setItems((s) => [...s, item]); } } });
}
```

```tsx
// Stable live region for repeated polite updates.
<div role="status" aria-live="polite" className="sr-only" id="status">{statusText}</div>
```

```tsx
// A long local job: the surface outlives the job, and failure lands in it.
type Job =
  | { phase: "idle" }
  | { phase: "running"; done: number; total: number }
  | { phase: "failed"; reason: string }
  | { phase: "saved"; name: string };

// One surface for all three non-idle phases. It does not unmount on failure,
// so the reason appears where the person was already looking.
{job.phase !== "idle" && (
  <section className="job" aria-labelledby="job-title">
    <h2 id="job-title">Exporting</h2>
    <Preview frame={job.phase === "running" ? job.done : undefined} />
    {job.phase === "running" && (
      <>
        <progress value={job.done} max={job.total} />
        <button onClick={cancel}>Cancel</button>
      </>
    )}
    {job.phase === "failed" && <p className="error">{job.reason}</p>}
    <p role="status" className="sr-only">
      {job.phase === "saved" ? `Export saved as ${job.name}` : ""}
    </p>
  </section>
)}
```

### Checks

- Throttle to Slow 3G; watch the 300ms, 2s, and 10s thresholds behave.
- Overlay each skeleton on its loaded content; edges align.
- Go offline; read cached content; make a change; see it queued.
- Every list at 0, 1, 2, 200 items; every title at 60 characters.
- Delete, Undo, reload; the item is there.
- Filter to zero; the empty state clears the filter.
- Screen reader through a submit: one announcement per outcome.
- Record a page load; CLS is zero.
- Start a long job, switch tabs, return: you are told it finished. Fail it on purpose: the reason is in the surface you were watching.
- Grep every message-display function; if there are two, the older one has no call sites left.

### Do not

- Show a spinner on the clicked button, or before 300ms.
- Ship a skeleton that does not match the content.
- Write "No items" or "Nothing here".
- Put instructions people will need later in an empty state.
- Toast a field error.
- Hide the toast and call it undo.
- Wrap the page in one Suspense boundary.
- Retry silently forever.
- Unmount the progress surface in the same frame the error appears.
- Leave a superseded message channel wired to the paths that matter most.

See `references/overlays.md` for toasts, `references/forms-and-inputs.md` for field errors, `references/accessibility.md` for live regions.

<!-- references/surfaces-and-depth.md -->

## Surfaces and depth

Use this when you are styling cards, panels, overlays, images, borders, shadows, blur, or radii, or auditing why a page feels flat, muddy, or like a template.
Pair with `references/theming-and-dark-mode.md` for what depth becomes in the dark and `references/overlays.md` for modal and sheet motion.

### Rules

1. **A card needs a reason.** A card separates something that could be moved, selected, or acted on as a unit. Content that is simply a section gets space and a heading, not a box. The identical-rounded-card kit with the same grey shadow under each is the most recognisable template tell.
2. **Shadow as border in the light.** `box-shadow: 0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04)`. Hover raises to `0.08 / 0.08 / 0.06`. The 1px ring does the work; the two soft layers give it contact. A `border` sits inside the box and shifts layout; a shadow ring does not.
3. **A single ring in the dark.** Shadows do not read on dark grounds. Collapse to `0 0 0 1px oklch(1 0 0 / 0.08)`, hover `0.13`. Elevation in the dark comes from a slightly lighter surface plus the ring.
4. **Hairlines are 1px, 0.5px on dense screens.** `--hairline: 1px`, overridden to `0.5px` at `min-resolution: 2dppx`. Anything thinner disappears; anything thicker reads as a rule, not a hairline.
5. **Outline every user image.** `outline: 1px solid oklch(0 0 0 / 0.1)` in the light, `oklch(1 0 0 / 0.1)` in the dark, `outline-offset: -1px`. Pure black or white at 10%, never a tinted grey; a tinted outline reads as dirt on the image edge. Without it a white product shot floats loose on a white canvas.
6. **Name your elevation ladder.** `--surface`, `--raised`, `--overlay` (and their hover variants) as tokens, each with its own background and shadow. Components pick a rung; nobody types a shadow.
7. **Only true floating overlays get a drop shadow.** Popovers, menus, toasts, dragged items: `0 12px 32px oklch(0 0 0 / 0.18)`, tinted toward the canvas hue rather than neutral black. Cards, rows, and sections do not float and do not get one.
8. **Bigger surfaces read thicker.** A full sheet gets a stronger blur and a deeper shadow than a tooltip. Depth cues scale with the size of the thing that is supposedly above the page.
9. **Never stack two translucent surfaces.** Legibility collapses; text on the upper one is fighting two backgrounds. The second layer becomes solid.
10. **Backdrop blur needs saturation and a budget.** `backdrop-filter: blur(20px) saturate(180%)`; without `saturate` it is grey mush. Two or three per screen, on static chrome (headers, bars, sheet frames) only. Never on a scrolling or animating element; it is the number-one frame killer.
11. **Never animate blur above 20px.** Static blur up to 50px is fine. Animating it is expensive, especially in Safari.
12. **Materialise, do not just fade.** When a translucent surface enters or leaves, animate blur and scale together with opacity (blur 4px to 0, scale 0.96 to 1). Opacity alone reads as a ghost appearing.
13. **Dim to focus, separate to keep flow.** A modal is surface plus scrim plus the page pushed back (scale 0.98, radius 12px). A side panel is translucency plus offset with no scrim, so the user stays in the flow.
14. **Vibrancy over translucency for text on materials.** Flat grey text on blur is unreadable. Use higher contrast, one weight step up, and a small tracking bump (+0.01em). Put colour on a solid layer, not on the material.
15. **Radii are concentric and few.** At most three values. Nested = outer − padding. Above 24px of padding, stop calculating; the layers are separate surfaces. See `references/layout-and-spacing.md`.
16. **Squircles only where the shape is load-bearing.** `corner-shape: superellipse(4)` (Chromium 139+) as a progressive enhancement for radii above 20px on hero surfaces. At small radii nobody can tell.
17. **Borders on media, shadows on surfaces.** Media (images, video, embeds) get the inset outline. Surfaces get the ring or the ladder. Mixing produces double edges.
18. **`isolation: isolate` on components with layered children.** It creates a stacking context so internal z-index never leaks into the page's scale. Prefer it over adding to the global z-scale.

### Cheat sheet

| Rung | Light | Dark |
|---|---|---|
| `--surface` (rest) | canvas, no shadow | canvas, no shadow |
| `--raised` (card, row group) | ring 0.06 + 2 soft layers | ring 0.08 |
| `--raised` hover | 0.08 / 0.08 / 0.06 | ring 0.13 |
| `--overlay` (popover, menu, toast) | ring + `0 12px 32px` at 0.18, tinted | slightly lighter surface + ring 0.10 |
| Image edge | `outline 1px oklch(0 0 0 / .1)` inset | `outline 1px oklch(1 0 0 / .1)` inset |
| Hairline | 1px, 0.5px at 2dppx | same, alpha 0.12 |

| Blur | Value | Where |
|---|---|---|
| Thin chrome | `blur(20px) saturate(180%)` at 30–50% alpha | headers, tab bars |
| Sheet frame | `blur(40px) saturate(180%)` at 65–80% alpha | sheets, side panels |
| Budget | 2–3 per screen | static only |
| Animated | never above 20px | enter/exit only |

### Code

Tokens (values are examples):

```css
:root {
  --hairline: 1px;
  --shadow-raised: 0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04);
  --shadow-raised-hover: 0 0 0 1px oklch(0 0 0 / 0.08), 0 1px 2px -1px oklch(0 0 0 / 0.08), 0 2px 4px 0 oklch(0 0 0 / 0.06);
  --shadow-overlay: 0 0 0 1px oklch(0 0 0 / 0.06), 0 12px 32px oklch(0.2 0.02 260 / 0.18); /* tinted toward the canvas hue */
  --outline-media: 1px solid oklch(0 0 0 / 0.1);
}
[data-theme="dark"] {
  --shadow-raised: 0 0 0 1px oklch(1 0 0 / 0.08);
  --shadow-raised-hover: 0 0 0 1px oklch(1 0 0 / 0.13);
  --shadow-overlay: 0 0 0 1px oklch(1 0 0 / 0.10);
  --outline-media: 1px solid oklch(1 0 0 / 0.1);
}
@media (min-resolution: 2dppx) { :root { --hairline: 0.5px; } }

.raised { background: var(--color-bg-raised); box-shadow: var(--shadow-raised); border-radius: var(--r-2); isolation: isolate; }
.raised:hover { box-shadow: var(--shadow-raised-hover); }
.overlay { background: var(--color-bg-overlay); box-shadow: var(--shadow-overlay); }
img, video, .embed { outline: var(--outline-media); outline-offset: -1px; }
```

Material chrome, with the reduced-transparency fallback:

```css
.bar {
  background: oklch(from var(--canvas) l c h / 0.72);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  box-shadow: 0 var(--hairline) 0 var(--hairline-color);
}
@media (prefers-reduced-transparency: reduce) {
  .bar { background: var(--canvas); backdrop-filter: none; }
}
.bar .title { font-weight: 500; letter-spacing: 0.01em; } /* vibrancy: weight and tracking, not opacity */
```

Materialise on enter:

```css
@keyframes materialise {
  from { opacity: 0; transform: scale(0.96); filter: blur(4px); }
  to   { opacity: 1; transform: scale(1);    filter: blur(0); }
}
.popover[data-state="open"] { animation: materialise 200ms cubic-bezier(0.165, 0.84, 0.44, 1); }
```

Modal push-back:

```css
body:has(dialog[open]) > main {
  transform: scale(0.98);
  border-radius: 12px;
  transition: transform 300ms cubic-bezier(0.16, 1, 0.3, 1), border-radius 300ms cubic-bezier(0.16, 1, 0.3, 1);
}
```

Squircle enhancement:

```css
.hero-card { border-radius: 28px; }
@supports (corner-shape: superellipse(4)) { .hero-card { corner-shape: superellipse(4); } }
```

Tailwind mapping: `shadow-[var(--shadow-raised)]` or a `@theme` `--shadow-raised` token used as `shadow-raised`; `outline outline-1 -outline-offset-1 outline-black/10 dark:outline-white/10` on images; `backdrop-blur-xl backdrop-saturate-[1.8]`; `isolate`.

### Checks

- Count distinct shadow declarations in the codebase; more than the ladder means someone typed one.
- Every `<img>` on a light and a dark canvas shows a visible edge.
- Dark theme: no dark shadow remains; rings are present.
- Count `backdrop-filter` per screen; none on a scrolling container or an animated element.
- Every `backdrop-filter` includes `saturate`.
- No two translucent surfaces overlap.
- Text on materials measured for contrast over the lightest and darkest scrolling content.
- Nested radii equal outer minus padding.
- Cards: each one names what unit it represents; sections without a unit lost their box.

### Do not

- Put the same shadow under every card.
- Use `border: 1px` where a ring avoids the layout shift.
- Tint the image outline toward the brand or a slate grey.
- Blur a scrolling list header that moves with the list.
- Animate `filter: blur()` beyond 20px.
- Stack a translucent popover on a translucent sheet.
- Type a shadow value in a component.

<!-- references/theming-and-dark-mode.md -->

## Theming and dark mode

Use this when you are adding, fixing, or auditing a light/dark switch, defining how surfaces and inks flip, or handling the system preference and the print theme.
Pair with `references/color.md` for the values and `references/surfaces-and-depth.md` for what shadows become in the dark.

### Rules

1. **Dark mode is not a mirror.** Reversing every palette step produces glaring text on a muddy ground. Design the dark theme as a second set of pairs and re-check every foreground/background pair in both. Check: the findings table lists each pair with both measurements.
2. **Step the ink in alpha, not in separate greys.** Define one ink and derive secondary, tertiary, quaternary, and hairline as that ink at 0.62, 0.45, 0.28, and 0.10. When the dark theme swaps the base ink and canvas, the whole hierarchy follows for free and stays proportional on any surface.
3. **Tokens on `:root`, overrides on `[data-theme]`.** Surfaces and inks are CSS variables; the theme attribute flips them. Never build surfaces with Tailwind `dark:` classes, because every component then owns its own copy of the decision and the copies drift.
4. **"System" is the absence of a stored key.** Store only an explicit choice. When the user picks System, remove the key and follow `matchMedia("(prefers-color-scheme: dark)")`. Browsers that never chose keep the behaviour they always had.
5. **One source of truth, read through `useSyncExternalStore`.** The header toggle and the settings page subscribe to the same store, so they cannot disagree.
6. **Suppress transitions for one frame while switching.** Without it every control cross-fades its own colours on its own curve and the switch reads as a ripple of mismatched fades. Add a class that sets `transition: none !important`, flip the theme, remove the class after two nested `requestAnimationFrame` calls, and add a `setTimeout` of 120ms as a backstop because rAF does not fire in a background tab. (`next-themes` exposes this as `disableTransitionOnChange`.)
7. **Set `color-scheme` on the root.** `color-scheme: light dark` (or the active one) makes native controls, scrollbars, and form elements render in the right scheme without custom styling.
8. **Prevent the flash.** Apply the stored theme in a blocking inline script in `<head>` before first paint. A theme applied after hydration flashes the wrong scheme on every load.
9. **Shadows vanish in the dark; use a ring.** Replace the light shadow stack with a single `0 0 0 1px oklch(1 0 0 / 0.08)` ring, hover `0.13`. See `references/surfaces-and-depth.md`.
10. **Desaturate the brand colour 20–30% in dark and lift its L.** Saturated accents vibrate on dark grounds, and a dark ground needs the accent's L raised roughly 0.06 to hold 3:1 for UI. Hover states come from `color-mix(in oklch, var(--color-accent) 85%, black)` rather than a second hardcoded value.
11. **Near-black carries the palette's hue.** Pure `#000` is a written decision (OLED bleed, media-first chrome), not a default. A canvas at L 0.12–0.20 with a whisper of the brand hue reads as a room, not a void.
12. **Images and media get an outline, not a filter.** A 1px `oklch(1 0 0 / 0.1)` inset outline separates a photo from a dark canvas. `filter: brightness(0.9)` on images is a last resort for glaring white product shots, applied per image, never globally.
13. **Honour `prefers-reduced-transparency`.** Translucent chrome becomes a solid surface token when the user asks. Test the page with it on.
14. **Never fight `forced-colors: active`.** Do not set `forced-color-adjust: none` on content. Use system colour keywords (`CanvasText`, `LinkText`, `ButtonFace`) if you must style within it, and let focus rings and borders be drawn by the browser.
15. **Print is a real theme.** Greys become black, canvas becomes white, shadows and backdrops go, type drops a step. Test it; a dark theme printed as-is wastes toner and reads as broken.
16. **Test both themes for every state.** Hover, focus, selected, disabled, error, and placeholder each have two pairs. Half-tested is untested.

### Cheat sheet

| Layer | Light | Dark |
|---|---|---|
| Canvas | `--canvas` | `--canvas` (near-black with hue) |
| Ink | `--ink` | `--ink` (near-white, not pure) |
| Ink secondary / tertiary / quaternary | ink at 0.62 / 0.45 / 0.28 | same alphas on the dark ink |
| Hairline | ink at 0.10 | ink at 0.12 |
| Elevation | 3-layer shadow-as-border | single white ring 0.08, hover 0.13 |
| Accent | brand value | 20–30% less chroma, L lifted ~0.06 |
| Images | optional outline | outline 1px white 10% inset |

| Preference | Response |
|---|---|
| No stored key | follow `prefers-color-scheme` |
| Stored `light` / `dark` | apply; ignore the OS until the user picks System |
| `prefers-reduced-transparency` | solid surface tokens |
| `prefers-contrast: more` | widen L gap ≥ 0.15 (see `references/color.md`) |
| `forced-colors: active` | do not override |
| `print` | black on white, no shadows, no blur |

### Code

Tokens (values are examples; the mechanism is the point):

```css
:root {
  color-scheme: light;
  --canvas: #ffffff;
  --ink: #1a1a1a;
  --ink-secondary: rgb(from var(--ink) r g b / 0.62);
  --ink-tertiary: rgb(from var(--ink) r g b / 0.45);
  --ink-quaternary: rgb(from var(--ink) r g b / 0.28);
  --hairline: rgb(from var(--ink) r g b / 0.10);
  --elevation: 0 0 0 1px oklch(0 0 0 / 0.06), 0 1px 2px -1px oklch(0 0 0 / 0.06), 0 2px 4px 0 oklch(0 0 0 / 0.04);
}

[data-theme="dark"] {
  color-scheme: dark;
  --canvas: #161616;
  --ink: #ededed;
  --hairline: rgb(from var(--ink) r g b / 0.12);
  --elevation: 0 0 0 1px oklch(1 0 0 / 0.08);
}

/* No stored choice: follow the OS. The inline script below sets data-theme only for explicit choices. */
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    color-scheme: dark;
    --canvas: #161616;
    --ink: #ededed;
    --hairline: rgb(from var(--ink) r g b / 0.12);
    --elevation: 0 0 0 1px oklch(1 0 0 / 0.08);
  }
}

html.theme-switching * { transition: none !important; }

@media (prefers-reduced-transparency: reduce) {
  :root { --glass: var(--canvas); }
}

@media print {
  :root { --canvas: #fff; --ink: #000; --elevation: none; }
  * { backdrop-filter: none !important; box-shadow: none !important; }
}
```

Blocking init in `<head>`, before any stylesheet paints:

```html
<script>
  try {
    var t = localStorage.getItem("theme");
    if (t === "dark" || t === "light") document.documentElement.dataset.theme = t;
  } catch (e) {}
</script>
```

Store, switch, and hook (`theme.ts`):

```ts
import { useSyncExternalStore } from "react";

export type ThemePref = "light" | "dark" | "system";
const KEY = "theme";
const listeners = new Set<() => void>();

export function themePref(): ThemePref {
  try {
    const s = localStorage.getItem(KEY);
    return s === "dark" ? "dark" : s === "light" ? "light" : "system";
  } catch {
    return "system";
  }
}

export function applyTheme(dark: boolean) {
  const root = document.documentElement;
  root.classList.add("theme-switching");
  root.dataset.theme = dark ? "dark" : "light";
  const clear = () => root.classList.remove("theme-switching");
  requestAnimationFrame(() => requestAnimationFrame(clear));
  setTimeout(clear, 120); // rAF does not fire in a background tab
}

export function setThemePref(pref: ThemePref) {
  try {
    if (pref === "system") localStorage.removeItem(KEY);
    else localStorage.setItem(KEY, pref);
  } catch {}
  applyTheme(
    pref === "system"
      ? window.matchMedia("(prefers-color-scheme: dark)").matches
      : pref === "dark",
  );
  listeners.forEach((fn) => fn());
}

export function useThemePref(): ThemePref {
  return useSyncExternalStore(
    (cb) => { listeners.add(cb); return () => listeners.delete(cb); },
    themePref,
    () => "system",
  );
}

// Follow the OS while in system mode.
if (typeof window !== "undefined") {
  const mq = window.matchMedia("(prefers-color-scheme: dark)");
  mq.addEventListener("change", () => { if (themePref() === "system") applyTheme(mq.matches); });
}
```

Accent hover without a second literal:

```css
.button-primary:hover {
  background: color-mix(in oklch, var(--color-accent) 85%, black);
}
```

### Checks

- Toggle the theme with the Animations panel open: exactly one frame, no cross-fading controls.
- Switch the theme in a background tab, return: transitions still work.
- Clear storage, change the OS scheme: the page follows.
- Every state (hover, focus, selected, disabled, error, placeholder) screenshotted in both themes.
- `color-scheme` set; native `<select>`, scrollbars, and date inputs render in the active scheme.
- Print preview: black on white, no shadows, no blur.
- With `prefers-reduced-transparency` on, no translucent chrome remains.
- Grep for `dark:` on background or text utility classes returns nothing (or only for genuinely one-off content).

### Do not

- Build surfaces with `dark:` classes.
- Store "system" as a value.
- Flip the theme without the one-frame suppressor.
- Invert images, or apply a global brightness filter.
- Use pure `#000` without writing the decision in the design contract.
- Override `forced-colors`.
- Ship a dark theme without re-measuring every pair.

<!-- references/touch-and-mobile.md -->

## Touch and mobile web

Use this when the interface will be used on a phone or tablet, in a browser or as an installed web app. Most "feels like a website" complaints trace to a dozen platform defaults nobody turned off, and a few that somebody turned off wrongly.

### Rules

1. **Ship the base layer once, at the root.** Tap highlight, text-size adjust, touch callout, touch-action, selection policy, focus policy, and input size (see Code). Why: these are per-page defaults that read as sloppiness on every screen at once. Check: the base layer exists in one file and is imported first.
2. **Inputs are at least 16px.** `font-size: max(16px, 1rem)`. Why: below 16px iOS Safari zooms the viewport on focus and does not zoom back. Check: focus every input on a real iPhone; nothing zooms.
3. **Never `user-scalable=no` or `maximum-scale=1`.** Safari ignores it for pinch, every other browser honours it, and it fails WCAG 1.4.4. Fix the zoom cause (rule 2) instead. Check: the viewport meta contains neither.
4. **`viewport-fit=cover`, then add safe areas to padding.** `padding-bottom: calc(16px + env(safe-area-inset-bottom, 0px))`. Never use the inset as the whole padding. For sheets, pad the contents, not the position. Why: without `viewport-fit=cover`, `env()` returns 0 and you will not notice until a device with a home indicator. Declaring it and never reading `env()` anywhere is the trap, because it looks handled. How much it matters depends on the product: on a phone-first app it is HIGH, because the bottom chrome is under the home indicator which also swallows the taps. On a desktop-first app that happens to have set it, the finding is real but MEDIUM at most, and the fix is only needed on chrome that touches a screen edge, usually one footer or transport bar. Check: `grep -rn "safe-area-inset"`; if `viewport-fit=cover` is set and this returns nothing, find the bottom-most fixed chrome and decide which case you are in.
5. **`dvh` for fill layouts, `svh` for fixed chrome, `vh` never.** `100vh` is the largest viewport on iOS and overflows under the URL bar. `dvh` reflows during scroll, so prefer `svh` for a composer or a bottom bar. Check: grep for `100vh`; each hit is a finding.
6. **`overscroll-behavior: none` on html/body only in standalone mode, with one exception.** In the browser, people expect pull-to-refresh and rubber-banding. Inside scroll containers use `overscroll-behavior: contain`. The exception is an editor, a canvas, or anything holding unsaved state: those may pin `overscroll-behavior-x: none` globally, because an accidental edge swipe that navigates back destroys work, and losing work beats losing pull-to-refresh. Pin the axis you need rather than both. Record the decision in the design contract so the next reviewer reads it as a choice and not an oversight. Check: the rule lives inside `@media (display-mode: standalone)`, or the contract says why it does not.
7. **Every hover-only affordance has a touch equivalent.** Wrap hover styles in `@media (hover: hover)`; expose the same action via a visible control, a long-press, or an always-on state. Why: a hover-revealed delete button does not exist on a phone. Check: emulate touch in DevTools; can you reach every action?
8. **Targets are 44px on touch.** Visual size can be smaller; expand the hit area with a pseudo-element on the `<button>` or `<label>`, never on the `<input>`. No two hit areas overlap. See `references/accessibility.md`.
9. **`touch-action: manipulation` on every control.** Removes the 300ms double-tap delay where it still exists and stops accidental zoom on rapid taps. Check: grep controls for `touch-action`.
10. **Haptics fire on `pointerdown`, never `click`, never on scroll.** See `references/haptics-and-sound.md`.
11. **Handle the virtual keyboard.** iOS resizes `visualViewport`, not the layout viewport; `position: fixed` elements do not move. Use the VirtualKeyboard API where present and a `visualViewport` fallback that writes `--kb` and moves the composer with `transform`, not `bottom`. Never focus an input in the same frame you open a sheet; wait ~350ms or `onAnimationComplete`. Check: open the composer on iOS; it sits above the keyboard.
12. **`enterkeyhint` and `inputmode` on every field.** `enterkeyhint="send"`, `"search"`, `"next"`, `"done"`; `inputmode="numeric"` for codes, `"decimal"` for money, `"email"`, `"tel"`. Why: the keyboard's primary key should say what will happen. Check: every `<input>` names both.
13. **Scroll snap paging needs `scroll-snap-stop: always`.** Without it a hard flick skips three pages. Check: flick fast on a snap carousel; it advances one.
14. **Test the smallest first.** 320px wide, vertical scroll only, no horizontal overflow. Then the largest. Check: DevTools at 320, look for a horizontal scrollbar.
15. **Test on a real device.** iPhone with Safari's remote inspector, and an Android phone with Chrome. Simulators miss zoom-on-focus, keyboard insets, tap highlight, and momentum. Check: at least one real-device pass per release.

### Cheat sheet

| Property | Value |
|---|---|
| Input size | `max(16px, 1rem)` |
| Viewport meta | `width=device-width, initial-scale=1, viewport-fit=cover` |
| Fill height | `100dvh` |
| Fixed chrome height | `svh` |
| Safe area | `calc(<pad> + env(safe-area-inset-*, 0px))` |
| Touch target | 44px, pseudo-element on button/label |
| Controls | `touch-action: manipulation` |
| Overscroll (page) | `none` only in standalone; `overscroll-behavior-x: none` globally is allowed for editors with unsaved state |
| Overscroll (container) | `contain` |
| Snap paging | `scroll-snap-type: x mandatory; scroll-snap-stop: always` |
| Keyboard | VirtualKeyboard API, `visualViewport` fallback, move with `transform` |
| Focus after sheet | ~350ms or on animation complete |

### Code

The base layer:

```css
@layer base {
  * { -webkit-tap-highlight-color: transparent; }   /* or match the design's press colour */

  html {
    -webkit-text-size-adjust: 100%;
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  button, [role="button"], a, label, summary, input[type="checkbox"], input[type="radio"] {
    touch-action: manipulation;
  }

  /* Chrome is UI. Content is content. */
  nav, header, footer, button, [role="button"], label {
    -webkit-user-select: none; user-select: none;
  }
  p, article, main, li, td, [contenteditable] {
    -webkit-user-select: text; user-select: text;
  }

  img:not([data-saveable]) { -webkit-touch-callout: none; }

  :focus { outline: none; }
  :focus-visible { outline: 2px solid var(--focus-ring, currentColor); outline-offset: 2px; }

  input, textarea, select {
    font-size: max(16px, 1rem);
    -webkit-appearance: none;
  }

  @media (hover: hover) {
    /* hover-only styles live here */
  }

  @media (display-mode: standalone) {
    html, body { overscroll-behavior: none; }
  }
}
```

Viewport and opt-in PWA meta:

```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, interactive-widget=resizes-content">
<meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#111111" media="(prefers-color-scheme: dark)">
<!-- Only when the project is an installable app: -->
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
```

Keyboard inset:

```ts
if ("virtualKeyboard" in navigator) {
  (navigator as any).virtualKeyboard.overlaysContent = true;
}
// Fallback for everything else
const vv = window.visualViewport;
function update() {
  if (!vv) return;
  const inset = window.innerHeight - vv.height - vv.offsetTop;
  document.documentElement.style.setProperty("--kb", `${Math.max(0, inset)}px`);
}
vv?.addEventListener("resize", update);
vv?.addEventListener("scroll", update);
```

```css
.composer {
  position: fixed; inset-inline: 0; bottom: 0;
  padding-bottom: calc(8px + env(safe-area-inset-bottom, 0px));
  transform: translateY(calc(-1 * var(--kb, 0px)));
}
@supports (bottom: env(keyboard-inset-height)) {
  .composer { bottom: env(keyboard-inset-height, 0px); transform: none; }
}
```

Snap paging:

```css
.pager { display: flex; overflow-x: auto; scroll-snap-type: x mandatory; scroll-snap-stop: always; }
.pager > * { flex: 0 0 100%; scroll-snap-align: start; }
```

### Anti-advice

Widely recommended, wrong today:

| Advice | Why not | Instead |
|---|---|---|
| `-webkit-overflow-scrolling: touch` for momentum | Default since iOS 13 | Delete it |
| `position: fixed` on body to lock scroll | Loses scroll position, breaks keyboard | `<dialog>` + `overscroll-behavior: contain`, or `inert` |
| `user-select: none` globally | People copy text | Chrome none, content text |
| JS smooth-scroll libraries | Fight the platform, tank INP | `scroll-behavior: smooth` on the container, or nothing |
| `will-change: transform` everywhere | Memory per layer | Only after a measured first-frame stutter |
| `100vh` + resize listener | Jumps on scroll | `dvh` or `svh` |
| `maximum-scale=1` | Fails WCAG; ignored by Safari | Fix input sizes |
| Custom momentum scroller | Never matches the platform curve | Native scroll |

### Checks

- Focus every input on an iPhone: no zoom.
- Viewport meta: `viewport-fit=cover`, no `user-scalable`, no `maximum-scale`.
- `grep -rn "100vh"`: zero hits or each justified.
- `grep -rn "overscroll-behavior"`: page-level rule only inside `display-mode: standalone`, or an editor with the decision written down.
- DevTools touch emulation: every hover action reachable.
- 320px width: no horizontal scrollbar.
- Composer above the keyboard on iOS and Android.
- One real-device pass on each platform.

### Do not

- Disable zoom.
- Use the safe-area inset as the whole padding.
- Put `overscroll-behavior: none` on the page in a browser tab, unless unsaved work is one edge swipe from being lost and the contract says so.
- Hide an action behind hover with no touch path.
- Focus an input while a sheet is still animating.
- Build a custom scroller.

<!-- references/typography.md -->

## Typography

Use this when you are setting a type scale, styling text in components, truncating or wrapping, tuning line-height and tracking, loading fonts, or auditing text for hierarchy and legibility.
Pair with `references/layout-and-spacing.md` for measure and rhythm and `references/accessibility.md` for zoom and reflow.

### Rules

1. **Never introduce a typeface during polish.** Polish works inside the project's faces. A review checklist is not a reason to license or add a font. A face introduced by the polish pass (Inter or any other) is a tell, not an improvement. Check: the font stack after your changes equals the font stack before.
2. **Roles carry hierarchy; three sizes do most of the work.** Display, title, heading, body, caption. Most screens use three of them. If a screen needs a sixth size, the hierarchy is the problem, not the scale.
3. **Emphasis within a role is one weight step.** 400 to 500, or 500 to 600. Never a size change, never bold-plus-colour-plus-italic. Check: no element uses two emphasis devices at once.
4. **Line-height by role, always unitless.** Headings about 1.1; body 1.5–1.6; anything that wraps to three or more lines needs at least 1.4, even inside a tight row. A unit value stops scaling when the user zooms the text.
5. **Letter-spacing by size.** Large headings slightly negative (−0.02em at 28px+), small uppercase labels positive (+0.05em), body untouched. One value for all sizes is wrong at both ends.
6. **Measure 60–75 characters.** `max-width: 65ch` on prose. At 16px that is roughly 560–680px, Tailwind `max-w-xl` or `max-w-2xl`. Wider reads as a wall; narrower reads as a column of fragments.
7. **Wrap by length.** `text-wrap: balance` on headings, and know it is silently ignored past 6 lines in Chromium and 10 in Firefox. `text-wrap: pretty` on paragraphs, descriptions, captions, card text. Neither on long-form; the cost is paid on every reflow.
8. **Break what must not overflow.** `overflow-wrap: break-word` (or `anywhere`) on IDs, URLs, and user strings. `white-space: nowrap` on labels, badges, and buttons. Truncate with `text-overflow: ellipsis` only when the full value is reachable elsewhere (tooltip, detail view).
9. **Weight floors.** Below 18px stay at 400 or above. Weights 100–300 are display-only, 28px and up. Thin text at small sizes disappears on non-Retina screens and in dark mode.
10. **Size floors.** Long-form body about 16px; UI text 14px; captions 13px; 12px rarely and never for anything the user must read to act.
11. **Inputs are at least 16px on mobile.** Below 16px iOS Safari zooms the page on focus. Use `font-size: max(16px, 1rem)` or Tailwind `text-base sm:text-sm`. Never `maximum-scale=1` or `user-scalable=no`: Safari ignores it for pinch, every other browser honours it, and it fails WCAG 1.4.4.
12. **Properties over raw OpenType tags.** `font-weight: 650`, not `font-variation-settings: "wght" 650`. `font-variant-numeric: tabular-nums`, not `font-feature-settings: "tnum"`. `font-optical-sizing: auto`, not `"opsz"`. Raw tags only for custom axes (`"GRAD" 80`) and stylistic sets (`ss01` to `ss20`, `cv01` to `cv99`).
13. **Tabular numbers on anything that changes.** Counters, timers, live prices, table number columns, animated values, scores. Not on static display numbers, decorative large numerals, phone numbers, postcodes, or version strings; tabular figures widen the 1 and look spaced-out at rest.
14. **Formats and loading.** `.woff2` only; `.woff` as a legacy fallback if the project supports old browsers; `.ttf` and `.otf` never on the web. `font-display: swap` for body faces, `optional` for decorative ones. Preload the one body face used above the fold. Use `size-adjust` on the fallback to stop the swap from shifting layout.
15. **Font smoothing once, on the root.** `-webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;` (Tailwind `antialiased`). Not per component.
16. **Underlines come from the font.** `text-underline-position: from-font; text-decoration-thickness: from-font;` or manual `text-decoration-thickness: 1px; text-underline-offset: 3px; text-decoration-skip-ink: auto;`. Only `text-decoration-color` animates reliably; if the underline must grow or slide, build it as a separate element.
17. **Trim the leading box in badges and buttons.** `text-box: trim-both cap alphabetic` (Chromium 133+, Safari 18.2+, no Firefox) as a progressive enhancement. Without it, centre text optically with 1px asymmetric padding rather than pretending the box is centred.
18. **Smart punctuation.** Curly quotes, en dash for ranges, ellipsis as one character, `&nbsp;` between a number and its unit, `&shy;` for long compound words. Em-dashes in interface copy are a house decision recorded in the design contract; the default is none.
19. **Bidi and script.** Never reverse digits. Paragraphs of three or more lines align to their own script's direction with `text-align: start` and a correct `lang`/`dir`. Wrap mixed-direction values (usernames, file names) in `<bdi>`.
20. **Text stays selectable.** Including application chrome. `user-select: none` only on an element with a verified drag or gesture conflict.
21. **`font-synthesis` only after verifying.** Turn synthesis off only when every bold, italic, small-cap, superscript, and subscript form exists across the full fallback stack. Prefer the longhands (`font-synthesis-weight: none`).
22. **Variable-font axis honesty.** A face's weight axis may run 350–900 or 425–625, not 100–900. Map named weights (regular, medium, semibold, bold) to real axis values in exactly one place, and let every renderer (DOM, canvas, export) read that map. A "semibold" that resolves to the same number as "bold" is a bug you find at 2am.
23. **Pair for contrast, not similarity.** Rarely more than three faces. A serif with a sans, a mono for data. "Display" in a font's name does not make it a display face; pick by size, and if the family ships Text and Display cuts, switch at about 20px.
24. **X-height explains size mismatch.** Two faces at the same `font-size` look different sizes because their x-heights differ. Retune size and line-height per face; never swap faces at a fixed size.

### Cheat sheet

| Role | Size | Line-height | Weight | Tracking |
|---|---|---|---|---|
| Display | 2.25rem / 36px | 1.1 | 600 | −0.02em |
| Title | 1.5rem / 24px | 1.2 | 600 | −0.01em |
| Heading | 1.125rem / 18px | 1.3 | 600 | 0 |
| Body | 1rem / 16px | 1.5 | 400 | 0 |
| Caption | 0.8125rem / 13px | 1.4 | 400 | 0 |
| Uppercase label | 0.75rem / 12px | 1 | 500 | +0.05em |

| Tabular numbers | Use | Do not use |
|---|---|---|
| | counters, timers, updating prices, table number columns, animated transitions, scores | static display numbers, decorative large numerals, phone numbers, postcodes, version strings |

| Wrapping | Property |
|---|---|
| Headings up to 6 lines | `text-wrap: balance` |
| Paragraphs, cards, captions | `text-wrap: pretty` |
| Long-form (10+ lines) | neither |
| IDs, URLs, user strings | `overflow-wrap: anywhere` |
| Labels, badges, buttons | `white-space: nowrap` |

| Punctuation | Use |
|---|---|
| Quotes | “ ” ‘ ’ |
| Range | 2010–2020 (en dash) |
| Ellipsis | … (one character) |
| Number and unit | `16&nbsp;px` |
| Long compound | `super&shy;calif…` |

### Code

Root and roles (example scale; the project's values win):

```css
html {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
}
h1, h2, h3 { text-wrap: balance; }
p, li, figcaption { text-wrap: pretty; }
input, select, textarea { font-size: max(16px, 1rem); }
.prose { max-width: 65ch; line-height: 1.55; }
.display { font-size: 2.25rem; line-height: 1.1; font-weight: 600; letter-spacing: -0.02em; }
.tnum { font-variant-numeric: tabular-nums; }
.eyebrow { font-size: 0.75rem; line-height: 1; font-weight: 500; letter-spacing: 0.05em; text-transform: uppercase; }
a { text-decoration-thickness: from-font; text-underline-position: from-font; text-underline-offset: 3px; transition: text-decoration-color 200ms ease-out; }
.badge { text-box: trim-both cap alphabetic; } /* progressive enhancement */
```

Font loading with a size-adjusted fallback (example):

```css
@font-face {
  font-family: "Body";
  src: url("/fonts/body.woff2") format("woff2");
  font-weight: 300 800;
  font-display: swap;
}
@font-face {
  font-family: "Body Fallback";
  src: local("Arial");
  size-adjust: 97%;
  ascent-override: 92%;
}
:root { --font-body: "Body", "Body Fallback", system-ui, sans-serif; }
```

Axis map in one place (example):

```ts
export const FONTS = {
  brand: { family: "Brand Sans", axis: [425, 625] as const, weights: { regular: 425, medium: 525, semibold: 575, bold: 625 } },
  mono:  { family: "Brand Mono", axis: [400, 700] as const, weights: { regular: 400, medium: 500, semibold: 600, bold: 700 } },
} as const;
// Every renderer (DOM class, canvas ctx.font, export) reads FONTS.brand.weights.semibold, never a literal 600.
```

Tailwind mapping: `text-base sm:text-sm` for inputs, `tabular-nums`, `text-balance`, `text-pretty`, `antialiased`, `tracking-tight` (−0.025em) on display, `tracking-wide` (+0.025em) on uppercase labels, `max-w-prose` (65ch).

### Checks

- Font stack unchanged after polish.
- Every text element maps to one of five roles; no ad-hoc sizes.
- Zoom to 200%: nothing clips, nothing overlaps.
- Width 320px: headings balance, prose wraps, labels do not break mid-word.
- Grep for `font-feature-settings: "tnum"` and `"wght"`: replaced with properties.
- Inputs measure ≥ 16px on a phone; no `maximum-scale` in the viewport meta.
- Every changing number has `tabular-nums`; every static display number does not.
- Long German and Finnish strings in labels do not overflow.
- Selection works on every text element; `user-select: none` only where a gesture conflicts.

### Do not

- Add a typeface, or swap one, as part of a polish pass.
- Use size to emphasise inside a role.
- Set line-height in `px`.
- Apply one letter-spacing to every size.
- Use `balance` on long-form or on anything that can exceed six lines.
- Ship `.ttf`, `.otf`, or an icon font.
- Turn off `font-synthesis` without testing every form.
- Rely on the browser to centre text vertically in a small box.



---

