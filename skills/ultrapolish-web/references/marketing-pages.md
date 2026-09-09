# Marketing pages

Use this when building or reviewing a landing page, a product page, a pricing page, a launch post, or the OG image that represents any of them. Marketing pages are where generic defaults show fastest, because every visitor has seen a thousand of them.

## Rules

1. **No scroll-triggered entrances.** No fade-up, fade-in, or translateY on sections as they scroll into view. Why: it is the single most recognisable generic default, it delays content, and it fails reduced motion by default. Check: `grep -rn "whileInView\|IntersectionObserver\|data-aos\|animate-on-scroll"`; each hit is a finding.
2. **No scroll hijacking, no non-1:1 parallax, no auto-advancing carousels.** Scroll belongs to the reader. Parallax that moves at a different rate than the finger is a vestibular trigger. A carousel that advances on its own hides content from the person reading it. Check: scroll with the trackpad; the page moves exactly as far as your fingers did.
3. **One orchestrated moment beats scattered effects.** Spend the motion budget on a single hero sequence, gated to once per session with `sessionStorage`, and keep everything else still. Why: one considered moment reads as craft; ten small ones read as a template. Check: count animated elements above the fold; one sequence, or none.
4. **Spend your boldness in one place.** One display face, or one unusual layout, or one strong colour field. Not all three. Check: name the one bold decision in a sentence.
5. **Hover transitions on every card are a tell.** Cards that are not links do not lift. Cards that are links change one thing (colour or underline), not three. Check: hover every card; it moves only if it goes somewhere.
6. **Refuse the five generic clusters.** These read as machine-made because they are the statistical average of every template:
   - Cream near `#F4F1EA`, a high-contrast serif display, a terracotta accent near `#D97757`.
   - Near-black background plus one acid green or vermilion accent.
   - Broadsheet layout: hairline rules, zero border-radius, dense newspaper columns.
   - The SaaS card kit: identical rounded cards, one radius on everything, the same `rgba(0,0,0,.1)` shadow under each, gradient washes as decoration.
   - Template chrome: tracked-out ALL-CAPS eyebrow above every heading; meta joined with middle dots; headlines shaped as a WORD, a spaced em dash, then a fragment; tinted near-blacks (`#0B0B0B`, `#111`) posing as black; a mono face for every small label; an arrow glyph appended to link text.
   Check: hold the page against each cluster; if two or more traits match, redesign that part. A project that already owns one of these as its house style keeps it; the tell is choosing it by default.
7. **Three typographic tells.** Accenting one word in a headline with italic, bold, or colour; all caps for labels; a typographic label above content that did not need one. Check: remove each; if nothing is lost, it was a tell.
8. **Numbered markers only for sequences.** 01 / 02 / 03 on three unrelated features is decoration. Check: could the items be reordered without loss? Then drop the numbers.
9. **Type discipline.** Line length under 80ch (serifs may run slightly longer and need more line-height). One or two families; if two, clearly distinct. Headlines 3–8 words. `text-wrap: balance` on headings. Check: measure the widest paragraph.
10. **The CTA says exactly what happens.** "Start a free trial", "Book a demo", "Download for Mac". Never "Get started", "Learn more" alone, "Submit". Check: every CTA is a verb plus its object.
11. **Pricing is on the page.** If the price is knowable, it is visible. See `references/onboarding-and-pricing.md`.
12. **Performance is part of the design.** `fetchpriority="high"` on the LCP image, explicit `width` and `height` on every image, `font-display: swap` with `size-adjust` so nothing shifts, `content-visibility: auto` on below-fold sections, no layout shift on load. Check: Lighthouse CLS is 0; LCP under 2.5s on a throttled mobile.
13. **Mobile first-fold check.** On a 375px phone, the first screen shows the headline, one line of what it is, and the CTA, with no scroll. Check: screenshot at 375×667.
14. **Accessibility floor, without announcing it.** Keyboard focus visible, reduced motion respected, contrast passes, real headings in order. Do not put an "accessible" badge on the page. See `references/accessibility.md`.
15. **Two passes.** First, write a compact token plan: 4–6 named colours, the type roles, a one-sentence layout idea. Review that plan against the brief and against rule 6 before building. Then build. Then screenshot and review again at 375 and 1280. Why: genericness is cheapest to catch before the CSS exists. Check: the plan exists as a comment or a file.
16. **A hero video shows the product working or it is a still.** A silent four-to-eight-second loop of the real interface doing one clear thing is the most convincing element the page can carry; people at desks, abstract shapes and drone footage are decoration paying a real performance cost. The poster is the LCP, not the video. See `references/media-playback.md` for the autoplay, codec and reduced-motion rules. Check: describe the video in one sentence; if it does not mention the product doing something, ship the still.

## OG images

The unfurl is the first impression on Slack, iMessage, LinkedIn, and X, and it renders at 200px wide in a sidebar.

| Spec | Value |
|---|---|
| Master | 1200×630 (1.91:1); X large card 1200×675 |
| Safe centre | 1000×500; nothing critical within 100px of any edge |
| Headline | ≥ 80px at master, 3–8 words, one weight contrast |
| Subhead | ≥ 40px; labels ≥ 28px; body ≥ 22px; floor 16px |
| Words that survive | ~4–6 at 200px, 6–10 at 300px, 12–18 at 600px |
| Focal point | One. Brand colour is the background, not an accent |
| Colour space | sRGB only; wide gamut desaturates in feeds |
| Weight | Under 1MB; JPEG for photo, PNG for crisp text; no GIF |
| Text in image | Never the URL; never "Click here"; the unfurl is the CTA |
| Test | 200×105 and greyscale; centre-crop the outer 100px |
| Cache | `?v=2` on change; Slack and iMessage cache for days |

```html
<meta property="og:image" content="https://example.com/og.png?v=2">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="Plain-language description of the image">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://example.com/og.png?v=2">
```

## Cheat sheet

| Element | Default |
|---|---|
| Scroll-triggered motion | none |
| Hero sequence | one, ≤ 1.2s total, once per session |
| Section rhythm | 64–96px desktop, 48–64px mobile |
| Headline | 3–8 words, `text-wrap: balance`, negative tracking only above 28px |
| Measure | ≤ 80ch |
| CTA | verb + object, one primary per fold |
| Images | explicit dimensions, `fetchpriority="high"` on the first |
| Below fold | `content-visibility: auto` |
| Cards | lift only if they navigate |

## Code

```css
.hero-media { content-visibility: visible; }
.section { content-visibility: auto; contain-intrinsic-size: auto 600px; }

h1, h2 { text-wrap: balance; }
p { text-wrap: pretty; max-width: 65ch; }

/* Links change one thing */
a.card:hover { border-color: var(--ink-3); }
```

```html
<img src="/hero.jpg" width="1200" height="800" fetchpriority="high" alt="The dashboard showing this week's revenue">
```

```ts
if (!sessionStorage.getItem("hero-played")) {
  playHero();
  sessionStorage.setItem("hero-played", "1");
}
```

## Copy on marketing pages

| Instead of | Write |
|---|---|
| "We're thrilled to announce" | The thing, in one sentence |
| "Get started" | "Start a free trial" |
| "Learn more" (alone, three times) | "Read the pricing", "See how sync works" |
| "Revolutionary AI-powered platform" | What it does, for whom, in plain words |
| Emoji bullets in a feature list | Plain bullets, or no list |
| A headline with one word in italic | The same headline, all one weight |
| "Trusted by 10,000+ teams" with no names | Three real names, or nothing |

Active voice, sentence case, no filler. Each written element does exactly one job.

## Checks

- Scroll the page with DevTools Animations panel open; nothing fires except the once-per-session hero.
- Screenshot at 375×667: headline, one line, CTA, no scroll.
- Hold the page against the five clusters; note matches.
- Every CTA reads as verb + object.
- Lighthouse: CLS 0, LCP under 2.5s throttled.
- OG image at 200×105 and in greyscale; still says one thing.
- Keyboard pass and reduced-motion pass.

## Do not

- Animate sections into view on scroll.
- Auto-advance a carousel.
- Lift a card that is not a link.
- Put an arrow glyph after link text.
- Cap every heading with an ALL-CAPS eyebrow.
- Number things that are not a sequence.
- Print the URL on the OG image.
- Introduce a display face the project does not already own.
