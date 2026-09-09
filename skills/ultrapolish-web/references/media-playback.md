# Video and audio playback

Use this when the page plays something: a hero clip, a product demo, a podcast, a lesson, a user's upload. `<canvas>` rendering and export are in `references/canvas-and-media.md`; scroll behaviour in `references/scroll.md`.

A player is a control surface that people use in the dark, one-handed, on a train, while doing something else. Almost every rule below exists because of that.

## Rules

1. **Autoplay only when it is silent, decorative and short.** `autoplay muted playsinline loop` with no controls is a moving image, not a video, and is the only autoplay that is defensible. Anything with sound waits for a real gesture. Browsers will block it anyway; the point is not to design around a block you deserved. Check: load the page with the sound on; nothing makes a noise.
2. **A background video is decoration and must be removable.** Under `prefers-reduced-motion: reduce`, show the poster and do not play. Under a metered or saved-data connection, do the same. Check: turn on Reduce Motion; the hero is a still image and the page is not broken.
3. **`playsinline` or iOS takes over the screen.** Without it, iPhone Safari opens every video full screen on play, which destroys any layout that had the video as part of a composition. Check: play on an iPhone; the video stays where it was.
4. **The poster is a real frame, sized to the video, and preloaded.** Without a poster the element is a black rectangle until the first frame decodes. With a poster of the wrong aspect ratio it letterboxes and shifts. Set `width`, `height` and `aspect-ratio` so the box is reserved before anything loads. Check: throttle to slow 3G; the space is held and a real image is in it.
5. **Custom controls are a commitment to rebuild all of them.** The native ones already give you keyboard access, captions, playback rate, picture-in-picture, AirPlay and the system media keys. If you replace them, you owe every one of those. Most products should style the container and keep `controls`. Check: with custom controls, use the player entirely from the keyboard, then check the OS media keys still work.
6. **Space plays and pauses, arrows seek, and focus decides which.** Space is the universal play toggle when the player has focus, and must not scroll the page instead. Left and right seek five seconds, up and down change volume, `f` is full screen, `m` is mute. None of them fire while focus is in a text field. Check: focus the player and press space; it plays and the page does not scroll.
7. **The scrub bar is bigger than it looks and shows where you would land.** A 4px line is a 4px line to look at and a 24px target to hit, expanded with a pseudo-element. Dragging shows the timestamp, and on video a thumbnail of that frame if you have one. Seeking follows the finger linearly, never with a spring. Check: scrub on a phone with a thumb; you can land on a second.
8. **Time is shown as elapsed and total, in tabular figures, and does not jump.** `font-variant-numeric: tabular-nums` or the layout twitches every second. Show remaining only if the product is about remaining. Check: watch the timer for ten seconds; nothing moves except the digits.
9. **Buffering is not the same as paused, and the control must say which.** A spinner over the play button when the network stalls, and the play state itself unchanged. A player that silently shows a play triangle while it is actually buffering teaches people to press it twice. Check: throttle mid-playback; the state is legible.
10. **Captions are a feature, not an accessibility checkbox.** Ship a real `<track kind="captions">`, default it on where the content is speech-led, and style the cue background so it is readable over any frame. Most people watching in public have the sound off. Check: play with the sound off and follow the content.
11. **Audio deserves a waveform or nothing, never a fake one.** A generated waveform that does not match the audio is a lie about the content and people do use it to navigate. If you cannot compute it, show a plain progress bar. Check: compare a loud passage to the waveform.
12. **One thing plays at a time.** Starting one player pauses every other on the page. Two audio sources overlapping is never what anyone wanted. Check: start a second player; the first stops.
13. **Remember the position for anything over a few minutes.** Long-form content resumes where it was left, per item, and says that it is resuming with a way to start over. Check: leave halfway, come back tomorrow, and you are offered the right thing.
14. **Never animate the player's own chrome on a timer.** Controls fade out after about three seconds of no pointer movement and return instantly on any movement, keypress or touch. They never fade while the pointer is over them, and never while paused. Check: pause and wait; the controls stay.
15. **Reserve the aspect ratio and never letterbox by accident.** `aspect-ratio` on the container with `object-fit: contain` for unknown sources and `cover` only where cropping is intended. Vertical video in a horizontal box with `cover` cuts people's heads off. Check: play a 9:16 clip in the component.

## Cheat sheet

| Thing | Value |
|---|---|
| Defensible autoplay | `autoplay muted playsinline loop`, no controls, decorative only |
| Reduced motion | Poster only, no playback |
| iOS | `playsinline`, always |
| Poster | Real frame, correct aspect ratio, box reserved with `aspect-ratio` |
| Controls | Keep native unless you will rebuild keyboard, captions, rate, PiP, media keys |
| Keys | Space toggles, arrows seek 5s and volume, `f` full screen, `m` mute |
| Scrub target | 24px minimum, expanded from a 4px visual |
| Seeking | Linear, follows the finger, never a spring |
| Time | Tabular figures, elapsed and total |
| Captions | Real `<track>`, on by default for speech-led content |
| Concurrency | One player at a time |
| Controls fade | ~3s of no input, never while paused or hovered |

## Code

```html
<!-- Decorative hero: silent, inline, and it holds its box before it loads. -->
<video
  class="hero-video"
  autoplay muted loop playsinline
  poster="/hero-poster.avif"
  width="1600" height="900"
></video>
```

```css
.hero-video { aspect-ratio: 16 / 9; width: 100%; object-fit: cover; }

/* Decoration is not worth a autoplaying video to someone who asked for less motion. */
@media (prefers-reduced-motion: reduce) {
  .hero-video { display: none; }
  .hero-poster { display: block; }
}

/* A 4px line to look at, a 24px target to hit. */
.scrubber { position: relative; height: 4px; }
.scrubber::before { content: ""; position: absolute; inset: -10px 0; }
```

```ts
// Space belongs to the player when the player has focus, and to the page otherwise.
player.addEventListener("keydown", (e) => {
  const t = e.target as HTMLElement;
  if (t.closest("input, textarea, [contenteditable]")) return;
  if (e.key === " ") { e.preventDefault(); video.paused ? video.play() : video.pause(); }
  if (e.key === "ArrowRight") video.currentTime += 5;
  if (e.key === "ArrowLeft") video.currentTime -= 5;
});

// Two things playing at once is never what anyone wanted.
video.addEventListener("play", () => {
  document.querySelectorAll("video, audio").forEach((el) => {
    if (el !== video) (el as HTMLMediaElement).pause();
  });
});
```

## Checks

- Load the page with the sound up; nothing makes a noise.
- Turn on Reduce Motion; the hero is a still and the page still works.
- Play on an iPhone; the video does not go full screen.
- Throttle to slow 3G; the box is reserved and a real poster is in it.
- Operate the whole player from the keyboard, and confirm the OS media keys work.
- Focus the player and press space; it plays and the page does not scroll.
- Scrub with a thumb on a phone; you can land on a specific second.
- Throttle mid-playback; buffering and paused look different.
- Watch with the sound off and follow it from the captions.
- Start a second player; the first stops.
- Play a 9:16 clip in the component and check nothing is cropped off.

## Do not

- Autoplay anything with sound.
- Omit `playsinline`.
- Ship a video with no poster and no reserved box.
- Replace the native controls without rebuilding keyboard, captions and media keys.
- Let space scroll the page while the player has focus.
- Put a 4px hit target on the scrubber.
- Animate seeking with a spring.
- Fake a waveform.
- Let two things play at once.
- Fade the controls out while paused.
