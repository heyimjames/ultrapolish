---
name: ultrapolish-web
description: Universal polish for web apps and sites built with React, TypeScript, and CSS. Takes a competent interface to a beloved one within its own visual style; never introduces a palette, typeface, or motion personality. Use whenever the user is building, reviewing, auditing, or refining a web UI and wants it to feel considered, cohesive, premium, and detailed. Covers easing and springs, gestures and scroll, colour (OKLCH, APCA, dark mode), typography, 4px layout, surfaces, buttons, forms, tables and dense data, overlays, haptics, icons, copy, states, onboarding and pricing, mobile web, performance, accessibility, marketing pages. Triggers on polish, feels generic, audit UI, easing, spring, Motion, hover, focus ring, shadow, radius, modal, sheet, popover, toast, form, input, button, icon, contrast, empty state, layout shift, iOS Safari, safe-area, reduced motion, a11y, landing page, design tokens, table, data grid, search, bulk actions, command palette, favicon, app icon, file upload, drag and drop, video player.
---

# ultrapolish-web

Universal polish for web interfaces. Any app or site, its own style, from 6/10 to 11/10 on detail, UX, and cohesion.

This is not a visual style. It is a craft standard and a procedure. It works with editorial monochrome, with dense data tools, with playful consumer apps. It makes what is already there feel considered, continuous, and alive.

## 0. The universality guard

Read this before touching a pixel.

1. **Read before you write.** Find the project's own rules: `DESIGN.md`, `AGENTS.md`, `CLAUDE.md` design sections, `globals.css`, `tailwind.config`, `@theme` blocks, token files, a `motion.ts`, a components directory. Grep for `--radius`, `--ease`, `cubic-bezier`, `transition:`, `box-shadow`, `font-family`, `@media (prefers-`. Build the intake table (section 1) before proposing anything.
2. **Never introduce what the project does not have.** No new typeface, no new palette, no new radius language, no new motion personality. If the site is sharp and flat, polish it sharp and flat. If it is soft and rounded, polish it soft and rounded.
3. **Numbers here are defaults for projects without an established value.** The project's own token wins whenever it is used consistently. Inconsistency is the finding; the value is not.
4. **The anti-pattern list is a negative list.** It says what reads as generic or careless. It does not imply a positive style.
5. **No system? Propose one before polishing.** Offer the 15-line design contract from `references/design-contract-template.md`, get it agreed, then work inside it. Polishing without a contract produces a second, competing style.
6. **Restraint is a deliverable.** The right change is often "remove", "align", or "reuse". Every finding must name what the user gains. If you cannot, it is not a finding.

7. **Look at it.** Reading the code tells you what was intended; only the rendered result tells you what happened. Render the screen, screenshot it, and play any motion back at a tenth speed before writing a finding about it. Half the findings worth having are invisible in the source: the thing that lands a frame late, the two greys that turned out identical, the row that reflows at the second breakpoint, the state nobody wired up. A finding you have not seen is a guess, and it belongs in the output marked as one.
## 1. Workflow

### 1.1 Intake (always, ~2 minutes)

| Dimension | What the project already does | Source |
|---|---|---|
| Type | Faces, weights, scale, line-heights, `text-wrap` | `font-family`, `@theme`, `text-*` classes |
| Colour | Token names, light/dark mechanism, accent(s), how muted and disabled are made | `globals.css`, `:root`, `[data-theme]` |
| Radii | Distinct values, whether nested radii are concentric | `--radius*`, `rounded-*` |
| Spacing | Grid step, container padding, gaps | `gap-*`, `p-*`, `--spacing` |
| Motion | Easing tokens, durations, spring library, `prefers-reduced-motion` handling | `--ease*`, `transition`, `motion/react` |
| Surfaces | The elevation ladder and its L steps, where shadows and hairlines are still used, image outlines | `--surface`, `--raised`, `box-shadow`, `border` |
| Overlays | Modal/sheet/popover library, z-index scale, focus handling | `<dialog>`, Base UI, Radix, Vaul, `--z-*` |
| Forms | Input height, error placement, validation timing | `<input>`, `aria-invalid` |
| States | Which of empty / loading / error / success / offline exist | skeleton components, `Suspense` |
| Copy | Case, voice, emoji, punctuation, verb-first or not | strings, `<Button>` children |

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

- **Elevation is a step in value.** `--ground` / `--surface` / `--raised` / `--overlay`, about 2–3 points of L apart in the light and 3–4 in the dark, all carrying the palette's hue at C 0.004–0.016 so no grey is dead. Not a shadow, not a border. If two surfaces do not separate, increase the step.
- **Hover moves a rung**, 150ms, background only. Nothing translates: a lift promises a click.
- **Shadows mean one thing**: this floats above the page and can be dismissed. Popovers, menus, toasts, dragged items: `0 12px 32px oklch(0 0 0 / 0.18)` tinted toward the canvas hue. Never on a card, a row, or a section. For a modal the scrim and the pushed-back page do the work; the shadow is a detail.
- **Hairlines only where no step is available**, such as rows inside one card: `--hairline: 1px`, `0.5px` at `min-resolution: 2dppx`. A grid of separately outlined cards is the template tell.
- **Image outline** (non-negotiable on user content): `outline: 1px solid oklch(0 0 0 / 0.1)` light, `oklch(1 0 0 / 0.1)` dark, `outline-offset: -1px`. Never a tinted grey; it reads as dirt.
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

### Motion and transitions → `references/motion.md`

Name every property you transition. Build a motion vocabulary of 5–8 named tokens, each with a job, and the rule "if a new animation does not fit one of these, don't". Write the storyboard as a comment above the tokens. Frequency decides motion: rare gets the fuller transition, daily gets instant. The ceiling on "rare" is choreography, never a set piece; there is no confetti at any frequency. Exits accelerate. Loops act, rest, then ease home; never snap. Skip entrance animation on page load for above-the-fold chrome. Replay at 10% speed in the Animations panel before shipping.

### Springs, gestures and scroll → `references/springs-and-gestures.md`

Velocity beats position: dismiss on > 500px/s regardless of distance; upward flick always cancels. Rubber-band with Apple's constant 0.55. Animate from the current value, never the target; blend velocity on reversal. `layout` animations: wrap text in `layout="position"`, put `layoutScroll` on scroll containers, and keep border-radius inline. Scroll snap paging needs `scroll-snap-stop: always`. Do not build a custom scroller.

### Colour, dark mode and theming → `references/color.md` and `references/theming-and-dark-mode.md`

OKLCH palette algorithm with per-step chroma clamping. Semantic tokens over base tokens; lint-ban base tokens outside the token file. One accent per view. Increased contrast variant widens the L gap by ≥ 0.15. Per-locale gain/loss colours.

### Typography → `references/typography.md`

Role-based scale, one weight step for emphasis, measure 60–75ch, `text-wrap` by length, `text-box: trim-both cap alphabetic` for badges and buttons where supported, underlines from the font, smart punctuation, `<bdi>` for mixed-direction values, `font-synthesis` only after verifying every face. Variable-font axes: map named weights to the real axis range in exactly one place.

### Layout, spacing and hierarchy → `references/layout-and-spacing.md`

The eye lands on the headline, then the primary action, within a second. One primary per view. Group by space. Controls distinct from content. Hint at hidden content with a peek. Hold structure until it breaks; collapse late. Design for two items and for two hundred. Plan for i18n: no fixed widths sized to English, `min-height` not `height`.

### Surfaces and depth → `references/surfaces-and-depth.md`

Shadow-as-border recipes, hairlines, image outlines, concentric radii, the backdrop-filter budget, and the rule that bigger surfaces read as thicker (stronger blur, deeper shadow). Never stack two translucent surfaces.

### Buttons and controls → `references/buttons-and-controls.md`

Six states with exact values. Width-locked loading. The Done → Cancel · Save state machine. Tooltip warmth. Optical alignment: the icon-side padding is 2px less than the text-side; a play triangle nudges `translateX(2px)`.

### Forms and inputs → `references/forms-and-inputs.md`

Inputs ≥ 16px on mobile, `-webkit-appearance: none`, never disable submit until valid, validate on submit then `aria-invalid` + `aria-describedby` + focus the first invalid field, `autocomplete` tokens are a WCAG requirement, `inputmode` for OTP and money, never block paste, trim before validating, placeholders are examples not labels, focus after a sheet finishes animating, handle the virtual keyboard inset.

### Tables, search and working with many things → `references/data-and-density.md`

A dense tool is not a consumer app with smaller padding. Numbers right-align and go tabular so a magnitude is visible without reading; text left-aligns; nothing centres. Row height is a documented decision, and a professional table may sit between the 24px floor and the 40px pointer default where a consumer app may not. Headers stick and sort with `aria-sort`. Search debounces at 300ms and never replaces readable rows with a spinner. Active filters are visible chips with a count of what is hidden. Select-all means the page; "all 340" is a second explicit action. Bulk actions name the verb, the count and the noun. Arrows move, Space selects, Shift extends, single-key shortcuts never fire while someone is typing.

### Files: uploading, attaching and downloading → `references/files-and-uploads.md`

The drop zone is a convenience; the real `<input type="file">` behind a real label is the interface, because dragging is invisible, impossible on touch and unreachable by keyboard. Hide the input visually, never with `display: none`. Count drag depth or the highlight flickers on every child. Print the limits before they are hit, validate on selection and again on the server, and upload the valid files out of a mixed batch rather than rejecting all of them. Show the row with a local thumbnail before the network starts, because whether the right file was picked is knowable instantly. Progress in bytes per file, never a stuck 99%. Cancel aborts, failure keeps the file and offers Retry without re-picking, and paste is a real upload path. Downloads get a real name with a real extension.

### Overlays → `references/overlays.md`

Modal, sheet, drawer, popover, tooltip, toast: enter, exit, focus, dismissal, and the paired-element rule. Sheet choreography with the 80ms content offset. Toast floor 5s with pause on hover. Prefer inline state over toasts for anything contextual.

### Haptics and sound on the web → `references/haptics-and-sound.md`

`navigator.vibrate` on `pointerdown` only (light 8ms, medium 15, heavy 25, error `[10, 40, 10]`); never on scroll, hover, load, or appearance. iOS Safari has no vibration API; a switch-input trick exists and is fragile. Sound is almost always wrong on the web: it ignores the ringer switch. Exceptions are opted-in tools (metronome, timer, game).

### The favicon and app icon set → `references/app-icon-and-favicons.md`

The smallest thing you will design and the one seen most often. Design it at 16px first, because everyone designs at 512 and scales down and that is why so many are grey smudges. One idea, never the wordmark. Greyscale and blur it, then put it in a row with the twenty favicons your users actually have open; if it disappears, the shape is the problem. A favicon fills its box and a home-screen icon does not, so they are different files. Never bake in rounded corners. `apple-touch-icon` must be opaque, because iOS composites transparency onto black. Maskable icons keep content inside the centre 80%. The SVG favicon can answer dark mode; `theme-color` is the colour of the top of the page, not the brand. Ship the ICO at the root anyway, because crawlers request it without reading your markup.

### Icons → `references/icons.md`

Stroke matches text weight: 1.5px beside 400, 2px beside 500–600, 2.5px beside 700. `currentColor` only, one asset per icon, outline default and fill active, sized 1em–1.25em inline, native 16/20/24 grids. RTL flip table. Lucide's default stroke 2 is heavy next to most body text; use 1.5–1.75 with `absoluteStrokeWidth`.

### Copy and naming → `references/copy-and-naming.md`

Verb-first buttons that name the noun. Sentence case by default. "Continue" or "Next", pick one. Links describe the destination, never "Click here". Toggles label the ON state. Errors are calm, plain, and say what to do. Device verbs: tap on touch, click with a pointer, select when both. Never concatenate strings around variables. Defaults: no emoji in interface chrome, no em-dashes in UI copy; house style may override both in the design contract.

### States → `references/states.md`

The loading ladder, skeleton rules, optimistic ghosts, empty-state anatomy, error placement, and the feedback taxonomy: minor reversible → toast with Undo; contextual → inline at the thing; the app acted for you → a receipt; destructive → confirm with the noun.

### Onboarding and pricing → `references/onboarding-and-pricing.md`

Value in three seconds. Four or five steps, one purpose each. Progress as dots, not a bar. CTA never moves. Intro animations gated by `sessionStorage`. Pricing: state the price plainly, show total and per-month, one paid tier, no fake anchors, no countdowns, Close visible from frame one, restore and terms always present. The honesty test: would this still work if the person understood it completely?

### Touch and mobile web → `references/touch-and-mobile.md`

The base layer: `-webkit-tap-highlight-color: transparent`, `text-size-adjust: 100%`, `touch-action: manipulation`, `user-select: none` on chrome and `text` on content, `dvh` for fill and `svh` for fixed chrome, `viewport-fit=cover`, `overscroll-behavior: none` only in standalone mode. The anti-advice table: no `user-scalable=no`, no `position: fixed` on body to lock scroll, no JS smooth-scroll libraries, no `100vh` + resize listener.

### Scroll → `references/scroll.md`

Momentum is the platform's; do not fake it. Snap with `scroll-snap-stop: always` for paging. Scrollbars only inside panels, never restyled on the page. `scroll-margin-top` on every anchored id. Sticky headers shrink with `animation-timeline: scroll()`. Scroll edge effects, not hard dividers, where content meets floating chrome.

### Performance → `references/performance.md`

Budgets, the frame-killer ranking, `content-visibility`, prefetch on pointerdown, virtualisation thresholds, the theme-switch suppressor, and `visibilitychange` timer freezes.

### Canvas and generated media → `references/canvas-and-media.md`

When the product is the pixels, most of this skill's tooling stops working: the accessibility tree is empty, CSS reaches nothing, and the render loop is the real performance budget. Name the canvas with `role="img"` and a live label, put meaning in `aria-valuetext` rather than a raw number, and give every canvas-only action a real DOM control. Ask for `{ colorSpace: "display-p3" }` or wide-gamut values clamp silently, and remember an invalid `fillStyle` is a no-op that keeps the previous colour. Back the store at `devicePixelRatio`, stop the loop off screen and when hidden, restart from now, and check reduced motion in JS because CSS cannot reach a loop. One renderer for preview and export: if changing the export resolution does not change the pixel dimensions of the file, the export path is a lie.

### Video and audio playback → `references/media-playback.md`

A player is used in the dark, one-handed, on a train. The only defensible autoplay is `autoplay muted playsinline loop` with no controls, and even that shows a poster instead under Reduce Motion. Without `playsinline`, iOS takes the whole screen. Custom controls are a commitment to rebuild keyboard access, captions, playback rate, picture-in-picture and the OS media keys, so most products should style the container and keep the native ones. Space toggles when the player has focus and must not scroll the page. A 4px scrub line needs a 24px target, and seeking follows the finger linearly, never with a spring. Time is tabular. Buffering and paused look different. Captions are for the many people watching with the sound off. One thing plays at a time.

### Accessibility as polish → `references/accessibility.md`

`:focus-visible` only; keep the browser ring plus `outline-offset: 2px` or verify a custom ring against every adjacent colour. Roving tabindex for composite widgets. `.sr-only` at 1px, not 0. Announcement ladder: focus move → `aria-describedby` → `role="status"` → `role="alert"`. Reduced motion is opt-in (`no-preference`), the global kill switch uses `0.01ms` not `none` so `transitionend` still fires. Zoom to 200% and reflow at 320px. `rem` for type and breakpoints, `px` for hairlines and rings. Alt by purpose. SPA route change moves focus to the new `<h1>`.

### Marketing pages → `references/marketing-pages.md`

No scroll-triggered fade-ups on every section; no scroll hijacking; no non-1:1 parallax; no auto-advancing carousels. One orchestrated moment beats scattered effects. Spend boldness in one place. OG images survive at 200px wide: headline ≥ 80px at 1200 wide, 3–8 words, one focal point, tested in greyscale.

### Native feel → `references/native-feel.md`

The default for app-like products and wrong for site-like ones. A dashboard, an editor, a tool, a PWA or anything behind a login takes the whole iOS layer unless the design contract opts out; marketing, documentation and landing pages take the neutral references only. All or nothing when taken, because a sheet that drags without carrying velocity into its settle is worse than one that does not drag, and a push without an interruptible back-swipe is worse than a fade. A project's own established motion or type system still wins over any of it, exactly as the universality guard says everywhere else.

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
| Elevation | A step in surface value, 2–3 L in light and 3–4 in dark, carrying the palette hue. Shadows are reserved for things that genuinely float; hairlines only where no step is available |
| Empty states | Show the destination, not just the door: name, one line, a ghosted preview of the filled state, one action |
| Celebration | No particles, no set pieces, at any frequency. The budget goes into every ordinary interaction instead |
| Elevation | A step in surface value, 2 to 3 points of L in light and 3 to 4 in dark, carrying the palette hue. Shadows mean only "this floats and can be dismissed"; hairlines only where no step is available |
| Hover | Background moves a rung, 150ms, nothing translates. A lift promises a click |
| Native feel | The default for app-like products (a tool, an editor, a dashboard, a PWA, anything behind a login) and wrong for site-like ones. All or nothing when taken, because the half that behaves natively teaches people to expect the other half. An established motion or type system still wins over it |
| Palette choice | Justify the hue family in one sentence about the product. Neighbours within 60 degrees read as one family; semantic colours sit 25 degrees off the accent. One L ramp and one chroma percentage across every hue. Muddy is chroma too low, not too high |
| Type detail | Ligatures off wherever a character must be transcribed; slashed zero on codes only; lining and oldstyle figures never mixed in a view; real small caps or none; stylistic sets declared once at the root |
| Grid | 4px base, 8px rhythm, 16 to 24 container padding. Not 8-only |
| Icon states | Two: outline at rest, filled when active. Never a third that is only a colour |
| Conflicting findings | Correctness, reach, comprehension, the project's conventions, responsiveness, continuity, character, in that order. A lower concern never overrides a higher one, and the order maps onto severity |
| Data in motion | Interpolate the presentation, never the value. A number a person could act on is never smoothed through figures that were not true |
| Icon transitions | Rotate when it is the same shape at another angle; only morph or replace when the drawings genuinely differ |

## 8. Further reading inside this skill

- `references/anti-patterns.md` for the long-form tells with the fix for each
- `references/audit-checklist.md` for the printable checklist with the "how to check" column
- `references/design-contract-template.md` for the 15-line contract and a filled example
- `assets/` for drop-ins: `motion.css`, `gen-springs.mjs`, `motion.ts`, `base.css`, `theme-switch.ts`, `utilities.css`, `skeleton.css`, `shadows.css`
