# Anti-patterns and AI tells

Use this when a screen "feels generic" and you cannot say why, or as the last pass before shipping. Every entry names why it reads as careless, the fix, and a way to find it in code. The list is negative: removing these does not impose a style, it removes the smell of no style.

## Motion

### The breathing symbol
An SF Symbol that pulses, breathes, or bounces while nothing is happening.
Why it reads as careless: it is the default "make it feel alive" move from every template. It also lies; nothing is happening.
Fix: remove the idle effect. Keep `.symbolEffect(.replace)` for state changes and one `.bounce` on a real event.
Spot it: `grep -rn "symbolEffect(.breathe\|symbolEffect(.pulse\|repeatForever" Sources/`

### The teleport
A value changes and the view jumps to its new state with no transition.
Why: the eye loses the object; it looks like a bug or a reload.
Fix: `.animation(Motion.state, value: model.value)` on the container, `.contentTransition(.numericText())` on numbers.
Spot it: state-bearing views with no `.animation(_:value:)` nearby; toggle the state in a preview and watch.

### The unscoped animation
`.animation(.default)` with no `value:`, or `withAnimation` wrapping a big state change.
Why: everything animates, including things that should not, and unrelated layout jitters.
Fix: every `.animation` gets a `value:`; `withAnimation` wraps only the assignment it is about.
Spot it: `grep -rn "\.animation(\.[a-zA-Z]*)" Sources/ | grep -v "value:"`

### Springs on the finger
A slider, scrubber, or drag that lags behind the touch.
Why: the finger is the truth; a spring argues with it.
Fix: `.linear` or no animation while dragging; spring only on release, seeded with the gesture velocity.
Spot it: `DragGesture` bodies that call `withAnimation(.spring`.

### Exit that lingers or bounces
The sheet takes as long to leave as it took to arrive, and overshoots on the way.
Why: people want out faster than they wanted in; a bouncy exit feels needy.
Fix: exit at ~0.65× the entrance duration with `bounce: 0`.
Spot it: the same `Animation` constant used for present and dismiss.

### Everything staggers, always
List rows cascade in every time the view appears or scrolls.
Why: the second time it is a delay, not a delight.
Fix: stagger on first appearance only (a `hasAppeared` flag), 30–80ms, cap ~8 items.
Spot it: `.delay(Double(index)` without a guard.

### The 60fps Timer
A `Timer.publish(every: 1/60)` driving UI.
Why: it burns battery, drifts, and fights the display refresh rate.
Fix: `TimelineView(.animation)` for ambient loops; `Text(timerInterval:)` for clocks.
Spot it: `grep -rn "Timer.publish\|Timer.scheduledTimer" Sources/`

### Title in, title out
On push, the title animates out of the source and back into the destination.
Why: the same object leaves and returns; the screen reads as two places instead of one that changed.
Fix: render persistent chrome in a parent that survives the transition (`NavigationStack` title, toolbar).
Spot it: the same `Text(title)` inside both source and destination bodies.

## Colour

### The template gradient
Purple to blue to pink, or any gradient interpolated in RGB with a grey trough in the middle.
Why: it is the most-shipped AI colour choice of the decade, and the RGB lerp is muddy.
Fix: compute stops in OKLCH and pass explicit `stops:`; add ≤ 5% grain to stop banding.
Spot it: `LinearGradient(colors: [.purple, .blue` or any two-colour gradient across hues.

### sRGB by accident
`Color(red:green:blue:)` with no colour space.
Why: it silently produces sRGB on a P3 display; the accent looks dull next to system colours.
Fix: `Color(.displayP3, red:green:blue:)` or a P3 hex helper.
Spot it: `grep -rn "Color(red:" Sources/ | grep -v displayP3`

### One hex, no pair
A colour literal with no dark-mode counterpart.
Why: it either glares or vanishes in the other appearance.
Fix: light/dark pairs via the asset catalog or `Color.pair(light:dark:)`.
Spot it: hex literals outside the token file.

### True black by default
`Color.black` as the app background in a non-media app.
Why: pure black makes every shadow disappear and every surface float; it is a media decision, not a default.
Fix: near-black carrying the palette's hue; elevation via a 1pt white 6% stroke.
Spot it: `.background(.black)` or `Color.black` at the root.

### Disabled means grey
`.opacity(0.4)` or a grey fill for a disabled control, with no explanation.
Why: grey reads as broken; opacity fails contrast unpredictably.
Fix: transparency with the control's own colour, plus a reason string next to it.
Spot it: `.disabled(` with no adjacent explanatory `Text`.

### Colour alone carries meaning
A red row means overdue; nothing else says so.
Why: 8% of men cannot see it.
Fix: pair with a symbol or a label.
Spot it: status views with `foregroundStyle` and no `Image` or text.

## States

### Spinner on the button
Tap a button and it spins in place.
Why: progress belongs where the result will appear; the button is where the action was.
Fix: the spinner travels: into the bubble, the thumbnail, the row.
Spot it: `ProgressView()` inside a `Button` label.

### Spinner under 500ms
Every fetch shows a spinner immediately.
Why: it flashes, and a flash reads as instability.
Fix: nothing before 500ms (optimistic if possible), then a matching skeleton.
Spot it: `isLoading` bound directly to a `ProgressView` with no delay.

### Skeleton that lies
Three grey bars for content that will have five lines and an image.
Why: the swap is a layout shift; the illusion breaks.
Fix: skeletons mirror the real layout exactly.
Spot it: compare the skeleton view and the loaded view side by side.

### Toast in the sky
A field fails validation and a toast appears at the top of the screen.
Why: the error is far from its cause; the user looks at the field, not the sky.
Fix: inline, under the field, rising from it; toasts only for reversible global outcomes.
Spot it: a single global `ToastView` bound to every error.

### "No items."
An empty list says "No items" and nothing else.
Why: it is the first impression for every new user, and it apologises.
Fix: a symbol, one warm line of why, one action.
Spot it: `ContentUnavailableView` with no `actions:`; `Text("No ` in empty states.

### Undo that only hides the toast
"Undo" dismisses the message and leaves the deletion in place.
Why: it is a lie with a button on it.
Fix: undo reverses the effect; otherwise do not offer it.
Spot it: the undo closure touches only UI state.

## Controls

### The glyph-only target
An icon button whose tappable area is the icon itself.
Why: a 24pt target misses half the time.
Fix: `.frame(minWidth: 44, minHeight: 44).contentShape(Rectangle())`.
Spot it: icon `Button`s with no `contentShape`.

### The silent press
A button with no touch-down feedback.
Why: the user cannot tell whether the app heard them.
Fix: `PressableButtonStyle` (0.97 scale, light haptic on touch-down).
Spot it: `Button` with `.buttonStyle(.plain)` and nothing else.

### Loading that reflows
The button label becomes a spinner and the button changes width.
Why: everything beside it jumps.
Fix: lock the width before swapping the label.
Spot it: `if isLoading { ProgressView() } else { Text(` inside a button with no fixed frame.

### Two filled buttons
Primary and secondary both filled, side by side.
Why: there is no primary any more.
Fix: one filled, one text or outlined.
Spot it: two `.borderedProminent` in one `HStack`.

### "Are you sure?" with Yes / No
Why: it names nothing; the user has to reconstruct what will happen.
Fix: "Delete project?" with "Delete project" (`role: .destructive`) and "Cancel".
Spot it: `grep -rn "Are you sure" Sources/`

### Identical stacked sheets
A sheet presents a sheet of the same height.
Why: the user sees one layer swap and loses depth.
Fix: heights differ by ≥ 25%.
Spot it: nested `.sheet` with the same `presentationDetents`.

### The wrong sheet radius
System 10pt corners on an app whose cards are 24pt.
Why: the sheet is the only surface in the app with a different language.
Fix: `.presentationCornerRadius(project.largeRadius)`.
Spot it: `.sheet` with no `presentationCornerRadius`.

## Copy

### Oops
"Oops! Something went wrong."
Why: it apologises, explains nothing, and offers nothing.
Fix: "Unable to save. Check your connection and try again."
Spot it: `grep -rni "oops\|something went wrong" Sources/`

### Emoji in chrome
Emoji in navigation titles, buttons, or error text (when the design contract does not ask for them).
Why: it reads as a template and it does not localise.
Fix: SF Symbols in chrome; emoji only where the contract allows.
Spot it: emoji ranges in string literals inside `Text(` of titles and buttons.

### The renaming action
"Publish" produces "Your post has been shared successfully!"
Why: the user pressed Publish; the outcome should say Published.
Fix: an action keeps its name through the flow.
Spot it: success strings that do not contain the verb of the button that caused them.

### Home
A tab named "Home" for a screen that is a feed of the user's progress.
Why: it names nothing; the user learns nothing from the label.
Fix: name navigation by contents: "Progress", "Library", "Inbox".
Spot it: `Label("Home"`.

### Centred body text
Paragraphs centred under a headline.
Why: the eye cannot find the start of the next line.
Fix: `.multilineTextAlignment(.leading)` for anything over one line.
Spot it: `.multilineTextAlignment(.center)` on multi-line `Text`.

## Structure

### The 8pt-only grid
Every padding is 8, 16, 24, 32.
Why: 12 and 20 are the values that make rows breathe; without them everything is either cramped or loose.
Fix: 4pt base with 8 as the rhythm.
Spot it: no 12 or 20 anywhere in `.padding(`.

### Four-bucket daypart
Morning / afternoon / evening / night colours switched at fixed hours.
Why: the wash jumps at 6pm; a continuous interpolation was the whole point.
Fix: interpolate by minutes of day, ease over ~1.6s when it changes.
Spot it: a `switch hour` returning colours.

### Launch screen with text
A logo and a tagline on the launch storyboard.
Why: it cannot localise, it flashes, and it delays the first real frame.
Fix: the launch screen matches the first screen's chrome and has no text.
Spot it: `LaunchScreen.storyboard` with a `UILabel`.

### Confetti
A particle burst, at any frequency, for anything.
Why: it is memorable twice. After that it is a thing to sit through, and it spent the budget that would have made the four hundred ordinary interactions better. A product that throws particles is telling you where its craft stopped.
Fix: no particle system at all. Mark the moment by having the interface behave well: the number lands, the symbol morphs, one `.success` haptic, and the same care goes into every checkmark and row settle in the app.
Spot it: any particle emitter, any Lottie celebration, any `CAEmitterLayer`.

### Haptic spam
`.selection` on every scroll tick; `.success` on every read receipt.
Why: haptics are punctuation; a page of full stops is noise.
Fix: one per commit, one per detent, nothing on scroll.
Spot it: `sensoryFeedback` inside `onScrollGeometryChange` or a `ForEach` body.

## Widgets and paywalls

### The shrunk screen
A widget that is a miniature of the app's home view.
Fix: one number, one label, one wash. See `widgets-and-live-activities.md`.
Spot it: a widget view that reuses the app's screen view.

### The paywall on cold launch
Why: the user has received nothing yet; the ask is pure friction.
Fix: after a value moment or at a metered limit.
Spot it: paywall presentation in `onAppear` of the root view.

### The breathing PRO badge
A badge or CTA that pulses to create pressure.
Why: calm converts and keeps; pulsing reads as manipulation.
Fix: static badge, one clear CTA.
Spot it: `repeatForever` in the paywall.

### Hidden monthly
Only the annual price shown, monthly greyed out or missing.
Why: it is a dark pattern, and App Review knows it.
Fix: both prices, annual preselected is fine, both readable.
Spot it: a product list filtered to one option.
