# Onboarding and pricing

Use this when you are building or reviewing a first-run flow, a sign-up, a trial, a pricing page, or an in-app upgrade wall. The first thirty seconds decide whether someone stays; the pricing page decides whether they pay without feeling tricked.

## Rules: onboarding

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

## Rules: pricing and paywalls

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

## Cheat sheet

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

## Code

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


## Copy that holds up

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

## Checks

- Walk the flow with the network throttled to 3G; every step still has something to look at within 300ms.
- Overlay screenshots of consecutive steps; the CTA does not move by a pixel.
- Count dots; count screens a user can stand on; they match.
- On the paywall, take a screenshot at t=0; Close is there.
- Tab through the paywall; the order is headline, options, CTA, quiet row.
- Grep the paywall for `setInterval`, `countdown`, `animation:`; justify each hit in writing.
- Read the trial copy; it names a date and the live price.

## Do not

- Put a form on the first screen.
- Use a progress bar for a finite flow.
- Count the celebration as a step.
- Show the paywall on landing, on launch, or to someone who already pays.
- Hide monthly, grey monthly, or make monthly a smaller hit target.
- Add a countdown that the server does not enforce.
- Animate anything on a paywall except its entrance and exit.
