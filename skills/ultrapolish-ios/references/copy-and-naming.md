# Copy and naming

Use this when writing or reviewing any user-facing string: button labels, titles, navigation, errors, empty states, placeholders, permissions, notifications, settings.
Copy is the layer users read most and designers review least. One wrong verb on a button costs more than a wrong radius.

## Rules

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

## Cheat sheet

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

## Code

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

## Checks

- Read every button label out of context; each says what happens.
- Grep for "Oops", "Sorry", "Something went wrong", "trouble", "Are you sure", "OK", "Submit", "Click here".
- Grep for `" + ` near string literals; none build sentences.
- Follow one verb from button to completion; the name never changes.
- Every toggle reads correctly when ON.
- Run in German: nothing truncates, nothing wraps badly.
- Grep for the em-dash character and for emoji; matches are allowed only where the design contract says so.
- Count uses of the user's name per session: one.

## Do not

- Apologise in an error. State the fact and the fix.
- Use exclamation marks in errors or destructive flows.
- Write "Allow" on a permission primer.
- Put the app name in a notification title.
- Write "No items", "Nothing here", "No data".
- Use three different words for the same action across screens.
- Manufacture warmth from randomness. The words stay steady; the data varies.
- Truncate a label with an ellipsis when `ViewThatFits` and a shorter variant would do.
