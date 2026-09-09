# Canvas and generated media

Use this when the product *is* the pixels: a design tool, an editor, a chart engine, a generative or game surface, anything drawn with `<canvas>`, WebGL, or WebGPU and anything that exports an image or a video.
A canvas is invisible to every tool the rest of this skill relies on. The DOM inspector shows one element, the accessibility tree shows nothing, and CSS reaches none of it. Everything below has to be done by hand.

## Rules

1. **A canvas is an image with no alt.** Give it `role="img"` and an `aria-label` that describes the current state in words, rebuilt whenever the state changes ("Isometric grid, 12 by 8, amber on charcoal"). A canvas with no name is announced as "canvas" or skipped entirely. Check: turn on VoiceOver or NVDA, land on the canvas, and hear a sentence that tells you what is drawn.
2. **A canvas that takes input is a control surface, not an image.** Pointer handlers on the element give a keyboard user nothing. Every action reachable by clicking the canvas needs a real focusable DOM control somewhere: a toolbar button, a list of layers, an arrow-key handler on a `tabIndex={0}` wrapper with `role="application"`. Check: unplug the mouse and complete the primary task.
3. **Changes that exist only as pixels must be announced in words.** A slider that redraws the canvas gives a sighted user instant feedback and a screen reader user silence. Put the meaning in `aria-valuetext`, not the raw number: `aria-valuetext="Grid spacing 24 pixels"`, not `24`. Check: drag every slider with a screen reader on; each one says what it changed, not a bare integer.
4. **Ask for the colour space or lose it silently.** `getContext("2d", { colorSpace: "display-p3" })` is required for wide-gamut output; without it every P3 value is clamped to sRGB with no warning. WebGL needs `drawingBufferColorSpace` and `unpackColorSpace`. Check: draw the same colour as P3 and as sRGB side by side on a wide-gamut display; if they match, the flag did not take.
5. **An invalid `fillStyle` is a silent no-op.** Assign an unparseable or out-of-gamut string and the assignment is ignored, the *previous* fill stays, and nothing throws. A whole render can come out in the last colour that happened to parse. Validate before assigning, or read the property back and compare. Check: assign a deliberately broken colour in the console; the canvas keeps painting, which is the bug.
6. **Back the canvas at `devicePixelRatio`, size it in CSS.** Set `canvas.width = cssWidth * dpr` and `canvas.style.width = cssWidth + "px"`, then `ctx.scale(dpr, dpr)`. A canvas sized only in CSS is blurry on every retina screen. Re-back it on resize *and* on a DPR change, which fires when a window moves between displays. Check: drag the window from a retina display to an external monitor and back; the drawing stays sharp.
7. **The render loop is the performance budget, not page load.** A 60fps loop leaves 16.7ms per frame and 8.3ms at 120Hz. Nothing else in `references/performance.md` matters if the loop misses. Check: the Performance panel shows frames inside budget while the loop runs, not just a fast first paint.
8. **Stop the loop when nobody can see it.** `IntersectionObserver` to stop when the canvas scrolls off screen, `visibilitychange` to stop when the tab is hidden. An unattended `requestAnimationFrame` is a battery bug that only shows up in someone else's laptop fan. Check: scroll the canvas away and hide the tab; the loop's frame counter stops.
9. **Restart from now, not from where you left off.** On resume, reset the loop's time origin. Restarting from a stale timestamp replays every millisecond the tab was hidden as one enormous jump. Check: hide the tab for a minute, return, and nothing fast-forwards.
10. **Never drive a render loop from React state.** A `setState` per frame re-renders the tree sixty times a second to change numbers React does not own. Keep the loop outside React and let it read a ref that React writes. Check: React DevTools' profiler records no commits while the canvas animates.
11. **Reduced motion reaches the loop only if you check it.** A CSS kill switch cannot touch `requestAnimationFrame`. Read `matchMedia("(prefers-reduced-motion: reduce)")` before starting ambient animation and render the settled frame instead, and listen for changes so a mid-session toggle takes effect. Motion that is the point of the product (a preview the user pressed play on) may continue; ambient drift may not. Check: enable Reduce Motion and reload; nothing moves on its own.
12. **One renderer, never a second draw path for export.** The export must call the same function as the preview with a different scale, or the file will diverge from what was on screen, quietly, forever. Check: export at preview size and diff against a screenshot of the canvas.
13. **Draw in design space and scale once.** Author coordinates against a fixed design size (`1920 × 1080`, say), and pass a scale factor into the renderer. Reading the on-screen size inside drawing code is what makes exports depend on the size of the browser window. Check: resize the window and export again; the file is identical.
14. **If changing the export resolution does not change the number of pixels in the file, the export path is a lie.** A resolution control that only changes metadata is worse than no control. Check: export at 1× and 4× and compare the actual pixel dimensions and file size.
15. **Await fonts and images before rendering for export.** `document.fonts.ready` and decoded images, or the export races the preview and drops a typeface that was visible on screen. Check: hard-reload and export immediately; the file has the right font.
16. **Give the result a real filename and a real type.** `toBlob` over `toDataURL` for anything large, an explicit MIME type and quality, and a filename with the document name and dimensions in it, not `download.png`. Check: export twice with different settings; the two files are distinguishable in a Downloads folder.
17. **Drag out and paste in.** A canvas people build things in should support dragging the result to the desktop (`DataTransfer` with `DownloadURL`) and pasting an image from the clipboard. Both are cheap and both are expected. Check: drag the canvas to the desktop; paste a screenshot into the app.
18. **Long jobs are states, not spinners.** An encode or a large export follows the loading ladder, keeps a cancel, and survives failure without unmounting the progress surface. See `references/states.md`; do not invent a second pattern here.
19. **Test in greyscale.** A generative surface is exactly where colour becomes the only channel carrying meaning. Check: DevTools Rendering, emulate achromatopsia; the drawing still reads.
20. **Guard the context.** `getContext` returns `null` when the canvas is too large, memory is exhausted, or the GPU process has died, and WebGL contexts are lost on sleep and on tab pressure. Handle `webglcontextlost` and re-create. Check: force a context loss with `WEBGL_lose_context`; the app recovers instead of showing a blank rectangle.

## Cheat sheet

| Budget | Value |
|---|---|
| Frame at 60Hz | 16.7ms |
| Frame at 120Hz | 8.3ms |
| Backing store | `cssSize × devicePixelRatio` |
| Design space | one fixed size, scale passed in |
| Export | `toBlob`, explicit MIME and quality |

| Concern | Mechanism |
|---|---|
| Name the canvas | `role="img"` + live `aria-label` |
| Announce a pixel-only change | `aria-valuetext` on the control that caused it |
| Keyboard access | real DOM controls, or `role="application"` + arrow keys |
| Wide gamut | `{ colorSpace: "display-p3" }` on the context |
| Stop off screen | `IntersectionObserver` |
| Stop when hidden | `visibilitychange` |
| Reduced motion | `matchMedia`, checked in JS |
| Long export | `references/states.md` ladder |

| Trap | What happens |
|---|---|
| No `colorSpace` | wide-gamut values clamp to sRGB, silently |
| Invalid `fillStyle` | assignment ignored, previous colour persists, no error |
| CSS-only sizing | blurry on every retina display |
| Loop resumed from stale time | one enormous jump on return |
| Second draw path for export | file diverges from preview, quietly |
| `setState` per frame | sixty React commits a second |

## Code

Backing store, DPR, and re-backing on display change:

```ts
function fit(canvas: HTMLCanvasElement, cssW: number, cssH: number) {
  const dpr = window.devicePixelRatio || 1;
  canvas.width = Math.round(cssW * dpr);
  canvas.height = Math.round(cssH * dpr);
  canvas.style.width = `${cssW}px`;
  canvas.style.height = `${cssH}px`;
  const ctx = canvas.getContext("2d", { colorSpace: "display-p3" });
  ctx?.setTransform(dpr, 0, 0, dpr, 0, 0);
  return ctx;
}

// devicePixelRatio changes when the window moves between displays.
function watchDpr(onChange: () => void) {
  let mq: MediaQueryList;
  const listen = () => {
    mq = matchMedia(`(resolution: ${window.devicePixelRatio}dppx)`);
    mq.addEventListener("change", () => { onChange(); listen(); }, { once: true });
  };
  listen();
}
```

An invalid colour is a no-op, so validate before assigning:

```ts
const probe = document.createElement("canvas").getContext("2d")!;
export function isPaintable(colour: string) {
  probe.fillStyle = "#000";
  probe.fillStyle = colour;            // ignored if unparseable
  const black = probe.fillStyle;
  probe.fillStyle = "#fff";
  probe.fillStyle = colour;
  return black === probe.fillStyle;    // same result from both starts means it parsed
}
```

A loop that stops when unseen, respects reduced motion, and never sets React state:

```ts
export function startLoop(canvas: HTMLCanvasElement, state: { current: Params }) {
  const reduce = matchMedia("(prefers-reduced-motion: reduce)");
  let raf = 0, origin = 0, visible = true, onScreen = true;

  const frame = (now: number) => {
    if (!origin) origin = now;              // restart from now, not from a stale origin
    render(canvas, state.current, now - origin);
    raf = requestAnimationFrame(frame);
  };
  const run = () => {
    if (raf || !visible || !onScreen) return;
    if (reduce.matches) { render(canvas, state.current, Number.POSITIVE_INFINITY); return; }
    origin = 0;
    raf = requestAnimationFrame(frame);
  };
  const stop = () => { cancelAnimationFrame(raf); raf = 0; };

  const io = new IntersectionObserver(([e]) => { onScreen = e.isIntersecting; onScreen ? run() : stop(); });
  io.observe(canvas);
  const onVis = () => { visible = !document.hidden; visible ? run() : stop(); };
  document.addEventListener("visibilitychange", onVis);
  reduce.addEventListener("change", () => { stop(); run(); });

  run();
  return () => { stop(); io.disconnect(); document.removeEventListener("visibilitychange", onVis); };
}
```

One renderer, two callers, design space in and a scale factor:

```ts
const DESIGN = { w: 1920, h: 1080 };

export function render(target: CanvasRenderingContext2D, p: Params, t: number, scale = 1) {
  target.save();
  target.scale(scale, scale);            // every coordinate below is design space
  drawScene(target, p, t, DESIGN);
  target.restore();
}

export async function exportPng(p: Params, multiplier: number) {
  await document.fonts.ready;
  const c = document.createElement("canvas");
  c.width = DESIGN.w * multiplier;       // resolution really changes the pixels
  c.height = DESIGN.h * multiplier;
  const ctx = c.getContext("2d", { colorSpace: "display-p3" })!;
  render(ctx, p, 0, multiplier);         // the same function the preview calls
  return new Promise<Blob>((res) => c.toBlob((b) => res(b!), "image/png"));
}
```

Name the canvas and announce what a control changed:

```tsx
<canvas
  ref={ref}
  role="img"
  aria-label={`Isometric grid, ${cols} by ${rows}, ${paletteName}`}
/>

<input
  type="range"
  min={8} max={64}
  value={spacing}
  aria-label="Grid spacing"
  aria-valuetext={`Grid spacing ${spacing} pixels`}
  onChange={(e) => setSpacing(+e.target.value)}
/>
```

Drag the artwork out as a file, and accept a pasted image:

```ts
canvas.addEventListener("dragstart", (e) => {
  const url = canvas.toDataURL("image/png");
  e.dataTransfer?.setData("DownloadURL", `image/png:${name}.png:${url}`);
});

window.addEventListener("paste", async (e) => {
  const file = [...(e.clipboardData?.files ?? [])].find((f) => f.type.startsWith("image/"));
  if (file) place(await createImageBitmap(file));
});
```

Recover a lost WebGL context:

```ts
canvas.addEventListener("webglcontextlost", (e) => { e.preventDefault(); stop(); });
canvas.addEventListener("webglcontextrestored", () => { rebuildResources(); run(); });
```

## Checks

- Screen reader lands on the canvas and hears a description of what is drawn, not "canvas".
- Every slider announces meaning, not a bare number.
- Unplug the mouse and complete the primary task.
- Enable Reduce Motion, reload; nothing moves on its own; a pressed play still plays.
- Scroll away and hide the tab; the frame counter stops. Return; nothing fast-forwards.
- React profiler records no commits while the canvas animates.
- Move the window between displays; the canvas stays sharp.
- Export at 1× and 4×; pixel dimensions differ by exactly 4.
- Export at preview size and diff against a screenshot of the canvas.
- DevTools Rendering, emulate achromatopsia; the drawing still reads.
- Force a context loss with `WEBGL_lose_context`; the app recovers.

## Do not

- Ship a `<canvas>` with no accessible name.
- Put the only path to an action behind a click on the canvas.
- Send a raw number to `aria-valuetext`.
- Assume a colour assigned to `fillStyle` was accepted.
- Size a canvas in CSS alone.
- Leave `requestAnimationFrame` running off screen or in a hidden tab.
- Resume a loop from the timestamp it was paused at.
- Call `setState` inside a frame callback.
- Write a second draw path for export.
- Ship a resolution control that does not change the file's pixel dimensions.
- Export before `document.fonts.ready`.
- Name the file `download.png`.

See `references/performance.md` for the frame budget and `visibilitychange`, `references/states.md` for long exports, `references/color.md` for OKLCH and gamut, `references/accessibility.md` for live regions and reduced motion.
