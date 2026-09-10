# Finding the vibe, when there is no design system yet

Use this when the intake table came back mostly empty: no tokens, no written rules, a project built out of whatever SwiftUI gave by default. `references/design-contract-template.md` is where this ends up. This is how to get there with someone who knows exactly how they want their product to feel and has no vocabulary for it, which is most people.

Do not hand that template to someone in this position. It asks for a Display P3 triple and a spring bounce value. They will either guess, which produces a system nobody believes in, or go quiet, which produces no system at all. Ask about the feeling, then derive the numbers yourself and show them what you derived.

## How to run it

**Ask in one batch, not one at a time.** Use the host's structured question tool where there is one (in Claude Code that is AskUserQuestion, up to four at once); otherwise ask four numbered questions in a single message. A drip of one question per turn is exhausting and people start answering to make it stop.

**Always offer options, and mark one as your recommendation.** "What should it feel like?" is a blank page. Three named directions with a sentence each is a decision someone can actually make in ten seconds. Put your recommendation first and say it is one.

**Never ask for a number.** Not a hex code, not a font size, not a duration. If you find yourself asking what radius they want, you have skipped your own job.

**Six questions is the whole budget.** Purpose, comparables, register, density, weight, and voice. Everything else in the contract derives from those.

## The six questions

1. **What is this for, and how should someone feel while using it?** Offer three directions rather than a blank: *calm and unhurried* (a reading app, a journal, a planning tool), *quick and precise* (a dashboard, an editor, something used all day), *warm and personable* (a consumer app, something social, something people choose rather than are given). Their answer sets colour temperature, motion budget and copy voice all at once.

2. **Name two or three products you would be happy to be compared to.** This is the single highest-yield question and the one people answer instantly, because it is the only one they have already thought about. It is not a licence to copy: you are extracting the *properties* they are pointing at. Ask what specifically they like about each, because "I like Linear" can mean the density, the keyboard-first-ness, or the dark theme, and those imply different things.

3. **Who uses it, how often, and are they in a hurry?** Once ever, a few times a session, or a hundred times a day. This is the input to every motion decision in the skill and half the density ones. Someone reaching for it between meetings gets a different product from someone settling into it for an afternoon.

4. **Is this something people live in, or visit?** A tool people have open all day wants density, keyboard control and near-zero motion. Something visited weekly can afford space, a bigger type scale and more of an arrival. Getting this backwards is the most common cause of a product that feels wrong for reasons nobody can name.

5. **Should it feel more like paper, or more like glass?** A proxy question that works remarkably well and needs no vocabulary. Paper means matte, warm, flat, ink on a surface, no floating. Glass means cool, layered, translucent, things above other things. Most people answer without hesitating and it settles the whole surface treatment.

6. **How much personality should the words have?** *Plain* (says what happened, gets out of the way), *warm* (a human wrote this, but it is not trying to be funny), *characterful* (the writing is part of the product). Almost everyone who says characterful means warm. Say so, kindly, and offer warm as the recommendation.

## Deriving the contract from the answers

Do this yourself, then show them the result in plain language and let them push back on the feel rather than the values. "Warmer or cooler than this" is a question they can answer; "chroma 0.03 or 0.05" is not.

| They said | What it means for the contract |
|---|---|
| Calm and unhurried | Warm near-white canvas, one low-chroma accent, body at the larger end of the Dynamic Type range with prose leading 1.5, bounce 0 on everything, small continuous radii, materials only where the system already uses them |
| Quick and precise | Neutral canvas, one saturated accent on the primary action only, dense rows with a documented height and a 44pt target regardless, no animation on anything frequent, `.monospacedDigit()` on every figure that changes |
| Warm and personable | Warm canvas with a visible tint, an accent with real chroma, larger continuous radii, one bouncy token (0.2 to 0.32) reserved for a single moment, a fuller haptic budget, sentence-case copy with contractions |
| Lives in it all day | The 100x rule dominates: frequent actions do not animate. Density is a stated number. Dark mode is not optional. On iPad the hardware keyboard is a real input |
| Visits it weekly | Space over density, a bigger display step, an arrival worth having on the primary screen, and a widget is probably worth more than another tab |
| Paper | Matte surfaces, elevation by a step in value, faint shadows at most, low chroma, no materials behind content, and Liquid Glass on chrome only if at all |
| Glass | Materials on floating chrome, a real elevation ladder, Liquid Glass where the OS version allows with a solid fallback, every text colour tested over the lightest and darkest content that can scroll behind it |
| Plain voice | Verb-first labels naming the noun, no exclamation marks, errors that say what to do |
| Warm voice | The same, plus contractions and one sentence of acknowledgement where something took effort |
| Named a comparable | Extract the property, never the palette. Write it as a line in the contract: "dense like <product>" or "quiet like <product>", so the next person knows what was meant |

## What to hand back

Not the sixty-line reference. A filled fifteen-line contract, with a short plain-language summary above it in their words, and the two or three places you had to make a call so they can overrule you:

```
From what you said: a calm, unhurried reading tool that people open in the
evening a few times a week. Paper, not glass. Plain voice.

So I have set: a warm off-white canvas, a single ochre accent that only ever
means "saved", generous 68ch measure, and almost no motion, because nothing
here is frequent enough to need it.

Three calls you might want to change:
  - Light-first, with dark available. You did not say, and evening reading
    argues for dark-first if that is closer to the truth.
  - One accent only. A second colour would need a second meaning.
  - No celebration on finishing an article. It happens often enough that a
    moment would wear out by the third one.
```

Then the contract, then commit it as `DESIGN.md`, and only then start polishing.

## Do not

- Hand someone the technical template as a questionnaire.
- Ask for a hex code, a font size, a radius, or a duration.
- Ask more than about six questions before proposing something.
- Ask one question per turn.
- Offer a blank "what feeling do you want?" with no options.
- Copy a named comparable's palette or typeface. Extract the property.
- Start polishing before the contract is agreed. That is how a project gets a second style.
