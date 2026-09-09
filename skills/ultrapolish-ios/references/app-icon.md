# The app icon

Use this when designing, reviewing, or shipping an app icon, including the light, dark and tinted variants, alternate icons, and how the icon relates to the rest of the product. Liquid Glass rendering of the icon is in `references/liquid-glass.md`.

The icon is the only part of the product a person sees before they decide whether to open it, and after installation it competes with sixty others on a wallpaper you did not choose.

## Rules

1. **Design at 60pt, check at 29pt, deliver at 1024.** The Home Screen is 60pt and Settings is 29pt. An icon designed at 1024 and never looked at small is how a perfectly good mark becomes an unreadable texture in a Settings list. Check: render the 1024 master down to 29pt and look at it at real size on a device, not on a monitor.
2. **One idea, and no text.** No company name, no tagline, no version, no "beta" ribbon. The only defensible letterform is a brand that genuinely is a letter. Words do not survive 29pt, and the App Store already prints the name directly underneath. Check: cover the label and ask someone what the app does.
3. **No transparency, no rounded corners, no baked-in gloss.** A 1024x1024 opaque square. The system applies the mask, and on iOS 26 it applies the material as well, so a highlight painted into the artwork renders under a second highlight. Check: open the asset; the alpha channel is fully opaque and the corners are square.
4. **Ship the dark and tinted variants deliberately.** iOS 18 and later render three appearances. The tinted one is generated from a greyscale interpretation of the artwork, so a flat single-colour icon collapses into a featureless blob, and a design that relies on hue to separate its parts loses all of them. Give the mark internal luminance contrast so it survives. Check: view all three in Xcode's preview and in Settings; the tinted one is still recognisably the same icon.
5. **The dark variant is not the light one on a dark background.** Reduce the brightness of large light areas rather than inverting, keep the mark's identity, and let the system's dark background do the work rather than painting your own near-black square. Check: put both on the same wallpaper and confirm they read as one icon in two conditions, not two icons.
6. **Layered artwork, not a flat render, on iOS 26.** Icon Composer takes foreground, middle and background layers and lets the system apply the material, the specular highlight and the parallax. A pre-composited PNG gets none of that and looks visibly flat next to system apps. Check: no baked highlight, and the layers separate sensibly.
7. **Test it on a real wallpaper, next to real neighbours.** Not on white in a design tool. Put it on a photograph, on a dark wallpaper, and beside Mail, Photos and Settings. Icons that look confident in isolation frequently vanish next to the system set, which is mostly saturated and simple. Check: screenshot a real Home Screen with your icon in it.
8. **Fill the canvas the way the system apps do.** A mark floating in the middle of a large margin looks smaller than every icon around it, because the system's own icons run close to the edge. Match their optical weight rather than an arbitrary grid. Check: put yours in a row of system icons and compare how much of the tile each one occupies.
9. **The icon and the launch experience agree.** The first thing on screen after the icon should share its colour and its mark, so the transition from Home Screen to app is continuous. A blue icon opening to a white screen with a grey logo is two products. Check: launch from the Home Screen and watch the zoom.
10. **Alternate icons are a feature with a cost.** `setAlternateIconName` requires every alternate declared in the Info.plist and shipped at full size, and it triggers a system alert the user cannot suppress. Offer them only where identity genuinely matters to the person, and never as a paywall gate for something purely cosmetic unless the price is honest about that. Check: switching shows exactly one alert and the new icon survives a reboot.
11. **The icon is not a screenshot of the UI.** A tiny rendering of the app's own interface reads as noise at every size it is actually seen. Check: squint; you should see one shape, not a layout.
12. **A monochrome version exists, because several places demand one.** Notification grouping, some accessibility renderings and print all reduce the icon to a single colour. A mark that only separates by hue has nothing left. Check: fill the artwork with solid black on white; it still reads.

## Cheat sheet

| Thing | Value |
|---|---|
| Master | 1024x1024, opaque, square corners, no alpha |
| Appearances | Light, dark, tinted, all three authored |
| Tinted | Generated from greyscale; needs internal luminance contrast |
| iOS 26 | Layered artwork via Icon Composer, system applies the material |
| Sizes to check | 60pt Home Screen, 29pt Settings, 40pt Spotlight |
| Text in the icon | None, unless the brand is a single letter |
| Optical fill | Match the system apps, not a margin you invented |
| Alternates | Declared in Info.plist, full size each, one unsuppressable alert |

## Code

```swift
// Alternate icons: every name here also exists in Info.plist under
// CFBundleAlternateIcons with its own file, at full size.
func setIcon(_ name: String?) {
    guard UIApplication.shared.supportsAlternateIcons else { return }
    UIApplication.shared.setAlternateIconName(name) { error in
        if let error { print("icon change failed: \(error)") }
    }
}
```

## Checks

- Render the master to 29pt and look at it at real size on a device.
- View all three appearances; the tinted one is still recognisably the same icon.
- Screenshot a real Home Screen with your icon among the system apps, on a photographic wallpaper and a dark one.
- Compare optical fill with the icons either side of it.
- Launch from the Home Screen; the first frame of the app shares the icon's colour and mark.
- Fill the artwork with solid black; it still reads.
- Confirm the alpha channel is fully opaque and no corner rounding is baked in.

## Do not

- Design only at 1024.
- Put the app's name, a tagline, or a badge in the artwork.
- Ship transparency, pre-rounded corners, or a painted gloss highlight.
- Let the tinted variant be an afterthought.
- Invert the light icon and call it the dark one.
- Put a miniature of the interface in it.
- Float the mark in a large margin while every neighbour runs to the edge.
