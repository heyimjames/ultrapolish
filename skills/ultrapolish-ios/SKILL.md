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
5. **No system? Propose one before polishing.** Offer the 15-line design contract from `references/design-contract-template.md`, get it agreed, then work inside it. Polishing without a contract produces a second, competing style.
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

## 8. Further reading inside this skill

- `references/anti-patterns.md` for the long-form tells with the fix for each
- `references/audit-checklist.md` for the printable checklist with the "how to check" column
- `references/design-contract-template.md` for the 15-line contract and a filled example
- `assets/` for drop-in Swift: `Motion.swift`, `Haptics.swift`, `PressableButtonStyle.swift`, `DisplayP3Color.swift`, `LoadingButton.swift`, `OnboardingDots.swift`, `Shimmer.swift`, `SheetPresets.swift`
