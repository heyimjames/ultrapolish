# Onboarding

Use this when designing or reviewing the first run: launch, the first screens, permissions, account, the first payoff.
The first thirty seconds decide whether someone stays. Every screen either builds toward a payoff or costs you the user.

## Rules

1. **Value in three seconds.** The first real screen shows what the app does with something the user can see, not a paragraph about it. Why: people decide before they read. Check: cover the text; the screen still communicates.
2. **Four or five rooms, one purpose each.** Value moment → the one input → the payoff → a permission primer only if the very next step needs it → handoff. Why: each extra screen loses a share of users. Check: name each screen's single job; if a screen has two, split it or cut it.
3. **Sign-in and the paywall are not rooms.** Guest-first; ask for an account when there is something to save, sync, or unlock. Show the paywall only after a value preview, and skippable. Why: forced sign-in is the top abandonment point. Check: the user reaches the payoff without an account.
4. **The launch screen is not a design canvas.** It matches the first real screen, contains no text (it cannot be localised), and no logo unless the logo is part of the first screen. Why: it is a placeholder for a fraction of a second; a splash reads as a delay. Check: the launch storyboard has no `UILabel`.
5. **Progress is dots, never a bar.** A bar reads as loading; dots read as position in a short journey. Every dot is the same size and stays where it is; only the fill changes, over about 180ms. Inactive dots at about 0.25 opacity of the ink, the active one at full. Nothing stretches, nothing travels, nothing changes width, so the only thing moving on the screen is the content. Check: screenshot two consecutive steps and diff them; the dots differ in colour and in nothing else.
6. **Do not count the primer or the celebration as steps.** Five dots that only reach three is a broken promise. Check: dot count equals the number of screens the user actually pages through.
7. **The CTA is pinned.** A fixed distance from the bottom safe area, same on every screen; body copy grows upward. Why: a button that moves between screens reads as "made by nobody in particular". Check: page through; the button's Y never changes.
8. **Forward enters from the trailing edge; back returns to it.** `.spring(duration: 0.45, bounce: 0.15)`. Background art travels at 30–40% of the foreground. Why: direction encodes progress. Check: a cross-fade in place is a finding.
9. **The value preview is built from real components.** The one input produces an immediate reflection using the app's actual views, and the payoff is prefetched the moment the input exists. Why: a mock-up promises; the real thing proves. Check: the preview screen imports the same view as the main app.
10. **Permission primers have exactly one button titled "Continue" or "Next".** No Cancel, no "Allow", no incentives, no screenshot of the alert. Why: App Review 5.1.1(iv). Check: the primer view has one `Button`.
11. **Ask at the point of value, never at launch.** Camera when the user taps scan; notifications after the first thing worth being told about. Check: no permission alert fires before the user has done anything.
12. **Sign in with Apple, when offered, uses the system button and is no smaller than any other sign-in option.** Do not ask for a password afterwards, and do not ask for a real email when a private relay address arrives. Check: `ASAuthorizationAppleIDButton` or `SignInWithAppleButton`, full width if others are full width.
13. **Request a review only after a completed value sequence, weeks in.** Never at first-run completion, never as a direct result of a tap. The system allows three prompts per year. Check: `requestReview` is not called from onboarding.
14. **The celebration is a quiet landing beat.** The number lands, the symbol morphs, one `.success` haptic. There are no particles to save for later; see `references/states.md` rule 10. Check: no confetti on "You're all set", and none anywhere else either.
15. **Dots are hidden from VoiceOver; the flow announces "Step n of m".** Check: `.accessibilityHidden(true)` on the dots; `.accessibilityValue` on the container.

## Cheat sheet

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
| Dot size | 7pt, identical on every dot, active and inactive |
| Dot fill | `.easeInOut(duration: 0.18)` on opacity only; no size, position, or width animation to reduce |
| Inactive dot opacity | ~0.25 of the ink |
| CTA position | Fixed inset from bottom safe area, identical on every room |
| Stagger within a room | 30–80ms, first appearance only |
| Reduce Motion | Crossfade 180ms, no travel, no parallax |

## Code

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

Dots that change fill and nothing else.

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

## Checks

- Time from launch to the first screen that shows the product: under three seconds on a cold start.
- Name each room's single job aloud.
- Page through with the CTA visible: its Y position never changes.
- Turn on Reduce Motion: pages crossfade, dots still update.
- Deny every permission: the flow completes and the app is usable.
- Skip the account: the payoff still appears.
- VoiceOver: dots are silent; "Step 2 of 4" is announced.
- Launch storyboard contains no text.

## Do not

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
