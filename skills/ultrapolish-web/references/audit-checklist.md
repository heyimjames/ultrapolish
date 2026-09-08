# Audit checklist (printable)

The full checklist from SKILL.md §6 with a "how to verify" column. ★ items are the quick-mode set. Severity is what to file if the check fails; downgrade only with a written reason.

## The one-hour audit

1. Intake table (10 min): tokens, radii, spacing, motion, overlays, states. See SKILL.md §1.1.
2. Keyboard-only pass of the primary path (10 min).
3. DevTools: 320px, then 200% zoom at 1280 (5 min).
4. Emulate `prefers-reduced-motion` and dark mode; repeat the primary path (5 min).
5. Throttle to fast 3G; watch every loading state (5 min).
6. Animations panel at 10% speed for one overlay pair and one list entrance (5 min).
7. The greps at the bottom of this file (5 min).
8. Copy pass: every button, every error, every empty state (5 min).
9. Group findings by root cause; write the "what this changes" column (5 min).
10. Verdict.

## Accessibility and states

| Check | How to verify | Severity |
|---|---|---|
| ★ Keyboard-only pass: every control reachable, focus visible, Escape closes what opened last | Unplug the mouse; Tab through the path; open a menu inside a dialog and press Escape | HIGH |
| ★ Every interactive element is a `<button>` or `<a>` with a name | Accessibility tree in DevTools; `grep -rn "onClick" \| grep -v "<button\|<a "` | HIGH |
| ★ Empty, loading, error, success exist for every list, form, fetch | Mock each response; screenshot each | HIGH |
| Offline state exists; cached content stays usable | DevTools Network: Offline | MEDIUM |
| 320px reflows with vertical scroll only; 200% zoom holds | Responsive mode at 320; browser zoom 200% at 1280 | HIGH |
| Reduced motion swaps vestibular motion for crossfades | Rendering panel: emulate `prefers-reduced-motion`; every action still responds | MEDIUM |
| Screen reader announces route changes, live updates, errors | VoiceOver (Cmd+F5) on Safari; navigate; submit an invalid form | HIGH |
| Overflow: 200 rows, 60-char title, German labels hold | Seed data; switch locale | MEDIUM |

## Layout and hierarchy

| Check | How to verify | Severity |
|---|---|---|
| ★ Eye lands on headline then primary action within a second | Squint test on a screenshot; ask a colleague what to click | MEDIUM |
| ★ One primary action per view | Count filled buttons per screen | MEDIUM |
| ★ Same container padding on every page | `grep -rn "max-w-\|container"`; compare computed padding on three pages | MEDIUM |
| Spacing from the grid; group gaps ≥ 2× inner gaps | Inspect gaps; values ∈ {4, 8, 12, 16, 20, 24, 32, 40, 48, 64} | LOW |
| Controls 12px apart; borderless controls with 24px clearance | Measure in DevTools | LOW |
| At most three radii; nested = outer − padding | `grep -rno "rounded-[a-z0-9]*\|border-radius:[^;]*" \| sort \| uniq -c` | MEDIUM |
| Horizontal scrollers peek 16–32px | Resize; the next card is partly visible | LOW |
| Nothing critical under the keyboard or below a fixed pane's fold | Open each modal at 375×667 with the keyboard up | HIGH |
| Safe areas added to padding; `viewport-fit=cover` set | View source; test on a phone with a home indicator | MEDIUM |

## Copy and naming

| Check | How to verify | Severity |
|---|---|---|
| ★ Buttons verb-first, naming the noun | List every button label | MEDIUM |
| ★ Errors say what happened and what to do; no "Oops" | `grep -rni "oops\|something went wrong\|having trouble"` | MEDIUM |
| One capitalisation policy per element type | Sample ten labels | LOW |
| An action keeps its name across the flow | Trace "Publish" to "Published" | LOW |
| Links describe their destination | `grep -rni ">click here<\|>learn more<"` | MEDIUM |
| Toggles label the ON state | Read every switch label | LOW |
| Empty states name the thing and offer one action | Screenshot each | MEDIUM |
| Emoji and dash policy matches the design contract | Grep for emoji ranges and the em dash character | LOW |

## Typography

| Check | How to verify | Severity |
|---|---|---|
| ★ Roles carry hierarchy; emphasis is one weight step | Inspect computed sizes on a busy screen; count distinct sizes | MEDIUM |
| ★ Inputs ≥ 16px on mobile; no `maximum-scale` | Focus an input on an iPhone; read the viewport meta | HIGH |
| Measure ≤ 75ch; 3+ line text has line-height ≥ 1.4 | Measure the widest paragraph; inspect `line-height` on wrapped rows | MEDIUM |
| `text-wrap: balance` on headings, `pretty` on cards | `grep -rn "text-wrap\|text-balance\|text-pretty"` | LOW |
| Changing numbers are tabular | Watch a counter tick; `grep -rn "tabular-nums"` | MEDIUM |
| No weight under 400 below 28px | `grep -rn "font-light\|font-thin\|font-weight: [123]00"` | LOW |
| Font smoothing set once; `.woff2` only | `grep -rn "font-smoothing"`; list font files | LOW |
| Underlines from the font; only colour animates | Inspect link `text-decoration` | LOW |

## Colour and surfaces

| Check | How to verify | Severity |
|---|---|---|
| ★ APCA ≥ 75 body, ≥ 60 secondary, ≥ 30 UI (or WCAG 4.5 / 3) | Contrast checker on ink, muted, and disabled tokens, both modes | HIGH |
| ★ Every colour pair re-checked in dark mode | Toggle `data-theme`; screenshot the same screen twice | MEDIUM |
| One accent per view; colour on the primary's background | Count accent uses per screen | MEDIUM |
| Muted text is one ink stepped in alpha | Inspect the token file | LOW |
| Shadow-as-border in light; single ring in dark | Inspect a card's `box-shadow` in both modes | LOW |
| Images outlined at 10% black/white inset | Inspect an avatar over a white card | LOW |
| Backdrop blur has `saturate`, ≤ 3 per screen, static | `grep -rn "backdrop-filter" \| grep -v saturate`; count per screen | MEDIUM |
| Theme switch suppresses transitions for one frame with a backstop | Toggle theme; watch for a ripple of mismatched fades | LOW |
| Meaning never carried by colour alone | Greyscale screenshot | HIGH |

## Motion

| Check | How to verify | Severity |
|---|---|---|
| ★ No `transition: all`; every transition names its property | `grep -rn "transition: all\|transition-all"` | MEDIUM |
| ★ Exits shorter than entrances, accelerating, no bounce | Compare `exit` and `animate` in each component; Animations panel | MEDIUM |
| ★ Paired elements share easing and duration | Animations panel at 10%: modal and backdrop start and end together | MEDIUM |
| Opacity and colour never spring | Search spring configs for `opacity` | LOW |
| Stagger 30–40ms, first appearance only, ≤ 8 items | Inspect `staggerChildren`; scroll a list twice | LOW |
| Press scale within the ladder; nothing below 0.9 | `grep -rn "scale(0\.[0-8]\|scale-9[0-4]"` | LOW |
| No entrance animation on above-the-fold chrome at load | Reload; nav and header do not animate | LOW |
| Animations replayed at 10% speed look right | Animations panel, 10% | LOW |
| Gesture-driven motion starts from the current value with velocity | Interrupt a sheet mid-open; no jump | MEDIUM |

## Controls, forms, overlays

| Check | How to verify | Severity |
|---|---|---|
| ★ Targets ≥ 44px touch / 40 pointer / 24 floor, expanded on the button | DevTools box on each small control | HIGH |
| ★ Submit never disabled until valid; first invalid field focused | Submit empty; watch focus | HIGH |
| ★ Loading buttons lock width; disabled has a reason | Click; measure width before and during; hover a disabled control | MEDIUM |
| `autocomplete` and `inputmode` on identity, payment, OTP fields | `grep -rn 'autocomplete="off"'`; inspect each field | HIGH |
| Modals use `<dialog>` or `inert`; focus returns to trigger | Open, Tab past the end, close | HIGH |
| Sheets dismiss on velocity; contents arrive 80ms after the container | Flick from 10%; Animations panel | MEDIUM |
| Tooltips delay 200ms and warm; toasts persist with actions | Hover two tooltips in a row; trigger a toast with Undo and wait | MEDIUM |
| Copy holds a check 1.5s; search debounces 300ms | Click copy; type in search with Network open | LOW |
| Hover changes only colour unless the element navigates | Hover every card and row | LOW |

## Performance as felt

| Check | How to verify | Severity |
|---|---|---|
| ★ No layout shift on load, font swap, data arrival, button loading | Lighthouse CLS = 0; Performance panel Layout Shift track | HIGH |
| ★ INP < 200ms on the primary path | Web Vitals extension or Performance panel Interactions | HIGH |
| No `backdrop-filter` or big blurred shadow on anything that moves | Performance panel while scrolling | MEDIUM |
| Lists past ~100 rows virtualised or `content-visibility: auto` | Seed 500 rows; scroll | MEDIUM |
| Prefetch on `pointerdown`; LCP image `fetchpriority="high"` | Network panel on hover-then-click; view source | LOW |
| No `setState` inside a drag handler | Read `onDrag` bodies | MEDIUM |

## Onboarding, pricing, marketing (when present)

| Check | How to verify | Severity |
|---|---|---|
| Onboarding ≤ 5 steps; dots not bars; CTA pinned | Count; overlay consecutive screenshots | MEDIUM |
| Pricing plain: total and per-month, one paid tier, Close from frame one | Screenshot at t=0; read the numbers | HIGH |
| Marketing: no scroll fades, no hijack, no autoplay carousel | Scroll with Animations panel open | MEDIUM |
| OG image survives 200px and greyscale | Resize and desaturate the file | LOW |

## The greps

```
grep -rn "transition: all\|transition-all"
grep -rn "will-change"
grep -rn "100vh"
grep -rn "maximum-scale\|user-scalable"
grep -rn 'autocomplete="off"'
grep -rn "z-index: *9\{3,\}\|z-\[9"
grep -rn "backdrop-filter" | grep -v saturate
grep -rn "whileInView\|data-aos"
grep -rni "oops\|something went wrong\|are you sure"
grep -rn "prefers-reduced-motion"
grep -rn 'tabindex="[1-9]'
grep -rn "<img" | grep -v "alt="
```

## Before you ship

1. Keyboard-only pass, ring visible everywhere.
2. 320px and 200% zoom hold.
3. Dark mode screenshot of every screen.
4. Reduced motion emulated; app still responds.
5. Fast 3G: nothing spins before 300ms; skeletons match.
6. CLS 0; INP under 200ms.
7. Every button verb-first; every error says what to do.
8. One accent per view; contrast measured.
9. No `transition: all`; exits shorter than entrances.
10. Every target ≥ 44px on touch.
11. The greps above return nothing unjustified.
12. The design contract is committed and nothing in the diff contradicts it.
