# Files: uploading, attaching and downloading

Use this when anything leaves or enters the page as a file: an avatar, an attachment, a bulk import, a generated export, a drag from the desktop. Form fields in general are in `references/forms-and-inputs.md`; progress semantics in `references/states.md`.

File handling is where interfaces most often forget that the person is holding something they care about and cannot easily replace.

## Rules

1. **The drop zone is a convenience; the button is the interface.** Drag and drop is invisible, impossible on touch, and unavailable to keyboard users. Always ship a real `<input type="file">` behind a real label, then add dropping on top. Check: upload a file using only the keyboard.
2. **Style the label, never the input.** `<input type="file">` cannot be styled consistently and its button text cannot be changed. Visually hide the input, keep it focusable, and let a `<label>` carry the design. Never `display: none`, which removes it from the tab order. Check: tab to the control; a focus ring appears on the visible element.
3. **The whole drop target highlights, and it highlights on `dragenter`, not `dragover`.** Track a counter across `dragenter` and `dragleave`, because entering a child element fires a leave on the parent and makes a naive implementation flicker. Cancel `dragover` or the browser opens the file instead. Check: drag slowly across a drop zone containing text and buttons; the highlight does not flash.
4. **Validate before uploading, and say the limit before it is hit.** Type and size are checked on selection, and the accepted types and maximum size are printed next to the control, not revealed by an error. `accept` on the input filters the picker but guarantees nothing; check again in JavaScript, and again on the server. Check: pick a 40MB file into a 10MB field; you are told immediately, without a request.
5. **Rejection is per file and keeps the rest.** Dropping ten files where two are the wrong type uploads eight and explains the two. Never discard the whole batch, and never fail silently on the ones you skipped. Check: drop a mixed batch; eight upload and two are named with reasons.
6. **Show the file before it finishes.** The row appears immediately with the real name, the real size and a thumbnail generated locally from the `File` object, with progress on that row. The person needs to see that the right file was picked, which is knowable instantly and has nothing to do with the network. Check: pick a large image on a throttled connection; the thumbnail is there before the upload is.
7. **Progress per file, and a total only if there are more than about three.** A single indeterminate spinner for a batch tells nobody whether anything is happening. Bytes are the honest unit; a percentage that sits at 99 while the server processes is a lie, so switch the label to "Processing" when the transfer is done but the work is not. Check: watch a large upload; the label changes when the bytes finish.
8. **Cancel is available for the whole of a long upload.** An `AbortController` on the request and a real Cancel on the row. Anything that can take thirty seconds needs a way out that is not closing the tab. Check: cancel a large upload mid-flight; the request stops and the row is removed.
9. **Remove is not the same as cancel, and neither is undo.** Cancel stops an upload in progress. Remove deletes something already uploaded and should be undoable for a few seconds. If removal is genuinely permanent, say so on the button rather than in a dialog after. Check: the labels for the two states are different words.
10. **Failure keeps the file and offers Retry.** A failed upload leaves the row in place, in an error state, with the reason and a retry that does not require picking the file again. The browser still holds the `File`; making someone find it in Finder a second time is the whole failure. Check: kill the network mid-upload; Retry works without reopening the picker.
11. **Paste is an upload path.** Cmd-V with an image on the clipboard is how most screenshots enter a product. Handle `paste` on the relevant surface and read `event.clipboardData.files`. Check: take a screenshot and paste it into the composer.
12. **Never block paste or drop on a text field that accepts files.** And never intercept a drag that started inside the page as if it were an external file. Check: drag a selection of text within the page; no upload starts.
13. **Reserve the row's height before the thumbnail loads.** A list of attachments that reflows as each preview decodes is layout shift in its most avoidable form. Fixed row height, aspect-ratio box for the preview. Check: throttle and watch the list; nothing moves.
14. **A download names itself and its type.** A real filename with a real extension, and a `Content-Disposition` or a `download` attribute that agrees with it. `export.bin` or a UUID is a file nobody will find again. Include a date in anything periodic. Check: download and look in the Downloads folder a week later; you can tell what it is.
15. **A generated export is a state, not a spinner on a button.** Anything over about two seconds gets progress where the result will land, a label, and permission to leave the page. Over ten seconds it notifies on completion rather than holding someone hostage. Check: export a large file and navigate away; you are told when it is ready.
16. **The file input is labelled for a screen reader and announces what happened.** The control has a name, the selected file is announced, and progress goes through a live region rather than only a visual bar. Check: run the whole flow with a screen reader; you know what was selected, how far it got, and that it finished.

## Cheat sheet

| Thing | Value |
|---|---|
| Primary control | Real `<input type="file">` behind a `<label>`; drop zone added on top |
| Hiding the input | Visually hidden and focusable, never `display: none` |
| Drag highlight | Counter across `dragenter` / `dragleave`; cancel `dragover` |
| Limits | Printed next to the control before anything is picked |
| Validation | On selection, in JS, and again on the server. `accept` is a hint |
| Mixed batch | Upload what is valid, name what was not |
| Preview | Local thumbnail from the `File`, before the upload starts |
| Progress | Per file; a total past about three. Bytes, not a stuck 99% |
| Cancel | `AbortController`, available for the whole upload |
| Failure | Row stays, reason shown, Retry without re-picking |
| Paste | `paste` handler reading `clipboardData.files` |
| Download name | Real name, real extension, date if periodic |

## Code

```tsx
// dragenter fires again on every child, so count depth or the highlight flickers.
const depth = useRef(0);
const [over, setOver] = useState(false);

const zone = {
  onDragEnter: (e: React.DragEvent) => {
    e.preventDefault();
    depth.current += 1;
    setOver(true);
  },
  onDragLeave: () => {
    depth.current -= 1;
    if (depth.current === 0) setOver(false);
  },
  // Without this the browser navigates to the file instead of dropping it.
  onDragOver: (e: React.DragEvent) => e.preventDefault(),
  onDrop: (e: React.DragEvent) => {
    e.preventDefault();
    depth.current = 0;
    setOver(false);
    accept([...e.dataTransfer.files]);
  },
};

// The row exists before the network does, so the person can see they picked right.
function accept(files: File[]) {
  const [ok, bad] = partition(files, (f) => f.size <= MAX && TYPES.includes(f.type));
  setRows((r) => [...r, ...ok.map((f) => ({ file: f, url: URL.createObjectURL(f), sent: 0 }))]);
  if (bad.length) setSkipped(bad.map((f) => `${f.name}: ${reason(f)}`));
  ok.forEach(upload);
}
```

```css
/* Focusable, operable, invisible. Never display: none. */
.file-input {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden; clip-path: inset(50%);
  white-space: nowrap;
}
.file-input:focus-visible + label { outline: 2px solid var(--accent); outline-offset: 2px; }
```

## Checks

- Upload a file using only the keyboard.
- Drag slowly across a drop zone full of children; the highlight does not flicker.
- Pick a file over the size limit; you are told at once, with no request.
- Drop a mixed batch; the valid ones upload and the rest are named with reasons.
- Pick a large image on a throttled connection; the thumbnail appears before the upload finishes.
- Cancel mid-upload; the request actually aborts.
- Kill the network mid-upload; Retry works without reopening the picker.
- Paste a screenshot into the composer.
- Download an export and identify it from its filename a week later.
- Run the whole flow with a screen reader.

## Do not

- Ship a drop zone with no button.
- `display: none` the file input.
- Trust `accept` as validation.
- Throw away a whole batch because one file was wrong.
- Show a single indeterminate spinner for a multi-file upload.
- Sit at 99% while the server works.
- Make someone re-pick a file after a failed upload.
- Name a download `export.bin` or a UUID.
