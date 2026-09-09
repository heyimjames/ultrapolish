# States

Use this when a screen fetches, saves, waits, fails, or is empty. That is every screen.
The empty state is the first impression for every new user, and the error state is the moment trust is won or lost.

## Rules

1. **Every list, fetch, and form has empty, loading, error, and success.** Why: a screen that only works when data is present only works in the demo. Check: force each state with a debug flag or a fake store; none is a blank white view.
2. **Follow the loading ladder.** 0–500ms silent; 500ms–2s subtle inline; 2s+ explicit progress with a label; 10s+ a Live Activity or notification. Why: a spinner for 300ms reads as a flicker, and a silent 5s reads as broken. Check: time the network call on a slow simulator profile and see the right rung.
3. **The spinner travels.** Progress appears where the result will land, not only on the control that was tapped. Why: the eye follows one location, so anchor it to the destination. The control may carry progress as well once the result has a home of its own; it may never be the only place it appears. Check: after tapping Send, the bubble shows the progress, whether or not the button does too.
4. **Skeletons structurally match.** Same bar count, widths, and positions as the real content. Why: three bars for five-line content breaks the illusion the moment it resolves. Check: overlay the skeleton on a loaded cell; the boxes line up.
5. **Optimistic first.** Apply the change immediately; a pending item is a ghost at opacity 0.6; revert with an inline reason on failure. Why: the user's action causes the visible effect; the network is an implementation detail. Check: airplane mode, tap Like; the heart fills, then reverts with a line under it.
6. **The empty state shows the destination, not just the door.** Name what is missing, one line of what goes here, a ghosted non-interactive preview of what the filled state looks like, and the one action that gets there. Never "No items". Why: this is the most-seen screen for a new user and the last place to be terse; a person who cannot picture the filled state cannot want it. Check: cover the button; can someone still tell what this screen becomes?
7. **First-run and empty are different states.** First-run introduces; empty after use reflects ("You cleared everything. Nice."). Check: both exist when the difference matters.
8. **Errors rise in context and keep the last good value visible.** A strip or line at the thing that failed, not a toast in the sky. Why: the user is looking at the thing; the fix belongs there. Check: the failed row still shows its previous content, dimmed, with the reason underneath.
9. **Undo must actually undo.** Reverse the effect, not just hide the toast. Check: Undo restores the row, the memory, the setting; the model state matches.
10. **No set pieces. Spend the budget on every interaction instead.** No confetti, no particles, no full-screen moment, at any frequency. The craft goes into the ordinary: a checkmark that lands rather than appears, a row that settles rather than pops, a number that rolls rather than swaps, an icon that morphs rather than cuts. Why: a set piece is memorable twice and tiresome after, and it costs the budget that would have made the other four hundred interactions better. This is a tool, not a toy. Check: grep for a particle system; there is none. Then list the five most frequent interactions; each has a considered settle.
11. **Offline is a state, not an error.** Cached content stays usable; a quiet banner says what is stale. Check: airplane mode; the app is still useful.
12. **Overflow is a state.** 200 items, a 60-character title, a 4-line description. Check: run with a fake store of 5000 rows and a long-string locale.
13. **Permission denied has its own screen with a Settings path.** Why: the system alert only appears once; after that the app must explain and offer `UIApplication.openSettingsURLString`. Check: deny in Settings, relaunch, see the screen.
14. **A long local job is a different shape from a network wait.** A video export, a batch of photos, or an on-device model run takes tens of seconds on the user's own hardware, reports real per-unit progress, and can be cancelled. Give it determinate progress with a count ("14 of 60"), a Cancel that actually stops the work rather than hiding the sheet, and a surface that survives the job. Why: the loading ladder above is written for a request you are waiting on, not for work you are doing. Check: start the longest job in the app, press Cancel, and confirm the CPU drops and no file is written.
15. **The progress surface must not disappear in the same frame as the failure.** If the job's sheet unmounts the moment it throws, the message lands somewhere the user is not looking and the thing they were watching vanishes at the same time. Keep the surface, swap its contents to the error, and let the user dismiss it. Why: this is the most common way a real failure becomes invisible. Check: force the job to fail; the message appears where the progress was.
16. **A job that outlives the foreground ends in a system surface.** If the app can be backgrounded mid-job, completion is a Live Activity or a local notification, not a toast nobody sees. Register a background task so the work is not suspended halfway. Why: a 40 second export is exactly long enough for someone to switch apps. Check: start the job, background the app, and confirm you are told when it finishes.
17. **One channel per severity, and only one.** Two implementations of "tell the user something went wrong", with the important path wired to the older one, is a common and invisible bug: the newer channel wraps, persists, and is reachable, and the path that matters still uses the string that predates it. Why: nobody notices the second channel because each one works in isolation. Check: grep for every way the app can surface an error (`Toast`, `banner`, `alert`, a status `String` on a view model) and confirm there is exactly one per severity; if there are two, list every call site of the older one and move them.

## Cheat sheet

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

## Code

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

## Checks

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

## Do not

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
