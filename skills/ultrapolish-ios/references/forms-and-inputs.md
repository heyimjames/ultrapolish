# Forms and text input

Use this when a screen asks anyone to type: sign-in, search, a compose field, a settings value, an address, a card, a one-time code. The web counterpart is a separate skill; this is the SwiftUI and UIKit half.

Most of what makes an iOS form feel careless is invisible in a screenshot. It is the keyboard that comes up wrong, the autofill that never offers, the field that hides under the keyboard, and the return key that says "return" when it should say "Send".

## Rules

1. **Every field declares what it holds.** `.textContentType()` is what turns on autofill, the QuickType strip, and the strong-password and one-time-code flows, and none of them work without it. `.username`, `.password`, `.newPassword`, `.oneTimeCode`, `.emailAddress`, `.telephoneNumber`, `.name` and the address types cover almost everything. Never disable autofill on identity or payment fields; a person retyping a password from memory makes more mistakes than the keychain does. Check: on a device with saved credentials, the field offers them above the keyboard.
2. **The keyboard matches the content.** `.keyboardType(.emailAddress)` removes the space bar's shift and adds the `@`; `.numberPad` for digits with no separators; `.decimalPad` for money; `.URL` for links. Pair with `.textInputAutocapitalization(.never)` and `.autocorrectionDisabled()` on emails, usernames, codes and anything case-sensitive, or the system will helpfully capitalise a login and reject it. Check: open every field and read the keyboard's bottom row.
3. **The return key says what it does.** `.submitLabel(.next)` between fields, `.send`, `.search`, `.done`, `.join` or `.go` on the last one. A keyboard that says "return" in a two-field form is a keyboard that has not been thought about. Check: every field's return key names its action.
4. **`@FocusState` moves the cursor, and something has to.** The return key advances to the next field, the screen opens with the first empty field focused when there is exactly one obvious starting point, and a validation failure moves focus to the field that failed. Focus after a sheet has finished presenting, roughly 350ms, or the keyboard fights the sheet animation. Check: fill a form using only the keyboard; you never reach for the screen to move between fields.
5. **Never disable the submit button until the form is valid.** A dead button gives no reason and no route out. Leave it enabled, validate on submit, move focus to the first failure, and put the message under that field. The exception is a submit already in flight, which is disabled because it is busy and says so. Check: tap submit on an empty form; you learn what is wrong.
6. **Validate on submit, then on change for the field already corrected.** Validating while someone is still typing their email tells them it is wrong before they have finished writing it. Once a field has failed, it may re-validate on each keystroke so the error clears the moment it is fixed. Check: type one character into an empty email field; nothing turns red.
7. **The error sits under its field, in words, and keeps the value.** Never a toast, never an alert, never a red border with no text. Say what to do rather than what happened: "Add a domain ending, like .com" beats "Invalid email". Never clear what someone typed because it failed. Check: submit an invalid form; every value is still there and every message is next to its cause.
8. **Nothing important hides under the keyboard.** SwiftUI moves focused fields above it, but not the button below them and not the error message. Put the form in a `ScrollView`, keep the primary action in a `.safeAreaInset(edge: .bottom)` so it rides above the keyboard, and test on the smallest device with the largest Dynamic Type. Check: focus the last field on a 4.7-inch screen at AX3 and confirm the submit button is reachable.
9. **A keyboard needs a way down.** A `.numberPad` and `.decimalPad` have no return key at all, so they need a Done button in `.toolbar { ToolbarItemGroup(placement: .keyboard) }` or a scroll-to-dismiss. `.scrollDismissesKeyboard(.interactively)` is the right default in a long form. Check: open a number pad and dismiss it without leaving the screen.
10. **Money, dates and codes are formatted as they are typed, not after.** `TextField(value:format:)` with a currency or number format applies grouping live. A one-time code field is a single `TextField` with `.oneTimeCode`, not six boxes; the six-box pattern breaks paste, breaks autofill, and breaks VoiceOver. Check: paste a six-digit code; it lands.
11. **A field's label survives the typing.** A placeholder that vanishes when someone starts typing takes the question with it, which is a problem the moment they are interrupted. Use a persistent label above the field. Placeholders are for an example of the format, not for the name of the field. Check: type into every field and confirm you can still tell what each one is asking.
12. **A destructive or irreversible form confirms with its noun and its consequence.** "Delete account" and a sentence about what goes with it, not "Are you sure?". Anything requiring the person to type a word to confirm should only be used where the consequence is genuinely unrecoverable. Check: read the confirmation aloud; it names the thing and the outcome.
13. **Long forms are steps, not scrolls.** Four fields per screen with a pinned primary action beats twelve in one column. Group by what a person can answer without stopping to look something up, and never mix a field they know by heart with one they have to go and find. Check: count the fields on screen at once; more than about six wants splitting.
14. **Secure fields are still fields.** `SecureField` with `.newPassword` gets the strong-password offer; a reveal toggle is expected and should be a real button with a label, not a bare eye glyph. Never impose a maximum length or a character set that the keychain cannot generate against. Check: tap New Password; the system offers to generate one.

## Cheat sheet

| Thing | Value |
|---|---|
| Autofill | `.textContentType(...)` on every identity, address, payment and code field |
| Email field | `.keyboardType(.emailAddress)` + `.textInputAutocapitalization(.never)` + `.autocorrectionDisabled()` |
| Return key | `.submitLabel(.next)` between, `.done` / `.send` / `.search` / `.go` at the end |
| Focus after a sheet | ~350ms, after the presentation animation settles |
| Submit button | Never disabled for invalid input; only while a submit is in flight |
| First validation | On submit. Then per keystroke for a field that has already failed |
| Error placement | Under the field, in words, value preserved |
| Number pad dismissal | Keyboard toolbar Done, plus `.scrollDismissesKeyboard(.interactively)` |
| One-time code | One `TextField` with `.oneTimeCode`, never six boxes |
| Fields per screen | About six before it wants splitting into steps |

## Code

```swift
enum Field: Hashable { case email, password }

struct SignIn: View {
    @State private var email = ""
    @State private var password = ""
    @State private var emailError: String?
    @FocusState private var focus: Field?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LabeledField("Work email", error: emailError) {
                    TextField("you@company.com", text: $email)
                        .textContentType(.username)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .focused($focus, equals: .email)
                        // Only re-validates once it has already failed, so nobody
                        // is told their address is wrong while they are writing it.
                        .onChange(of: email) { if emailError != nil { validate() } }
                }

                LabeledField("Password", error: nil) {
                    SecureField("", text: $password)
                        .textContentType(.password)
                        .submitLabel(.go)
                        .focused($focus, equals: .password)
                }
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .onSubmit {
            switch focus {
            case .email: focus = .password
            default: submit()
            }
        }
        // Rides above the keyboard instead of hiding behind it.
        .safeAreaInset(edge: .bottom) {
            Button("Sign in", action: submit)
                .buttonStyle(.borderedProminent)
                .padding(20)
        }
    }

    private func validate() {
        emailError = email.contains("@") && email.contains(".")
            ? nil : "Add a domain ending, like .com"
    }

    private func submit() {
        validate()
        // Focus goes to what failed, so the fix is one tap away.
        if emailError != nil { focus = .email; return }
        // ...
    }
}
```

## Checks

- On a device with saved credentials, every identity field offers autofill above the keyboard.
- Every keyboard's bottom row and return key match the field they belong to.
- The whole form can be completed without touching the screen between fields.
- Submit on an empty form explains what is missing; nothing typed is lost.
- On the smallest device at AX3, with the last field focused, the submit button is still reachable.
- A pasted one-time code lands in the field.
- Every placeholder is an example of a format, and every field still names itself while being typed into.

## Do not

- Ship a field without `.textContentType`, then wonder why autofill never appears.
- Disable submit until valid.
- Turn a validation failure into a toast, an alert, or a bare red border.
- Build a six-box one-time-code input.
- Use the placeholder as the label.
- Clear a field because its value failed validation.
- Put the primary action below the fold of a scrolling form with no safe-area inset.
