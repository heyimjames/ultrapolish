# Haptics and sound on the web

Use this when someone asks for vibration, "a satisfying click", or sound effects in a web app or PWA. The honest answer is usually "less than you think": the web has a thin haptic API on Android, none on iOS Safari, and sound that ignores the ringer switch. Visual and motion feedback carry the load; see `references/motion.md` and `references/buttons-and-controls.md`.

## Rules

1. **Haptics fire on `pointerdown`, never on `click`.** A haptic must arrive within ~50ms of contact to read as "the button heard me"; `click` fires on release, 100–150ms later, and the pulse lands after the visual change. Check: the vibrate call is in an `onPointerDown` handler.
2. **Only for commit moments.** Press-down on a primary action, a toggle flip, a successful submit, an error. Never on scroll, hover, page load, an element appearing, or a list item rendering. Check: no vibrate call lives in a scroll, intersection, or effect-on-mount handler.
3. **Feature-detect and expect absence.** `navigator.vibrate` exists on Android Chrome and Firefox. It does not exist on iOS Safari or desktop, and it returns `false` silently when blocked. The interface must feel complete with zero haptics. Check: with `navigator.vibrate` deleted in the console, nothing errors and nothing feels missing.
4. **Do not rely on the iOS switch trick.** Creating an `<input type="checkbox" switch>` and clicking it inside a user-gesture task triggers the system toggle haptic on iOS 17.4+. It is undocumented, breaks across versions, and can fire an unwanted change event. If you use it, feature-detect the `switch` attribute, wrap it in try/catch, remove the element on the next frame, and treat it as a bonus. Check: the app has no code path that requires it to work.
5. **Keep pulses short and few.** Light 8ms, medium 15ms, heavy 25ms, error `[10, 40, 10]`. Anything longer reads as a notification, not a touch. Check: no single pulse over 25ms outside an explicit error pattern.
6. **Sound is almost always wrong.** Web audio ignores the hardware ringer switch, plays through whatever the user is listening to, and needs a gesture to unlock. Interface sounds in a general-purpose site or app surprise people in meetings. Check: a sound cue exists only in an app where sound is the product (metronome, timer, game, meditation, music).
7. **When sound is the product, it is opt-in with a persistent toggle and its own volume.** `prefers-reduced-motion` says nothing about sound; provide a separate control, remember it, and default to the quieter option. Check: a sound toggle is reachable from settings and is persisted.
8. **Unlock audio on the first gesture, then keep it warm.** Create one `AudioContext` on the first `pointerdown`, `resume()` it, and reuse it. Preload buffers. A cue that arrives late is worse than no cue. Check: the first cue plays with no delay after the first interaction.
9. **Cues are under 200ms and land in the same frame as the visual.** A cue is punctuation; a haptic, a cue, and the visual change should be indistinguishable in time. Check: trigger the visual change and the cue from the same handler, not from a `setTimeout` or a network callback.
10. **Respect the platform's own feedback.** Native `<input type="range">`, `<select>`, and switches on mobile already tick or click on some devices; do not layer your own on top. Check: no vibrate call on a native control's `change`.

## Cheat sheet

| Moment | Pattern (ms) | Where |
|---|---|---|
| Primary press-down | `8` | `onPointerDown` |
| Toggle flip, chip select | `8` | `onPointerDown` |
| Commit (submit, save) | `15` | on success, same frame as the visual |
| Destructive confirm | `25` | on the confirm press-down |
| Error | `[10, 40, 10]` | with the inline error |
| Scroll, hover, load, appear | none | |

| Platform | `navigator.vibrate` | Notes |
|---|---|---|
| Android Chrome / Firefox | yes | may be throttled or disabled by the OS |
| iOS Safari | no | switch-input trick is fragile |
| Desktop browsers | no | |

| Sound | Allowed |
|---|---|
| General app or site | no |
| Sound-first product (timer, metronome, game, meditation, music) | yes, opt-in, own toggle, own volume, cues < 200ms |

## Code

A guarded haptic helper:

```ts
type Pulse = "light" | "medium" | "heavy" | "error";
const PATTERN: Record<Pulse, number | number[]> = { light: 8, medium: 15, heavy: 25, error: [10, 40, 10] };

export function haptic(kind: Pulse = "light") {
  if (typeof navigator === "undefined" || typeof navigator.vibrate !== "function") return;
  try { navigator.vibrate(PATTERN[kind]); } catch { /* blocked or unsupported: nothing to do */ }
}
```

Wired to press-down, alongside the visual press:

```tsx
<button onPointerDown={() => haptic("light")} className="press">Save</button>
```

The iOS switch trick, only as a bonus and only inside a user gesture:

```ts
export function iosSwitchHaptic() {
  const input = document.createElement("input");
  input.type = "checkbox";
  input.setAttribute("switch", "");
  if (!("switch" in input) && !input.hasAttribute("switch")) return; // no support, no attempt
  input.style.cssText = "position:fixed;opacity:0;pointer-events:none";
  document.body.appendChild(input);
  try { input.click(); } catch { /* ignore */ }
  requestAnimationFrame(() => input.remove());
}
```

Audio, unlocked once and reused:

```ts
let ctx: AudioContext | null = null;
const buffers = new Map<string, AudioBuffer>();

export async function unlockAudio() {
  ctx ??= new AudioContext();
  if (ctx.state === "suspended") await ctx.resume();
}

export async function loadCue(name: string, url: string) {
  ctx ??= new AudioContext();
  const data = await (await fetch(url)).arrayBuffer();
  buffers.set(name, await ctx.decodeAudioData(data));
}

export function playCue(name: string, volume = 0.3) {
  if (!ctx || !buffers.has(name) || !settings.soundEnabled) return;
  const src = ctx.createBufferSource();
  const gain = ctx.createGain();
  gain.gain.value = volume;
  src.buffer = buffers.get(name)!;
  src.connect(gain).connect(ctx.destination);
  src.start();
}

document.addEventListener("pointerdown", unlockAudio, { once: true });
```

Same frame, same handler:

```tsx
function onComplete() {
  setDone(true);          // visual
  haptic("medium");       // touch
  playCue("done", 0.3);   // sound, only if the product is sound-first
}
```

## Checks

- Every vibrate call is inside `onPointerDown` or a commit handler; none inside scroll, hover, mount, or intersection code.
- Delete `navigator.vibrate` in the console; the app behaves identically.
- On iOS Safari with the switch trick disabled, nothing is missing.
- Sound cues, if any, are under 200ms and play only when the persisted toggle is on.
- First cue after page load plays with no delay.
- Toggling `prefers-reduced-motion` does not silence or enable sound; the separate toggle does.

## Do not

- Vibrate on `click`, on scroll, on hover, or on appearance.
- Ship a code path that depends on the iOS switch trick.
- Play interface sounds in a general-purpose app.
- Autoplay any sound before a user gesture.
- Tie sound to the reduced-motion preference.
- Layer a haptic on a native control that already provides one.
