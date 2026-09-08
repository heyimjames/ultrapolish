# Forms and inputs

Use this when you are building or reviewing anything a person types into: sign-up, checkout, settings, search, a single text field in a sheet.
The project's own input tokens win; these are the defaults and the checks.

## Rules

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

## Cheat sheet

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

## Code

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

## Checks

- On a phone, focus every field: no zoom, correct keyboard, correct blue key label.
- Submit empty: focus lands on the first invalid field and its error is read aloud.
- Autofill the whole form from the browser; every field is offered.
- Paste into every field; nothing is blocked.
- Kill the network, submit: values remain, error appears, submit re-enables.
- Type past a limit: only the counter changes.
- Tab through a select with the keyboard and complete it.
- Open a sheet with a field: keyboard appears after the sheet settles.

## Do not

- Disable submit until the form is valid.
- Put the error below the field where it pushes everything down.
- Use placeholders as labels.
- Set `autocomplete="off"` on anything a password manager should fill.
- Use `type="number"` for codes, cards, or phone numbers.
- Block paste, ever.
- Autofocus on touch.
- Apply keyboard offsets with `bottom`; use `transform`.

See `references/buttons-and-controls.md` for the submit button, `references/states.md` for error placement, `references/accessibility.md` for the announcement ladder.
