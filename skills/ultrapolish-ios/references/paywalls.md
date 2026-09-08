# Paywalls and pricing

Use this when building or reviewing a paywall, a pricing screen, a trial flow, or any StoreKit code.
A calm, honest paywall converts better and keeps subscribers longer than a pressured one. The engineering underneath it is where trust is silently lost.

## Rules

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

## Cheat sheet

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

## Code

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

## Checks

- First frame of the paywall: Close is present and hits at 44pt.
- Every price on screen comes from `displayPrice`.
- Tap Subscribe, cancel the sheet: no layout change, no message.
- Sandbox refund: access revoked on next launch.
- Reinstall: access returns without tapping Restore.
- Sandbox account without trial eligibility: no trial copy.
- Nothing on the paywall animates after it settles.
- Read the fine print aloud; it states amount, period, renewal, and how to cancel.

## Do not

- Show the paywall on cold launch or to a current subscriber.
- Type a price into a `Text`.
- Grey or hide the monthly option.
- Pulse, glow, or throb any element to create pressure.
- Use an alert for a purchase failure.
- Unlock on `.pending` or on `.unverified`.
- Call `AppStore.sync()` anywhere except the Restore button.
- Stack a second CTA under the first.
- Fire confetti on subscribe; one `.success` haptic and a quiet confirmation is the beat.
