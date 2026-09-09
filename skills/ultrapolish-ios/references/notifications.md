# Notifications

Use this when the app sends anything to the Lock Screen or Notification Centre: a push, a local reminder, a scheduled nudge, a badge. Live Activities and the Dynamic Island are in `references/widgets-and-live-activities.md`; the permission primer pattern is in `references/onboarding.md`.

A notification is the only part of a product that appears on someone's screen without being asked for. Every rule here follows from that.

## Rules

1. **Ask at the moment the person wants the thing, never at launch.** The system prompt can be shown once, ever, and a decline is close to permanent. Prime it with a screen of your own that says exactly what will be sent and how often, and only after they have done something that implies wanting it. If they decline your primer, do not show the system one; ask again later when the context is stronger. Check: the system alert only ever appears after a screen you designed.
2. **Provisional authorisation is the right default for anything non-urgent.** `.provisional` delivers quietly to Notification Centre with no prompt at all, and the person promotes or turns it off from the notification itself. It costs nothing and it does not spend your one alert. Check: a fresh install receives quiet notifications without ever being asked.
3. **The first line is the whole notification.** People read the Lock Screen at arm's length. Front-load the noun and the change: "Anna replied to Q3 report", not "You have a new message". Never lead with the app's own name; iOS already prints it above. Check: read only the first forty characters and say whether you would open it.
4. **Interruption levels are the honest signal, and almost nothing is `.timeSensitive`.** `.passive` for things that can wait until they next look, `.active` as the normal case, `.timeSensitive` only for something with a real deadline the person has agreed to, and `.critical` essentially never without an entitlement and a life-safety reason. Marketing dressed as time-sensitive is the fastest way to be turned off entirely. Check: list every notification type with its level and justify each one above `.active`.
5. **Group with a `threadIdentifier` or the app becomes a wall.** One thread per conversation, per document, per subject. Set `summaryArgument` so the collapsed stack reads "3 more messages from Anna" rather than a count of nothing. Check: send five related notifications; they collapse into one legible stack.
6. **Actions belong on the notification, so the app does not have to open.** Reply, complete, snooze, archive, whatever the two most likely responses are. A destructive action is marked `.destructive` and any action carrying real consequence sets `.authenticationRequired`. Check: handle the most common response entirely from the Lock Screen.
7. **The badge is a count of things the person must act on, or there is no badge at all.** Unread messages addressed to them, tasks due today, items awaiting their approval: those are countable and clearable. Unread announcements, new features, a nudge to come back, and any number that only clears by finding one specific screen are not, and an app with nothing in the first list ships without a badge rather than inventing something for it. If you cannot name what decrements it, remove it. It clears when the thing is actually dealt with, including from a notification action and from another device, not only by opening the app. Check: act on everything and confirm the badge reaches zero without hunting for a screen.
8. **Rich content earns its place or is left off.** A `UNNotificationContentExtension` or an attached image is right when the image is the content, such as a photo someone was sent. It is wrong as decoration, because it delays delivery and consumes memory. Check: every attachment is information rather than branding.
9. **Deep link to the exact thing, and preserve where they were.** Tapping a notification lands on the specific message or item, not the app's home screen, and going back returns somewhere coherent rather than into an empty stack. Check: tap a notification from cold launch and press back.
10. **Never send what the person can already see.** Suppress delivery for the conversation currently open, and use `willPresent` to decide, rather than banner-ing something two inches above where it already appeared. Check: keep a thread open and receive a message in it.
11. **Update rather than stack for the same fact.** Reuse the identifier so "Order out for delivery" becomes "Order arriving" in place. Five notifications about one order is four too many. Check: run a multi-step process and count the notifications.
12. **Local notifications are cancelled when the reason goes away.** Complete a task and its reminder is removed; delete an event and its alerts go with it. A notification about something that no longer exists is the clearest possible signal that nobody is maintaining the app. Check: schedule, complete, and wait; nothing arrives.
13. **Quiet hours are respected without being asked.** Anything scheduled by the app rather than by the person avoids the middle of the night in the device's own timezone, not the server's. Check: change the device timezone and see when things fire.
14. **The settings screen mirrors what you actually send.** A per-category toggle for each kind of notification, matching the categories in the copy of the primer, plus a route to the system settings. An all-or-nothing switch means the only way to stop the one annoying kind is to stop all of them. Check: turn off exactly one kind and confirm the others still arrive.

## Cheat sheet

| Thing | Value |
|---|---|
| Permission | Your primer first, system alert only after; never at launch |
| Non-urgent default | `.provisional`, no prompt at all |
| First line | Noun and change, front-loaded, no app name |
| Level | `.passive` / `.active` default; `.timeSensitive` needs a real deadline |
| Grouping | `threadIdentifier` per subject, plus `summaryArgument` |
| Actions | The two most likely responses; destructive marked, sensitive authenticated |
| Badge | Count of things needing action, or absent |
| Same fact | Reuse the identifier and update in place |
| Foreground | Suppress what is already on screen, via `willPresent` |
| Settings | Per category, matching the primer's promises |

## Code

```swift
let content = UNMutableNotificationContent()
// The noun and the change, in the first forty characters.
content.title = "Anna replied to Q3 report"
content.body = "\"Numbers look right to me, shipping it.\""
// One thread per conversation, so five of these collapse instead of stacking.
content.threadIdentifier = "thread-\(conversation.id)"
content.summaryArgument = "Anna"
content.interruptionLevel = .active   // .timeSensitive needs a real deadline
content.categoryIdentifier = "reply"

// Reusing the identifier updates in place rather than adding another row.
let request = UNNotificationRequest(
    identifier: "conversation-\(conversation.id)",
    content: content,
    trigger: nil
)

// Two likely responses, handled without opening the app.
let category = UNNotificationCategory(
    identifier: "reply",
    actions: [
        UNTextInputNotificationAction(identifier: "reply", title: "Reply",
                                      options: [], textInputButtonTitle: "Send",
                                      textInputPlaceholder: "Message"),
        UNNotificationAction(identifier: "mute", title: "Mute", options: []),
    ],
    intentIdentifiers: []
)
```

```swift
// Do not banner something the person is already looking at.
func userNotificationCenter(_ c: UNUserNotificationCenter,
                            willPresent n: UNNotification) async
    -> UNNotificationPresentationOptions {
    let id = n.request.content.threadIdentifier
    return openConversationID == id ? [] : [.banner, .sound, .list]
}
```

## Checks

- The system permission alert only ever appears after a screen you designed.
- A fresh install receives provisional notifications with no prompt.
- Read only the first forty characters of each notification type and decide whether you would open it.
- List every type with its interruption level; justify anything above `.active`.
- Send five related notifications; they collapse into one legible stack.
- Handle the most common response entirely from the Lock Screen.
- Act on everything; the badge reaches zero without hunting for a screen.
- Tap a notification from a cold launch, then press back.
- Keep a thread open and receive a message in it; nothing banners.
- Complete a task with a scheduled reminder; the reminder does not arrive.
- Turn off one category in settings; the others still arrive.

## Do not

- Request permission on first launch.
- Lead with the app's name.
- Mark marketing as `.timeSensitive`.
- Ship without a `threadIdentifier`.
- Badge something the person cannot act on.
- Send five notifications about one order.
- Banner a message in the conversation already on screen.
- Leave a reminder scheduled for something already done.
- Offer a single on/off switch for every kind of notification you send.
