# The favicon and app icon set

Use this when a site or app needs its icon: the browser tab, the bookmark, the phone home screen when someone installs it, the tab strip with forty tabs open. Covers the design craft and the exact files to ship.

The favicon is the smallest thing you will design and the one seen most often. At 16 pixels you have about two hundred and fifty pixels to work with, and a person picking your tab out of forty is not reading it, they are matching a shape and a colour.

## Rules

1. **Design it at 16px first, not at 512.** Everyone designs the big one and scales down, which is why so many favicons are a grey smudge. Start at 16, get it working, then scale up and add detail the larger sizes can carry. If the mark only works at 512 it is not a favicon, it is a logo. Check: render at 16 and look at it at real size on a real screen, not zoomed.
2. **One idea, and never the wordmark.** A letter, a shape, or the one distinctive part of the mark. Company names do not survive the resolution, and a full logo lockup at 16px is a rectangle of mud. If the brand is genuinely a single letter, use it. Check: cover the site name and ask someone which tab is yours.
3. **The silhouette test.** Convert to greyscale, blur by two pixels, and put it in a row with the twenty favicons your users actually have open: Gmail, GitHub, Notion, Slack, Google Docs. If it disappears, the problem is the shape, not the colour. Distinct silhouette first, colour second, detail last or never. Check: do exactly that, with real competitors.
4. **A favicon fills its box; an app icon does not.** The browser gives a favicon no margin, so artwork with generous padding baked in renders tiny. Home-screen icons are the opposite and need their safe zone respected. These are different files for a reason; do not ship one for both. Check: put the favicon next to another site's in the same tab strip and compare optical size.
5. **Never bake in rounded corners or a shadow.** Every platform masks the icon to its own shape, so a pre-rounded square gets rounded twice and shows a pale halo at the corners. Ship a full-bleed square. Check: install to a home screen on iOS and Android and look at the corners.
6. **`apple-touch-icon` must be opaque.** iOS composites transparency onto black, so an icon with a transparent background that looked right on white becomes an unreadable dark square on the home screen. Paint the background. 180x180 covers every current device. Check: install to an iPhone home screen and look at it on a light wallpaper.
7. **Maskable icons keep everything important inside the middle 80%.** Android crops to whatever shape the launcher wants, from a circle to a squircle, so a maskable icon needs a full-bleed background and its content inside a centred circle of 80% diameter. Ship it as a separate manifest entry with `purpose: "maskable"`; the same file cannot serve both purposes well. Check: preview it as a circle and confirm nothing important is clipped.
8. **The SVG favicon can answer dark mode; the PNG cannot.** A `prefers-color-scheme` media query inside the SVG lets a dark-on-light mark flip for people using a dark browser chrome, which is the difference between visible and invisible in a dark tab strip. Check: switch the OS to dark and look at the tab.
9. **`theme-color` is per scheme and it is not the brand colour by default.** It paints the browser chrome on Android and the Safari surround on iOS, so it should be the colour of the top of the page, not the logo. Two declarations, one per scheme. A brand purple bar above a white page looks like a mistake. Check: open on Android and iOS and see whether the seam is invisible.
10. **Ship the ICO as well, and put it at the root.** `favicon.ico` at `/favicon.ico` is still requested directly by feed readers, crawlers, chat unfurlers and older browsers that never look at your markup. Make it a multi-size ICO holding 16, 32 and 48. Check: request `/favicon.ico` directly and confirm a 200.
11. **The icon is not the OG image.** An open-graph card is 1200x630 and read at a glance in a feed, so it carries the name and usually the page's subject; the icon carries neither. Designing one from the other produces a bad version of both. Check: they are different files with different content.
12. **A monochrome variant exists for the places colour is stripped.** Pinned tabs, some launchers, watch complications and print all render a single colour. A mark that is only legible because of a gradient has nothing left. Check: fill the shape with solid black and confirm it still reads.

## Cheat sheet

| File | Size | Notes |
|---|---|---|
| `/favicon.ico` | 16, 32, 48 in one file | At the document root, requested without markup |
| `/icon.svg` | vector | Primary favicon; may carry a dark-mode query inside |
| `/apple-touch-icon.png` | 180x180 | Opaque, full bleed, no rounded corners |
| manifest `icons[]` | 192x192, 512x512 | `purpose: "any"` |
| manifest maskable | 512x512 | `purpose: "maskable"`, content inside the centre 80% |
| `theme-color` | one per scheme | The colour of the top of the page, not the brand |
| OG image | 1200x630 | A different design, not the icon scaled up |

## Code

```html
<link rel="icon" href="/icon.svg" type="image/svg+xml">
<link rel="icon" href="/favicon.ico" sizes="32x32">
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
<link rel="manifest" href="/site.webmanifest">

<!-- The seam between chrome and page, not the logo colour. -->
<meta name="theme-color" content="#faf9f7" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#141414" media="(prefers-color-scheme: dark)">
```

```svg
<!-- icon.svg: one mark that survives a dark tab strip. -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
  <style>
    .mark { fill: #141414 }
    @media (prefers-color-scheme: dark) { .mark { fill: #faf9f7 } }
  </style>
  <path class="mark" d="..."/>
</svg>
```

```json
{
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png", "purpose": "any" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png", "purpose": "any" },
    { "src": "/icon-maskable.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ]
}
```

In a Next.js App Router project the same set is produced by file convention: `app/favicon.ico`, `app/icon.svg`, and `app/apple-icon.png`, which are emitted with the right `<link>` tags automatically. Do not hand-write the tags as well or they ship twice.

## Checks

- Render at 16px on a real screen at real size, next to twenty real favicons.
- Greyscale and blur by 2px; the silhouette is still yours.
- Request `/favicon.ico` directly; it returns 200.
- Install to an iPhone home screen on a light wallpaper; the icon is opaque and the corners are clean.
- Preview the maskable icon as a circle; nothing important is clipped.
- Switch the OS to dark; the tab icon is still visible.
- Fill the mark with solid black; it still reads.

## Do not

- Design at 512 and scale down.
- Put the company name in it.
- Bake in rounded corners, a border, or a drop shadow.
- Ship a transparent `apple-touch-icon`.
- Use one PNG for the favicon, the touch icon and the maskable icon.
- Set `theme-color` to the brand colour without looking at the seam.
- Reuse the OG image as the icon or the icon as the OG image.
