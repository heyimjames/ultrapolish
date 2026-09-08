# Copy and naming

Use this when you write or review any text a person reads in the interface: button labels, links, errors, empty states, settings, navigation, placeholders, toasts, pricing.
Preserve the project's voice. Flag a difference from plain language only when it creates inconsistency, ambiguity, translation risk, or the wrong tone for the stakes.

## Rules

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

## Cheat sheet

### Error rewrites

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

### Tone by stakes

| Moment | Tone |
|---|---|
| Success, onboarding, empty | warm; may be light |
| Routine, settings, navigation | neutral, minimal |
| Errors, destructive actions | calm, plain, zero playfulness |
| Data loss, security, billing | serious, explicit, complete |

### Vocabulary

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

## Code

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

## Checks

- Read only the buttons on each screen; the flow is clear.
- Follow one action from button to confirmation; the verb is stable.
- Read every link out of context; each names a destination.
- Append "on" to every toggle label; each still makes sense.
- Every error has a next step and no apology.
- Grep UI strings for `+ "`, em-dashes, emoji, "Click here", "Oops".
- Run the page through machine translation; brand names and codes survive.
- Ask what the house voice is doing before changing it.

## Do not

- Write "OK", "Yes", "Submit" on a consequential button.
- Mix Title Case and sentence case within one element type.
- Apologise in an error, or make one playful.
- Concatenate around a variable.
- Use a placeholder as a label.
- Add eyebrow labels, middle dots, arrows, or emoji the project did not already have.
- Rename a house voice into generic plain language without a stated reason.
- Hide a price.

See `references/states.md` for empty and error placement, `references/onboarding-and-pricing.md` for pricing pages, `references/accessibility.md` for accessible names.
